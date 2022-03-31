
import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:milk/entities/Model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'DateTimeExt.dart';

// ignore: camel_case_types
abstract class db {

	static Database? _db;

	static int get _version => 1;
	static bool get isNull => _db == null;

	static const String _dbName = 'milk.db';

	static void init() async {
		if (_db != null) return;

		io.Directory appDict = await getApplicationDocumentsDirectory();

		String dbPath = path.join(appDict.path, _dbName);

		if (!await io.File(dbPath).exists()) {
			ByteData data = await rootBundle.load(path.join('assets', _dbName));
			List<int> bytes = data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
			await io.File(dbPath).writeAsBytes(bytes);
		}

		_db = await openDatabase(dbPath, version: _version);
	}

	static Future<List<Map<String, dynamic>>> get(String sql) async => await _db!.rawQuery(sql);

	static Future<int> insert (Model model) async => await _db!.insert(model.table, model.toMapDB());
	static Future<int> update (Model model) async => await _db!.update(model.table, model.toMapDB(), where: '${model.pk} = ?', whereArgs: [model.id]);
	static Future<int> delete (Model model) async => await _db!.delete(model.table, where: '${model.pk} = ?', whereArgs: [model.id]);

	static sync(Map<String, dynamic> data) {
		data.forEach((table, rows) async {
			for (var row in (rows as List<dynamic>)) {
				if (row.length > 1) {
					String sql = '';
					String sqlV = '';
					List<dynamic> values = [];

					row.forEach((field, value) {
						sql += ' $field,';

						sqlV += value != null ? ' ?,' : ' NULL,';
						if (value != null) values.add(value);
					});

					sql = sql.substring(0, sql.length - 1);
					sqlV = sqlV.substring(0, sqlV.length - 1);

					await _db!.rawQuery('INSERT OR REPLACE INTO $table($sql) VALUES($sqlV);', values);

				} else if (row.length == 1) {
					await _db!.rawQuery('DELETE FROM $table WHERE ${row.keys.elementAt(0)} = ?;', [row.values.elementAt(0)]);
				}
			}
		});
	}

  static getProds() => get('SELECT prodID AS id, prodName AS name FROM prods ORDER BY prodName;');
  static getProdUnits(int prodID) => get('SELECT unitID id, unitName name, puID, puPrice price FROM (SELECT puID, unitIDfk FROM prodUnits WHERE prodIDfk = $prodID AND puStatus = 1) AS pu JOIN units ON unitID = unitIDfk JOIN (SELECT puIDfk, pupDate, puPrice FROM (SELECT puIDfk, MAX(pupDate) OVER(PARTITION BY puIDfk) pupDateMax, pupDate, puPrice FROM prodUnitPrices) p WHERE pupDateMax = pupDate) pup ON puID = puIDfk;');
  // static getProdUnits(int prodID) => get('SELECT unitID AS id, unitName AS name, puID FROM (SELECT puID, unitIDfk FROM prodUnits WHERE prodIDfk = $prodID) LEFT JOIN units ON unitID = unitIDfk;');

  static getProdUnitPrice(int prodID, DateTimeExt onDate) => get('SELECT puIDfk, MAX(pupDate) AS pupDate FROM prodUnitPrices WHERE puIDfk = $prodID AND pupDate < \'${onDate.getYMD()}\' GROUP BY puIDfk;');

  static getUnits() => get('SELECT unitID AS id, unitName AS name FROM units ORDER BY unitName;');

  static getProds4Order() => get('SELECT prodID AS id, prodName AS name FROM prods WHERE prodType = 1 ORDER BY prodName;');

  static getAgents() => get('SELECT agentID AS id, agentName AS name, agentPhone AS phone, agentAdress AS adress FROM agents WHERE agentType = 1;');
}


import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'entities/Agent.dart';
import 'entities/Order.dart';
import 'entities/Prod.dart';
import 'entities/ProdUnit.dart';
import 'entities/Unit.dart';
import 'utils/db.dart';
import 'utils/api.dart';

abstract class core {

	static SharedPreferences? sp;
	static bool get isWeb => kIsWeb;

	static initSP () async {
		sp ??= await SharedPreferences.getInstance();
		sp!.setInt('lastUpdate', sp!.getInt('lastUpdate') ?? 1);
	}

	// --- PRODS --- //

	static getProds() async => convertData(isWeb ? (await api.getProds())['data'] : await db.getProds(), (j) => Prod.fromJSON(j)).cast<Prod>();
	static getProdUnits(int prodID) async => convertData(isWeb ? (await api.getProdUnits(prodID))['data'] : await db.getProdUnits(prodID), (j) => Unit.fromJSON(j)).cast<Unit>();

	static addProd(Prod prod) async => (await api.addProd(prod.toJSON()))['status'] == 200 && (isWeb || await sync());
	static updProd(Prod prod) async => (await api.updProd(prod.id!, prod.toJSON()))['status'] == 200  && (isWeb || await sync());
	static delProd(Prod prod) async => (await api.delProd(prod.id!))['status'] == 200  && (isWeb || await sync());


	// --- UNITS --- //

	static getUnits() async => convertData(isWeb ? (await api.getUnits())['data'] : await db.getUnits(), (j) => Unit.fromJSON(j)).cast<Unit>();

	// static addUnit(Unit unit) async => (await api.addOrder(unit.toJSON()))['status'] == 200 && await db.insert(unit) > 0;
	// static updUnit(Unit unit) async => (await api.updOrder(unit.id!, unit.toJSON()))['status'] == 200  && await db.update(unit) > 0;
	// static delUnit(Unit unit) async => (await api.delOrder(unit.id!))['status'] == 200  && await db.delete(unit) > 0;

	// --- DOCS --- //

	static getDocs() async => await api.getDocs();

	// --- ORDERS --- //

	static getOrders() async => handler(await api.getOrders(), (data) => convertData(data, (j) => Order.fromJSON(j)).cast<Order>(), () => [].cast<Order>());
	static getOrderProds(int id) async => handler(await api.getOrderProds(id), (data) => convertData(data, (j) => ProdUnit.fromJSON(j))).cast<ProdUnit>();

	static addOrder(Order order) async => (await api.addOrder(order.toJSON()))['status'] == 200;
	static updOrder(Order order) async => (await api.updOrder(order.id!, order.toJSON()))['status'] == 200;
	static delOrder(Order order) async => (await api.delOrder(order.id!))['status'] == 200;

	static expOrder(Order order) async => (await api.expOrder(order.id!))['status'] == 200;

	static getProds4Order() async => convertData(isWeb ? (await api.getProds4Order())['data'] : await db.getProds4Order(), (j) => Prod.fromJSON(j)).cast<Prod>();

	// --- AGENTS --- //

	static getAgents() async => convertData(isWeb ? (await api.getAgents())['data'] : await db.getAgents(), (j) => Agent.fromJSON(j)).cast<Agent>();

	static addAgent(Agent agent) async { dynamic data = await api.addAgents(agent.toJSON()); return (data['status'] == 200 && (isWeb || await sync())) ? Agent.fromJSON(data['data']) : null; }
	static updAgent(Agent agent) async => (await api.updAgents(agent.id!, agent.toJSON()))['status'] == 200 && (isWeb || await sync()); // db.update(agent) > 0;
	static delAgent(Agent agent) async => (await api.delAgents(agent.id!))['status'] == 200 && (isWeb || await sync()); // db.delete(agent) > 0;

	// --- UTILS --- //

	static startSyncSchedule() async {
		while (db.isNull) {
			await Future.delayed(const Duration(seconds: 1));
		}
		sync();
		Timer.periodic(
			const Duration(seconds: 5*60),
			(timer) => sync
		);
	}

	static sync() async => handler(await api.getDBUpdate(sp!.getInt('lastUpdate')!), (data) {
		if (data.isNotEmpty) db.sync(data);
		sp!.setInt('lastUpdate', (DateTime.now().microsecondsSinceEpoch / 1000000).round());
		return true;
	});

	static handler (Map<String, dynamic> response, Function onSuccess, [Function? onError]) {
		if (199 < response['status'] && response['status'] < 299) {
			return onSuccess(response['data']);

		} else if (399 < response['status'] && response['status'] < 499) {
			if (onError != null) { return onError(); }
		}
	}

	static List<dynamic> convertData (List<dynamic> data, Function convert) {
		List<dynamic> convertData = [];
		for (var row in data) { convertData.add(convert(row)); }
		return convertData;
	}
}
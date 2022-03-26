
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// ignore: camel_case_types
class api {

  // ignore: constant_identifier_names
  static const String GET = 'get', POST = 'post', PUT = 'put', DELETE = 'delete';
  static const String apiURL = 'http://milk.bidone.ru/api/v1';

  static String? token = '9506008068';

  static addProd(String body) => doRequest('$apiURL/prods', POST, body: body);
  static updProd(int id, String body) => doRequest('$apiURL/prods/$id', PUT, body: body);
  static delProd(int id) => doRequest('$apiURL/prods/$id', DELETE);

  // static addUnit(String body) => doRequest('$apiURL/units', POST, body: body);
  // static updUnit(int id, String body) => doRequest('$apiURL/units/$id', PUT, body: body);
  // static delUnit(int id) => doRequest('$apiURL/units/$id', DELETE);

  static getDocs() => doRequest('$apiURL/docs', GET);

  static getOrders() => doRequest('$apiURL/orders', GET);
  static getOrderProds(int id) => doRequest('$apiURL/orders/$id', GET);
  static addOrder(String body) => doRequest('$apiURL/orders', POST, body: body);
  static updOrder(int id, String body) => doRequest('$apiURL/orders/$id', PUT, body: body);
  static delOrder(int id) => doRequest('$apiURL/orders/$id', DELETE);

  static expOrder(int id) => doRequest('$apiURL/orders/$id/excel', GET);

  static getAgents() => doRequest('$apiURL/agents', GET);
  static addAgents(String body) => doRequest('$apiURL/agents', POST, body: body);
  static updAgents(int id, String body) => doRequest('$apiURL/agents/$id', PUT, body: body);
  static delAgents(int id) => doRequest('$apiURL/agents/$id', DELETE);

  static getDBUpdate (int lastUpdate) => doRequest('$apiURL/sync/$lastUpdate', GET);

  static Future<Map<String, dynamic>> doRequest(String url, String type, {String? body}) async {
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    if (token != null) {headers.addAll({'X-Authorization': token!});}
    if (body != null) {headers.addAll({'Content-Type': 'application/json'});}

    debugPrint(url);
    if (body != null) debugPrint(body);

    Response response = type == POST ? await http.post(uri, headers: headers, body: body) :
                        type == PUT ? await http.put(uri, headers: headers, body: body) :
                        type == DELETE ? await http.delete(uri) :
                        await http.get(uri);

    debugPrint(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    Map<String, dynamic> resp = {
      'status': 470,
      'message': 'где то упало'
    };

    return resp;
  }
}
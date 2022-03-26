import 'package:flutter/material.dart';

import 'package:milk/pages/DocPage.dart';
import 'package:milk/pages/DocsPage.dart';
import 'package:milk/pages/AgentsPage.dart';
import 'package:milk/pages/OrderPage.dart';
import 'package:milk/pages/OrdersPage.dart';
import 'package:milk/pages/ProdPage.dart';
import 'package:milk/pages/ProdsPage.dart';
import 'pages/MainPage.dart';
import './utils/db.dart';
import './core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key) {
    WidgetsFlutterBinding.ensureInitialized();
    core.initSP();
    db.init();
    core.startSyncSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (BuildContext context) => const MainPage(),
        '/prods': (BuildContext context) => const ProdsPage(),
        '/prod': (BuildContext context) => const ProdPage(),
        '/docs': (BuildContext context) => const DocsPage(),
        '/agents': (BuildContext context) => const AgentsPage(),
        '/order': (BuildContext context) => const OrderPage(),
        '/orders': (BuildContext context) => const OrdersPage(),
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name!.split('/');

        if (path[1] == "docs") {
          return MaterialPageRoute(
            builder: (context) => DocPage(int.parse(path[2])),
            settings: routeSettings,
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:milk/components/AgentEditForm.dart';
import 'package:milk/entities/Prod.dart';
import 'package:milk/pages/ProdPage.dart';

import '../entities/Agent.dart';
import '../core.dart';

class ProdsPage extends StatefulWidget {

  const ProdsPage({Key? key}) : super(key: key);

  @override
  _ProdsPageState createState() => _ProdsPageState();
}

class _ProdsPageState extends State<ProdsPage> {

  List<Prod> _prods = [];

  _ProdsPageState() {
    _getProds();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: _prodsListView(_prods),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onProdTap(null)
      )
  );

  Widget _prodsListView(List<Prod> prods) => ListView.builder(
      itemCount: prods.length,
      itemBuilder: (context, i) => ListTile(
        onTap: () => _onProdTap(prods[i]),
        title: Text(prods[i].name),
        // trailing: InkWell(
        //   onTap: () => _onDeleteCallback(prods[i]),
        //   child: const Icon(Icons.delete),
        // )
      )
    );

  _getProds() async {
    _prods = await core.getProds();
    setState(() {});
  }
  
  _onProdTap(Prod? prod) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => ProdPage(prod, () => _getProds())));
  }

  _onDeleteCallback(Prod prod) async {
    if (await core.delProd(prod)) {
      setState(() => _prods.remove(prod));
    }
  }
}

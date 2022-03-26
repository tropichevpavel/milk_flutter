
import 'package:flutter/material.dart';
import 'package:milk/entities/ProdUnit.dart';

import '../core.dart';

import '../entities/Prod.dart';
import '../entities/Unit.dart';
import 'DropDownButton.dart';

class AutoAddListView extends StatefulWidget {

  final List<Unit> units;
  final List<Unit> curUnits;
  final Function(Unit) onAdd, onChangePrice, onDel;

  const AutoAddListView(this.curUnits, this.units, this.onAdd, this.onChangePrice, this.onDel, {Key? key}) : super(key: key);

  @override
  _AutoAddListViewState createState() => _AutoAddListViewState();
}

class _AutoAddListViewState extends State<AutoAddListView> {

  int? _unitID;
  List<Unit> _units = [];

  @override
  void initState() {
    _units = widget.units;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: _units.length,
      itemBuilder: (context, i) => Row(
      children: [
          Expanded(
              flex: 5,
              child: DropDownButton('Ед изм', widget.units, _unitID, (uID) => setState(() => _unitID = uID))),
          const Text('Цена:'),
          Expanded(
              flex: 3,
              child: Text(_units[i].price != 0 ? '${_units[i].price}' : '')),
          IconButton(
              onPressed: _unitID == null ? null : () {},
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: _units[i].price != 0 ? null : () {},
              icon: const Icon(Icons.add))
      ]
    )
  );

  _onChangePrice(int id, double price) {
    for (Unit unit in _units) {
      if (unit.id == id) {
        unit.price = price;
      }
    }
  }

  _onChangeUnit(int? unitID) {
    setState(() => _unitID = unitID);
  }

  _getUnits() {
    for (Unit unit in widget.units) {
      for (Unit curUnit in _units) {
        if (unit.id == curUnit.id) {
          continue;
        }
      }
    }
  }
}

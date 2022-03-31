import 'package:flutter/material.dart';
import 'package:milk/entities/ProdUnit.dart';

import '../core.dart';
import '../entities/Prod.dart';
import '../entities/Unit.dart';
import 'DropDownButton.dart';

class ProdSelector extends StatefulWidget {
  final List<Prod> prods;
  final Function(ProdUnit) onAdd;

  const ProdSelector(this.prods, this.onAdd, {Key? key}) : super(key: key);

  @override
  _ProdSelectorState createState() => _ProdSelectorState();
}

class _ProdSelectorState extends State<ProdSelector> {
  int? _prodID;
  int? _unitID;
  final ProdUnit _prod = ProdUnit.empty();
  List<Unit> _units = [];

  final TextEditingController _textCtrl = TextEditingController();

  _onChangeProd(int? prodID) async {
    for (Prod prod in widget.prods) {
      if (prod.id == prodID) {
        _prod.prod = prod.name;
      }
    }
    _units = await core.getProdUnits(prodID!);
    _prodID = prodID;
    _unitID = _units.isNotEmpty ? _units[0].id : null;
    _prod.setUnit(_units.isNotEmpty ? _units[0] : null);
    _textCtrl.clear();
    setState(() {});
  }

  _onChangeUnit(int? unitID) {
    for (Unit unit in _units) {
      if (unit.id == unitID) {
        _unitID = unitID;
        _prod.setUnit(unit);
      }
    }
    setState(() {});
  }

  _onChangeCount(double count) {
    setState(() => _prod.count = count);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 6,
          child: DropDownButton(
              'Выберите продукт', widget.prods, _prodID, _onChangeProd)),
      Expanded(
          flex: 2,
          child: DropDownButton('Ед изм', _units, _unitID, _onChangeUnit)),
      Expanded(
          flex: 1,
          child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: _textCtrl,
              onChanged: (value) =>
                  _onChangeCount(value.isEmpty ? 0 : double.parse(value)))),
      IconButton(
          onPressed: _prod.id == null || _prod.count == 0
              ? null
              : () => widget.onAdd(ProdUnit.fromProdUnit(_prod)),
          icon: const Icon(Icons.add))
    ]);
  }
}

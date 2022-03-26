
import 'package:flutter/material.dart';
import 'package:milk/components/ConfirmDialog.dart';
import 'package:milk/components/DatePickerButton.dart';
import 'package:milk/components/DropDownButton.dart';
import 'package:milk/components/LoadButton.dart';
import 'package:milk/components/LoadSpinner.dart';
import 'package:milk/components/ProdUnitEditForm.dart';
import 'package:milk/entities/Order.dart';
import 'package:milk/entities/ProdUnit.dart';
import 'package:milk/entities/Unit.dart';
import 'package:milk/theme.dart';

import '../core.dart';

import '../entities/Agent.dart';
import '../entities/Prod.dart';

import '../components/ProdSelector.dart';

class ProdPage extends StatefulWidget {

  final Prod? prod;
  final Function? onCallback;

  const ProdPage([this.prod, this.onCallback, Key? key]) : super(key: key);

  @override
  _ProdPageState createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {

  late Prod _prod;

  List<Unit> _units = [];

  @override
  initState() {
    _prod = widget.prod != null ? Prod.fromProd(widget.prod!) : Prod.empty();
    super.initState();
    _init();
  }

  _init() async {
    _units = await core.getUnits();

    if (_prod.id != null) {
      _prod.units = await core.getProdUnits(_prod.id!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_prod.id != null ? 'Редактировать товар' : 'Создать товар')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.all(ThemeSize.mainPadding),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                        initialValue: _prod.name,
                        onChanged: (v) => setState(() => _prod.name = v),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Наименование товара'))
                ),
                LoadButton(
                    onTap: () => _prod.hasUnits() ? _prod.id == null ? core.addProd(_prod) : core.updProd(_prod) : null,
                    ui: () => _onSave(),
                    text: _prod.id == null ? 'Создать' : 'Сохранить',
                    textComplete: _prod.id == null ? 'Создан' : 'Сохранено',
                    disabled: _prod.name.isEmpty || _prod.units.isEmpty
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.amber,
            child: Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text('Упаковка', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 4,
                      child: Text('Цена', style: TextStyle(fontWeight: FontWeight.bold)))
                ])),
          LoadSpinner(_prod.id == null && _prod.units.isEmpty ? LoadState.empty : _prod.units.isEmpty ? LoadState.load : LoadState.complete),
          Expanded(child: _unitsListView(_prod.units)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showUnitEditForm(null),
      ),
    );
  }

  Widget _unitsListView(List<Unit> units) =>
    ListView.builder(
      itemCount: units.length,
      itemBuilder: (BuildContext context, int i) => units[i].status != 0 ? Container(
        padding: EdgeInsets.only(left: ThemeSize.mainPadding),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Text(units[i].name)),
            Expanded(
                flex: 3,
                child: Text('${units[i].price}')),
            IconButton(
                onPressed: () => _showUnitEditForm(units[i]),
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () => ConfirmDialog(context, 'Вы точно хотите удалить выбранную упаковку товара?\n\nДанное действие необратимо!', () => _onUnitDel(units[i])),
                icon: const Icon(Icons.delete))
        ],
      )) : Container()
    );

  _showUnitEditForm(Unit? unit) => showDialog(context: context, builder: (context) => ProdUnitEditForm(unit, _getAvailUnitList(unit), _onUnitSave));

  _onUnitSave(Unit unit) => setState(() => unit.puID != null ? _prod.changePrice(unit) : _prod.addUnit(unit));

  _onUnitDel(Unit unit) => setState(() => _prod.delUnit(unit));

  List<Unit> _getAvailUnitList(Unit? unit) {
    List<Unit> availUnits = [];

    for (Unit u in _units) {
      bool flag = true;
      for (Unit curUnit in _prod.units) {
        if (u.id == curUnit.id && curUnit.id != unit?.id) {
          flag = false;
        } else {
          flag = true;
        }
      }
      if (flag) availUnits.add(u);
    }

    return availUnits;
  }

  _onSave() {
    if (widget.onCallback != null) { widget.onCallback!(); }
    Navigator.pop(context);
  }
}

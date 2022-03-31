
import 'package:flutter/material.dart';
import 'package:milk/components/FlexList.dart';
import 'package:milk/components/LoadTitle.dart';
import 'package:milk/entities/ProdUnit.dart';

import '../core.dart';
import '../entities/Prod.dart';
import '../entities/Unit.dart';
import 'ProdsSearchList.dart';

class ProdSelectorModal extends StatefulWidget {
	final Function(ProdUnit) onAdd;

	const ProdSelectorModal(this.onAdd, {Key? key}) : super(key: key);

	@override
	_ProdSelectorModalState createState() => _ProdSelectorModalState();
}

class _ProdSelectorModalState extends State<ProdSelectorModal> {

	@override
	Widget build(BuildContext context) => Scaffold(
		backgroundColor: Colors.transparent,
		body: Builder(
			builder: (context) => Dialog(
				insetPadding: const EdgeInsets.all(15.0),
				child: ProdsSearchList(onTap: (prod) => _onSelectProd(prod), toSell: true)
			),
		),
	);
		// Dialog(
		// 	);

	void _onSelectProd(Prod prod) =>
		showDialog(context: context,
			builder: (context) => ProdUnitSelectorModal(prod, widget.onAdd));
}

class ProdUnitSelectorModal extends StatefulWidget {

	final Prod prod;
	final Function onAdd;

	const ProdUnitSelectorModal(this.prod, this.onAdd, {Key? key}) : super(key: key);

	@override
	_ProdUnitSelectorModalState createState() => _ProdUnitSelectorModalState();
}

class _ProdUnitSelectorModalState extends State<ProdUnitSelectorModal> {

	final ProdUnit _prod = ProdUnit.empty();
	final List<Unit> _units = [];
	final FocusNode _focus = FocusNode();

	@override
	initState() { _prod.setProd(widget.prod); super.initState(); }

	@override
	Widget build(BuildContext context) => Scaffold(
		backgroundColor: Colors.transparent,
		body: Builder(
			builder: (context) => AlertDialog(
				insetPadding: const EdgeInsets.all(15.0),
				content: SizedBox(
					width: 300,
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Container(
								padding: const EdgeInsets.all(15),
								child: Text(widget.prod.name)),
							LoadTitle(load: () => core.getProdUnits(widget.prod.id!), onLoad: _onLoadUnits),
							FlexList(data: _units, builder: _unitItem),
							TextField(
								autofocus: true,
								focusNode: _focus,
								textInputAction: TextInputAction.done,
								onSubmitted: (s) => _onProdAdd(),
								textAlign: TextAlign.center,
								keyboardType: TextInputType.number,
								onChanged: (value) => _onChangeCount(value.isEmpty ? 0 : double.parse(value))),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									TextButton(
										onPressed: () => Navigator.pop(context),
										child: const Text('Назад')),
									TextButton(
										onPressed: _prod.id == null || _prod.count == 0 ? null : _onProdAdd,
										child: const Text('Добавить',
											style: TextStyle(color: Colors.red)))
								],
							)
						]),
				)
			),
		));

	void _onLoadUnits(List<Unit> data) => setState(() { _units.addAll(data); if (_units.isNotEmpty) _prod.setUnit(_units[0]); });

	void _onChangeCount(double count) => setState(() => _prod.count = count);

	void _onUnitChange(Unit unit) => setState(() { _prod.setUnit(unit); _focus.requestFocus(); });

	Widget _unitItem(Unit unit) => Container(
		padding: const EdgeInsets.all(15),
		child: ElevatedButton(
			style: ElevatedButton.styleFrom(primary: _prod.id == unit.puID ? Colors.blue : Colors.white),
			child: Text(unit.name, style: TextStyle(color: _prod.id == unit.puID ? Colors.white : Colors.black)),
			onPressed: () => _onUnitChange(unit),
		));

	void _onProdAdd() {
		Navigator.pop(context);
		widget.onAdd(_prod);
		ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Продукт ${_prod.prod} - ${_prod.unit} добавлен в заказ')));
	}
}

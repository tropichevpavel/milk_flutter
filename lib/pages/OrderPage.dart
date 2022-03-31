
import 'package:flutter/material.dart';
import 'package:milk/components/AgentSearchList.dart';
import 'package:milk/components/DatePickerButton.dart';
import 'package:milk/components/LoadButton.dart';
import 'package:milk/components/LoadTitle.dart';
import 'package:milk/components/ProdSelectorModal.dart';
import 'package:milk/entities/Order.dart';
import 'package:milk/entities/ProdUnit.dart';
import 'package:milk/utils/DateTimeExt.dart';

import '../core.dart';

class OrderPage extends StatefulWidget {

	final Order? order;
	final Function? onCallback;

	const OrderPage([this.order, this.onCallback, Key? key]) : super(key: key);

	@override
	_OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

	late Order _order;

	@override
	initState() {
		super.initState();
		_order = widget.order != null ? Order.fromOrder(widget.order!) : Order.empty();
	}

	@override
	Widget build(BuildContext context) =>
		Scaffold(
			appBar: AppBar(title: Text(_order.id != null ? 'Редактировать заказ' : 'Создать заказ')),
			body: Column(
				mainAxisSize: MainAxisSize.max,
				children: [
					Row(
						children: [
							Expanded(
								child: MaterialButton(
									onPressed: () => _showAgentModal(context),
									child: _order.agent == null ?
									const Text('Выберете контрагента') :
									Column(
										children: [
											Text(_order.agent!.name),
											Text('${_order.agent!.phone} - ${_order.agent!.adress}',
												style: const TextStyle(color: Colors.grey))
										]))
							),
							LoadButton(
								onTap: () => _order.id == null ? core.addOrder(_order) : core.updOrder(_order),
								ui: () => _onSave(),
								text: _order.id == null ? 'Создать' : 'Сохранить',
								textComplete: _order.id == null ? 'Создан' : 'Сохранено',
								disabled: _order.agent == null || _order.prods.isEmpty
							),
						],
					),
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						children: [
							const Text('Дата заказа'),
							DatePickerButton(_order.date, _onChangeDate),
							Text('Итого: ${_order.cost} р.'),
						],
					),
					core.isWeb ? _prodListHeaderWeb() : _prodListHeader(),
					Visibility(
						visible: _order.id != null,
						child: LoadTitle(
							load: _order.id != null ? () => core.getOrderProds(_order.id!) : null,
							onLoad: (data) => setState(() => _order.prods = data))
					),
					Expanded(child: core.isWeb ? _prodsListViewWeb(_order.prods, _onDeleteProd) : _prodsListView(_order.prods, _onDeleteProd)),
				],
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.add), onPressed: () => _showProdsModal())
		);

	_showAgentModal(BuildContext context) =>
		showDialog(
			context: context,
			builder: (context) => Dialog(
				insetPadding: const EdgeInsets.all(15.0),
				child: AgentSearchList(onTap: (agent) { Navigator.pop(context); setState(() => _order.agent = agent); }))
		);

	_showProdsModal() =>
		showDialog(
			context: context,
			builder: (context) => ProdSelectorModal(_onAddProd)
		);

	_onAddProd(ProdUnit prod) => setState(() => _order.addProd(prod));

	_onDeleteProd(ProdUnit prod) => setState(() => _order.delProd(prod));

	_onChangeDate(DateTime date) async => setState(() => _order.date = DateTimeExt.fromDate(date));

	_onSave() {
		if (widget.onCallback != null) { widget.onCallback!(); }
		Navigator.pop(context);
	}

	Widget _prodListHeader() => Container(
		padding: const EdgeInsets.all(10),
		color: Colors.amber,
		child: Row(
			children: const [
				Expanded(
					flex: 7,
					child: Text('Наименование')),
				Expanded(
					flex: 2,
					child: Text('Тара')),
				Expanded(
					flex: 2,
					child: Text('Кол-во')),
				Expanded(
					flex: 1,
					child: Text(''))
			]));

	Widget _prodListHeaderWeb() => Container(
		padding: const EdgeInsets.all(10),
		color: Colors.amber,
		child: Row(
			children: const [
				Expanded(
					flex: 7,
					child: Text('Наименование')),
				Expanded(
					flex: 2,
					child: Text('Тара', textAlign: TextAlign.right)),
				Expanded(
					flex: 2,
					child: Text('Кол-во', textAlign: TextAlign.right)),
				Expanded(
					flex: 2,
					child: Text('Цена', textAlign: TextAlign.right)),
				Expanded(
					flex: 2,
					child: Text('Сумма', textAlign: TextAlign.right)),
				Expanded(
					flex: 1,
					child: Text('')),
			]));

	Widget _prodsListView(List<ProdUnit> prods, onDel) => ListView.builder(
		itemCount: prods.length,
		itemBuilder: (BuildContext context, int i) => ListTile(
			title: Row(
				children: [
					Expanded(
						flex: 7,
						child: Text(prods[i].prod, overflow: TextOverflow.ellipsis)),
					Expanded(
						flex: 2,
						child: Text(prods[i].unit, textAlign: TextAlign.right)),
					Expanded(
						flex: 2,
						child: Text('${prods[i].count}', textAlign: TextAlign.right)),
				],
			),
			trailing: InkWell(
				onTap: () => _onDeleteProd(prods[i]),
				child: const Icon(Icons.delete),
			))
	);

	Widget _prodsListViewWeb(List<ProdUnit> prods, onDel) => ListView.builder(
		itemCount: prods.length,
		itemBuilder: (BuildContext context, int i) => ListTile(
			title: Row(
				children: [
					Expanded(
						flex: 7,
						child: Text(prods[i].prod, overflow: TextOverflow.ellipsis)),
					Expanded(
						flex: 2,
						child: Text(prods[i].unit, textAlign: TextAlign.right)),
					Expanded(
						flex: 2,
						child: Text('${prods[i].count}', textAlign: TextAlign.right)),
					Expanded(
						flex: 2,
						child: Text('${prods[i].price} р.', textAlign: TextAlign.right)),
					Expanded(
						flex: 2,
						child: Text('${prods[i].count * prods[i].price} р.', textAlign: TextAlign.right)),
				],
			),
			trailing: InkWell(
				onTap: () => _onDeleteProd(prods[i]),
				child: const Icon(Icons.delete),
			))
	);
}

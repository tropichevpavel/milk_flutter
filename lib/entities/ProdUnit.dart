
import 'Model.dart';
import 'Prod.dart';
import 'Unit.dart';

class ProdUnit implements Model {

  String table = 'prodUnits';
  String pk = 'puID';

  int? id, prodID, unitID;
  String prod, unit;
  double count = 0;
  double price = 0;

  ProdUnit(this.id, this.prod, this.unit, this.count, this.price);

  ProdUnit.empty() : prod = '', unit = '';

  ProdUnit.fromProdUnit(ProdUnit pu) :
        id = pu.id,
        prod = pu.prod,
        unit = pu.unit,
        count = pu.count,
        price = pu.price;

  ProdUnit.fromJSON(Map<String, dynamic> json) :
        id = json['id'],
        prod = json['prod'],
        unit = json['unit'],
        count = (json['count'] ?? 0).toDouble(),
        price = (json['price'] ?? 0).toDouble();

  setProd(Prod prod) {
    this.prod = prod.name;
  }

  setUnit(Unit? unit) {
    id = unit?.puID;
    this.unit = unit?.name ?? '';
    price = unit?.price ?? 0;
  }

  @override
  String toString() => '{"id":$id, "prod":"$prod", "unit":$unit, "count":$count, "price":$price}';

  String toJSON() => '{"id":$id, "count":$count}';

  toMapDB() => {'prodIDfk': prodID, 'unitIDfk': unitID};
}
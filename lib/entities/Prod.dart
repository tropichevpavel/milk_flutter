
import 'Model.dart';
import 'Unit.dart';

class Prod extends Model {

  int? id;
  String name;
  double count = 0;
  List<Unit> units = [];

  Prod (this.id, this.name);

  Prod.empty() : name = '';

  Prod.fromProd(Prod prod) :
        id = prod.id,
        name = prod.name,
        units = prod.units,
        count = prod.count;

  Prod.fromJSON(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        count = (json['count'] ?? 0).toDouble();

  @override
  String toString() => '{"id":$id, "name":"$name"}';

  String toJSON() {
    String json = '{"name":"$name", "units":[';

    for (Unit u in units) {
      json += '{"puID":${u.puID}, "id":${u.id}, "price":${u.price}, "status":${u.status}},';
    }

    return '${json.substring(0, json.length - 1)}]}';
  }

  addUnit(Unit unit) {
    for (Unit u in units) {
      if (u.id == unit.id) {
        return;
      }
    }
    units.add(unit);
  }

  changePrice(Unit unit) {
    for (Unit u in units) {
      if (u.id == unit.id) {
        u.price = unit.price;
        return;
      }
    }
  }

  delUnit(Unit unit) {
    for (Unit u in units) {
      if (u.id == unit.id) {
        if (u.puID == null) {
          units.remove(u);
        } else {
          unit.status = 0;
        }
        return;
      }
    }
  }

  hasUnits() {
    for (Unit u in units) {
      if (u.status != 0) {
        return true;
      }
    }
  }
}

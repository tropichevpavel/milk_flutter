
import 'package:milk/entities/Model.dart';

class Unit extends Model {

  int? id;
  int? puID;
  int status = 1;
  String name;
  double price = 0;

  Unit (this.id, this.name);

  Unit.empty() : name = '';

  Unit.fromUnit(Unit unit) :
        id = unit.id,
        puID = unit.puID,
        name = unit.name,
        price = unit.price;

  Unit.fromJSON (Map<String, dynamic> json) :
        id = json['id'],
        puID = json['puID'],
        name = json['name'],
        price = (json['price'] ?? 0).toDouble(),
        status = (json['status'] ?? 1).toInt();

  String toJSON() => '';
}
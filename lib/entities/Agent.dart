
import 'package:milk/entities/Model.dart';

class Agent implements Model {

  @override
  String table = 'agents';

  @override
  String pk = 'agentID';

  @override
  int? id;
  int phone;
  String name, adress;

  Agent (this.id, this.name, this.phone, this.adress);

  Agent.empty () :
        name = '',
        phone = 0,
        adress = '';

  Agent.fromAgent (Agent agent) :
        id = agent.id,
        name = agent.name,
        phone = agent.phone,
        adress = agent.adress;

  Agent.fromJSON (Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        phone = json['phone'],
        adress = '${json['adress']}';

  @override
  String toJSON() => '{"name":"$name", "phone":$phone, "adress":"$adress"}';

  @override
  toMapDB() => {'agentName': name, 'agentPhone': phone, 'agentAdress': adress};

  @override
  String toString() => '{"id":$id, "name":"$name", "phone":$phone, "adress":"$adress"}';
}
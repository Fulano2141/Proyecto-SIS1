import 'package:firebase_database/firebase_database.dart';
class producto{
  String _id;
  String _name;
  String _description;

  producto(this._id, this._name, this._description);

  producto.map(dynamic obj){
    this._name = obj['nobre producto'];
    this._description = obj['description'];
  }

  String get description => _description;
  String get name => _name;
  String get id => _id;
  producto.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['nobre producto'];
    _description = snapshot.value['description'];
  }

}
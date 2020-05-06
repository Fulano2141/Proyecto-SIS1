import 'package:firebase_database/firebase_database.dart';
class devolucion{
  String _id;
  String _namepro;
  String _cantidad;
  String _description;
  String _descr;
  String _estado;
  String _usu;

  devolucion(this._id, this._namepro, this._cantidad, this._description,
      this._descr, this._estado, this._usu);


  String get id => _id;

  devolucion.map(dynamic obj){
    this._namepro = obj['name'];
    this._description = obj['description'];
    this._cantidad= obj['cantidad'];
    this._usu=obj['usuario'];
    this._descr=obj['detallepedido'];
    this._estado=obj['estado'];

  }

  devolucion.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _namepro = snapshot.value['nobre pro'];
    _description = snapshot.value['description'];
    _cantidad=snapshot.value['cantidad'];
    _usu=snapshot.value['usuario'];
    _descr=snapshot.value['detallepedido'];
    _estado=snapshot.value['estado'];

  }

  String get namepro => _namepro;

  String get cantidad => _cantidad;

  String get description => _description;

  String get descr => _descr;

  String get estado => _estado;

  String get usu => _usu;


}
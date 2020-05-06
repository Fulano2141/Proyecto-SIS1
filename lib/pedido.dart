import 'package:firebase_database/firebase_database.dart';
class pedido{
  String _id;
  String _name;
  String _description;
  String _cantida;
  String _descr;
  String _estado;
  String _usu;


  pedido(this._id, this._name, this._description, this._cantida, this._descr,
      this._estado,this._usu);

  String get id => _id;

  String get name => _name;
  String get description => _description;
  String get cantida => _cantida;
  String get descr => _descr;
  String get estado => _estado;
  String get usua => _usu;


  pedido.map(dynamic obj){
    this._name = obj['name'];
    this._description = obj['description'];
    this._cantida= obj['cantidad'];
    this._usu=obj['usuario'];
    this._descr=obj['detallepedido'];
    this._estado=obj['estado'];

  }

  pedido.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['nobre pro'];
    _description = snapshot.value['description'];
    _cantida=snapshot.value['cantidad'];
    _usu=snapshot.value['usuario'];
    _descr=snapshot.value['detallepedido'];
    _estado=snapshot.value['estado'];

  }



}
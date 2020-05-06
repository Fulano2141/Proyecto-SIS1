import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectosis/pedido.dart';

final productReference=FirebaseDatabase.instance.reference().child('pedido');
class pedidos extends StatefulWidget{
  const pedidos({
    Key key,
    @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState()=>_listaprod();
}

class _listaprod extends State<pedidos>{
  final databaseReference = FirebaseDatabase.instance.reference().child('devolucion');
  final databaseR = FirebaseDatabase.instance.reference().child('pedido');
  List<pedido> pedi;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;
  @override
  void initState() {
    super.initState();
    pedi = new List();
    _onProductAddedSubscription = productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription = productReference.onChildChanged.listen(_onProductUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView.builder(
              itemCount: pedi.length,
              padding: EdgeInsets.only(top: 3.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      padding: new EdgeInsets.all(3.0),
                      child: '${pedi[position].usua}' == '${widget.user.uid}'
                          ? Card(
                        color: Colors.white,
                        child: '${pedi[position].estado}' == 'rechazado'?
                        Row(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    'Producto pedido : ${pedi[position].name}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'cantidad pedida :${pedi[position].cantida}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToProductInformation(context,position)),
                            ),
                            Text('${pedi[position].estado}'),
                          ],
                        ) :
                        '${pedi[position].estado}' == 'pendiente'?
                        Row(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    'Producto pedido : ${pedi[position].name}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'cantidad pedida :${pedi[position].cantida}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToProductInformation(context,position)),
                            ),
                            Text('${pedi[position].estado}'),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed:()=> _showDialoged(context, position),
                            ),
                          ],
                        ) :
                        Row(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    'Producto pedido : ${pedi[position].name}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'cantidad pedida :${pedi[position].cantida}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToProductInformation(context,position)),
                            ),
                            Text('${pedi[position].estado}'),
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.blue,
                              ),
                              onPressed:() => _showDialog(context, position),
                            ),
                          ],
                        )

                      ):null,
                    ),
                  ],
                );
              }),
        ),
      ),
    );

  }

  _showDialog(ctx, position) {
    var det = TextEditingController();
    var cant=TextEditingController();
    showDialog(
        context: ctx,

        builder: (ctx) {
          return AlertDialog(
            title: Text('Comprar producto ${pedi[position].name}'),
            content: Scrollbar(

              child: Column(
                children: <Widget>[
                  Text('${pedi[position].descr}'),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'cantidad a devolver', hintText: 'cantidad',),

                    controller: cant,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'notivo de la devolucion', hintText: 'detalles',),

                    controller: det,
                  ),

                ],
              ),

            ),

            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              FlatButton(
                child: const Text('Guardar pedido'),
                onPressed: () {
                  String a=cant.text.toString().trim();
                  String b=det.text.toString().trim();
                  int i=Random().nextInt(10000);
                  _guardar(pedi[position].description.toString(),
                      pedi[position].name.toString(),
                      i.toString(),
                      '${widget.user.uid}',b.toString(),
                  a.toString());
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  _guardar(String d, String p, String i,String j,String de,String a) {

    databaseReference.child('$i').set({
      'nobre pro': p,
      'cantidad' : a,
      'usuario':j,
      'detdevolucion':de,
      'description': d,
      'estado':'pendiente',
    });
  }

  _showDialoged(ctx, position) {
    var det = TextEditingController();
    var cant=TextEditingController();
    det.value = new TextEditingController.fromValue(new TextEditingValue(text: '${pedi[position].descr}')).value;
    cant.value = new TextEditingController.fromValue(new TextEditingValue(text: '${pedi[position].cantida}')).value;
    showDialog(
        context: ctx,

        builder: (ctx) {
          return AlertDialog(
            title: Text('editar pedido de ${pedi[position].name}'),
            content: Scrollbar(

              child: Column(
                children: <Widget>[
                  Text('${pedi[position].descr}'),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'cantidad a devolver', hintText: 'cantidad',),
                    keyboardType: TextInputType.number,

                    controller: cant,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'descripcion del pedido', hintText: 'detalles',),

                    controller: det,
                  ),

                ],
              ),

            ),

            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              FlatButton(
                child: const Text('Guardar cambio'),
                onPressed: () {
                  _actualisar(cant.text.toString().trim(),det.text.toString().trim(), pedi[position].id);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  _actualisar(String a ,String b,String c){
    databaseR.child(c).update({
      'cantidad':a,
      'detallepedido':b,
    });
  }
  void _onProductAdded(Event event) {
    setState(() {
      pedi.add(new pedido.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =pedi.singleWhere((pedido) => pedido.id == event.snapshot.key);
    setState(() {
      pedi[pedi.indexOf(oldProductValue)] =
      new pedido.fromSnapShot(event.snapshot);
    });
  }
  void _navigateToProductInformation(ctx,position){
    print('$position');
    _sdetalle(ctx, position);
  }

  _sdetalle(ctx, position) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Detale del pedido'),//${pedi[position].name}
            content: Scrollbar(

              child: Column(
                children: <Widget>[
                  Text('${pedi[position].name}'),
                  Text('${pedi[position].cantida}'),
                  Text('${pedi[position].descr}'),
                  Text('${pedi[position].description}'),
                  Text('${pedi[position].estado}'),

                ],
              ),

            ),

            actions: <Widget>[
              FlatButton(
                child: const Text('aceptar'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),

            ],
          );
        }
    );
  }





}
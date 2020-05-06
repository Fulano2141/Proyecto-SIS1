import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectosis/pedido.dart';

import 'devoluciones.dart';

final productReference=FirebaseDatabase.instance.reference().child('devolucion');
class usdevol extends StatefulWidget{
  const usdevol({
    Key key,
    @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState()=>_listaprod();
}

class _listaprod extends State<usdevol>{
  final databaseReference = FirebaseDatabase.instance.reference().child('pedido');
  List<devolucion> pedi;
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
                      child: '${pedi[position].usu}' == '${widget.user.uid}'
                          ? Card(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    'Producto pedido : ${pedi[position].namepro}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'cantidad a devolver :${pedi[position].cantidad}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToProductInformation(context,position)),
                            ),
                            Text('${pedi[position].estado}'),

                          ],
                        ) ,

                      ):null,
                    ),
                  ],
                );
              }),
        ),
      ),
    );

  }


  void _onProductAdded(Event event) {
    setState(() {
      pedi.add(new devolucion.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =pedi.singleWhere((devolucion) => devolucion.id == event.snapshot.key);
    setState(() {
      pedi[pedi.indexOf(oldProductValue)] =
      new devolucion.fromSnapShot(event.snapshot);
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
            title: Text('Detale de la devolucion'),//${pedi[position].name}
            content: Scrollbar(

              child: Column(
                children: <Widget>[
                  Text('${pedi[position].namepro}'),
                  Text('${pedi[position].cantidad}'),
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
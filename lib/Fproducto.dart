
import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proyectosis/procucto.dart';
class Fproducto extends StatefulWidget{
  const Fproducto({
    Key key,
    @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState()=>_listapro();}


  final productReference=FirebaseDatabase.instance.reference().child('producto');

  class _listapro extends State<Fproducto>{
    final databaseReference = FirebaseDatabase.instance.reference().child('pedido');
    List<producto> items;
    StreamSubscription<Event> _onProductAddedSubscription;
    StreamSubscription<Event> _onProductChangedSubscription;

    @override
    void initState() {
      super.initState();
      items = new List();
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
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.only(top: 3.0),
                itemBuilder: (context, position) {
                  return Column(
                    children: <Widget>[
                      Divider(
                        height: 1.0,
                      ),
                      Container(
                        padding: new EdgeInsets.all(3.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              //nuevo imagen
                              new Container(
                                padding: new EdgeInsets.all(5.0),
                              ),
                              Expanded(
                                child: ListTile(
                                    title: Text(
                                      '${items[position].name}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${items[position].description}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                   // onTap: () => _navigateToProductInformation()
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showDialog(context, position),
                              ),

                            ],
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      );
    }


     _showDialog(ctx, position) {
      var canti = TextEditingController();
      var det = TextEditingController();
      showDialog(
          context: ctx,

          builder: (ctx) {
            return AlertDialog(
              title: Text('Comprar producto ${items[position].name}'),
              content: Scrollbar(

                child: Column(
                  children: <Widget>[
                    Text('${items[position].description}'),

                    TextField(
                      decoration: InputDecoration(
                        labelText: 'cantidad a pedir', hintText: 'ingrese cantidad',),

                      controller: canti,
                      keyboardType: TextInputType.number,
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
                  child: const Text('Guardar pedido'),
                  onPressed: () {
                    String a=canti.text.toString().trim();
                    String b=det.text.toString().trim();
                    int i=Random().nextInt(1000);
                    _guardar(items[position].description.toString(),items[position].name.toString(),i.toString(),
                        a.toString(),'${widget.user.uid}',b.toString());
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }

    _guardar(String d, String p, String i,String c,String j,String de) {

      databaseReference.child('$i').set({
        'nobre pro': p,
        'cantidad' : c,
        'usuario':j,
        'detallepedido':de,
        'description': d,
        'estado':'pendiente',
      });
    }

    void _onProductAdded(Event event) {
      setState(() {
        items.add(new producto.fromSnapShot(event.snapshot));
      });
    }

    void _onProductUpdate(Event event) {
      var oldProductValue =
      items.singleWhere((product) => product.id == event.snapshot.key);
      setState(() {
        items[items.indexOf(oldProductValue)] =
        new producto.fromSnapShot(event.snapshot);
      });
    }

    void _navigateToProductInformation(){
      print('sadaa');
    }



  }

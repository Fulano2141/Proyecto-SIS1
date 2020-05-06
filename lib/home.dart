import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Fproducto.dart' as fr;
import 'fdevolver.dart' as dr;
import 'fragments.dart' as fragments;
import 'ModeloItem.dart';
import 'package:proyectosis/pedidosusu.dart' as ped;
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
    @required this.user}) : super(key: key);
  final FirebaseUser user;


  @override
  _HomeState createState() => _HomeState();


}

  class _HomeState extends State<Home> {

    int _selectedDrawerIndex = 0;

    _onSelectItem(int index){
      setState(() => _selectedDrawerIndex = index );
      Navigator.of(context).pop();
    }

    @override
  Widget build(BuildContext context) {
      final drawerItems =[
        new ModeloItem("productos a la venta", Icons.add),
        new ModeloItem("devolucion", Icons.cached),
        new ModeloItem("estado del pedido", Icons.assistant_photo)

      ];

      List<Widget> drawerOptions = [];

      for(var i = 0;i<drawerItems.length;i++){
        var d = drawerItems[i];
        drawerOptions.add(new ListTile(
          leading:new Icon(d.icon) ,
          title:new Text(d.titulo) ,

          selected: i== _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ));
      }
      return Scaffold(
  appBar: AppBar(
  title: Text(drawerItems[_selectedDrawerIndex].titulo),
  ),
    body: _getDrawerFragment(_selectedDrawerIndex),
    drawer: Drawer(
      child: Container(
        color: Colors.white70,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('TodoCom'),
              accountEmail: Text(' ${widget.user.email}'),
              currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/usua.png')),
            ),

            Column(
                children: drawerOptions
            )
          ],
        ),

      ),
    ),

  );
  }

    _getDrawerFragment(int pos){

      switch(pos){
        case 0:
          return new fr.Fproducto(user: widget.user,);
        case 1:
          return new dr.usdevol(user: widget.user,);
        case 2:
          return new ped.pedidos(user: widget.user);
        default:
          Text('error');
      }
    }


  }





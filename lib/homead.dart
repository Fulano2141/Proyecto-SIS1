import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:proyectosis/rechazado.dart' as fr;
import 'package:proyectosis/fragmentad.dart' as misFragments;
import 'package:proyectosis/aceptados.dart' as fa;
import 'package:firebase_database/firebase_database.dart';

import 'fragments.dart'as dr;

class Homead extends StatefulWidget {
  const Homead({
    Key key,
    @required this.user}) : super(key: key);
  final FirebaseUser user;


  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Homead> with TickerProviderStateMixin {

  TabController tabController;
  final databaseReference = FirebaseDatabase.instance.reference().child('producto');

  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: 4, vsync: this);
    var tabBar = TabBar(
      tabs: [
        Tab(
            child:
            Text('Aceptados', style: TextStyle(color: Colors.white70),),
            icon: Icon(Icons.check, color: Colors.white70)),
        Tab(
            child: Text('Pendientes', style: TextStyle(color: Colors.white70),),
            icon: Icon(Icons.list, color: Colors.white70)),
        Tab(
            child: Text('Rechasados', style: TextStyle(color: Colors.white70)),
            icon: Icon(Icons.clear, color: Colors.white70)),
        Tab(
            child: Text('devoluciones', style: TextStyle(color: Colors.white70)),
            icon: Icon(Icons.cached, color: Colors.white70)),
      ],
      indicatorColor: Colors.white70,
      controller: tabController,
    );

    return new DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                _verMensaje(context);
              }
              )
            ],
            title: Text('adiministra'),
            bottom: tabBar,
          ),
          backgroundColor: Colors.white70,
          body: new TabBarView(
            controller: tabController,
            children: [
              fa.aceptado(user: widget.user,),
              misFragments.Pendientes(user: widget.user,),
              fr.rechazado(user: widget.user,),
              dr.addevulu(user: widget.user),
            ],
          ),

        )
    );
  }
  _verMensaje(var ctx) {
    var id = TextEditingController();
    var pro = TextEditingController();
    var det = TextEditingController();
    String prod;
    String deta;
    String ide;

    File image;

    picker() async {
      print('Picker is called');
      //File img = await ImagePicker.pickImage(source: ImageSource.camera);

      File img = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        image = img;
      });
    }

    showDialog(
        context: ctx,

        builder: (ctx) {
          return AlertDialog(
            title: Text('Ingrese un nuevo producto'),
            content: Scrollbar(

              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'ide producto', hintText: 'id',),
                    controller: id,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Producto', hintText: 'nombre producto',),
                    controller: pro,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Detalles', hintText: 'ingrese detalles',),
                    controller: det,
                  ),

                  Column(
                    children: <Widget>[
                      _image != null ? new Image.file(
                        _image, width: 100, height: 100,) : new Image.asset(
                        'assets/arg.png', width: 100, height: 100,),
                      RaisedButton(
                          color: Colors.blue,
                          child: Text('añadir foto',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white)
                          ),
                          onPressed: () {
                            getImage();
                          }
                      ),
                    ],
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
                child: const Text('Guardar producto'),
                onPressed: () {

                  print(image.toString());
                  deta = det.text.toString().trim();
                  ide = id.text.toString().trim();
                  prod = pro.text.toString().trim();
                  uploadPic(ctx);
                  _guardar(prod, deta, ide);
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        }
    );
  }
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path ${_image.path.toString()}');
    });
  }

  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  _guardar(String p, String d, String i) {

    databaseReference.child('$i').set({
      'nobre producto': p,
      'description': d,
    });
  }


}





import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyectosis/home.dart';
import 'package:proyectosis/homead.dart';
import 'package:firebase_database/firebase_database.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: Puente(),
    );
  }
}

class Puente extends StatefulWidget{
  @override
  MiProgra  createState() => MiProgra();
}

class MiProgra extends State<Puente>{
  @override
  var correo = TextEditingController();
  var pasw = TextEditingController();
  var _cont=true;
  var  _validate=false;
  var  _valpas=false;
  final databaseReference = FirebaseDatabase.instance.reference();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesion"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imagen('assets/sanga.png',70.0,70.0),
            imagen('assets/produc.jpg',190.0,190.0),
            TextField(
              decoration: InputDecoration(labelText: 'correo', hintText: 'ingrese correo electronico',
                errorText: _validate ? 'debe ser un correo' : null,
              ),
              controller: correo,
              keyboardType: TextInputType.emailAddress,


            ),
            TextField(
              obscureText: _cont,
              decoration: InputDecoration(labelText: 'Password',
                errorText: _valpas ? 'contraseña incorecta' : null,
                hintText: 'ingrese contraseña',
                suffixIcon: IconButton(icon: Icon(Icons.adjust), onPressed: () {
                  setState(() {
                    if(_cont){
                      _cont=false;
                    }else{
                      _cont=true;
                    }
                  });
                },
                ),
              ),
              controller: pasw,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text('Iniciar sesion',
                  style: TextStyle(fontSize: 20,color: Colors.white)),
              onPressed: signIn,
            )
          ],
        ),
      ),
    );
  }
  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }
  void signIn() async {
    if(validao()){
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: correo.text.toString().trim(), password: pasw.text.toString().trim());
       if(user.uid.toString()=='mOdynv3nbKNWFibz5oqd0bR9WRD3'){
         _pushScreen(context, Homead(user: user,));
       }
       else{
         _pushScreen(context, Home(user: user,));
       }

        print('siged user.udi ${user.uid}');
      }catch(e){
        Text(e.mesage);
        print(e.mesage);
      }
    }
  }

  bool validao() {
      setState(() {
        _validate=validateEmail(correo.text.toString());
      });
      if(_validate==false){
        return true;
      }
      else{
        return false;
      }
  }

  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => screen),
    );
  }

}


class imagen extends StatelessWidget{
  String t;
  double w,h;
  imagen(this.t, this.w, this.h);

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage=AssetImage(t);
    Image image=Image(image: assetImage,width:w ,height:h);
    return Container(child: image,);
  }

}


import 'package:voice_reocrder/components/rounded_button.dart';
import 'package:voice_reocrder/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';

import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  static String id="login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  String _warning;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              showError(),
              SizedBox(
                height: 48.0,
              ),
              Container(
                height: 200.0,
                child: Image.asset('assets/logo.png', height: 100, width: 100, fit: BoxFit.fitWidth,),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  _email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign:TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  _password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: "Log in",
                  colour: Colors.lightBlueAccent,
                  onPressed:()async{
                    try{
                      final user=await _auth.signInWithEmailAndPassword(email: _email, password: _password);
                      if(user!=null){
                        // Navigator.pushNamed(context,ChatScreen.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecorderHomeView(title: "Welcome to voice meeting",)),
                        );
                      }
                    }catch(e){
                      print(e);
                      setState(() {
                        _warning=e.message;
                      });
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Forget Password?",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text("Reset password",
                        style: TextStyle(
                            color: Colors.deepOrangeAccent
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget showError(){
    if(_warning!=null){
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    _warning=null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}

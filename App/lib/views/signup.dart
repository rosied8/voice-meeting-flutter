import 'package:voice_reocrder/constants.dart';
import 'package:flutter/material.dart';
import 'package:voice_reocrder/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_reocrder/views/Welcome.dart';
// import 'chat_screen.dart';

class SignUp extends StatefulWidget {
  static String id="register_screen";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth=FirebaseAuth.instance;
  String _warning;
  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;
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
                textAlign:TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _email=value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign:TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  _password=value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your pasword'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: "Register",
                  colour: Colors.lightBlueAccent,
                  onPressed: () async{
                    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
                      try{
                        final newUser=await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
                        if(newUser!=null){
                          // Navigator.pushNamed(context,ChatScreen.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Welcome()),
                          );
                        }
                      }catch(e){
                        setState(() {
                          _warning=e.message;
                        });
                        print(e);
                      }
                    }else{
                      setState(() {
                        _warning="Please enter a valid email.";
                      });
                      print("Please provide valid email address");
                    }
                  })
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

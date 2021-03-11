import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_reocrder/views/Welcome.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  //refactor class name user , from user to app user, otherwise there is conflict with firebase_auth
  // A class in firebase_auth also named user
  String _warning;
  final _emailController=TextEditingController();
  Image logo;

  @override
  void initState() {
    super.initState();
    logo = Image.asset('assets/logo.png', height: 100, width: 100, fit: BoxFit.fitWidth,);    // myImage= Image.asset('assets/logos/HeaderOrangeFull.png');
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  final double circleRadius = 150.0;
  final double circleBorderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text('Forgot Password'),
            ),
            backgroundColor: Colors.grey[50],
            body: SingleChildScrollView(
                child: Builder(
                    builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            showError(),
                            Container(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: logo,
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Reset Your Password',
                                )
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: 300,
                                child: TextFormField(
                                  controller: _emailController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    contentPadding: new EdgeInsets.all(10.0),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)) {
                                      setState(() {
                                        _warning="Please enter a valid email.";
                                      });
                                      return 'Please enter a valid email.';
                                    }
                                    return null;
                                  },
                                )
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget> [
                                InkWell(
                                    child: Container(
                                      width: ScreenUtil().setWidth(280),
                                      height: ScreenUtil().setHeight(100),
                                      alignment: Alignment.center,
                                      child: new FlatButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: Colors.grey[300]
                                            )
                                        ),
                                        color: Colors.white,
                                        onPressed: submit,
                                        child: new Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Expanded(
                                                child: Text(
                                                  "Submit",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        )
                    )
                )
            )
        )
    );
  }
  void submit() async{
    final form = _formKey.currentState;
    if (form.validate()) {
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        form.save();
        setState(() {
          _warning="Already send an emails";
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
        FocusScope.of(context).unfocus();
      }catch(e){
        print(e);
        setState(() {
          _warning=e.message;
        });
      }
    }
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

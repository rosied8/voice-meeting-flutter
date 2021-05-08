import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_reocrder/views/signin.dart';
import 'package:voice_reocrder/views/signup.dart';
class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => new _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Image logo;

  @override
  void initState() {
    super.initState();
    logo = Image.asset('assets/logo.png', height: 150, width: 250, fit: BoxFit.fitWidth,);    // myImage= Image.asset('assets/logos/HeaderOrangeFull.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: logo
                  // child: Image.asset('assets/logos/HeaderOrangeFull.png', height: 150, width: 250, fit: BoxFit.fitWidth,)
                ),
                SizedBox(height: ScreenUtil().setHeight(80)),
                InkWell(
                    child: Container(
                      width: ScreenUtil().setWidth(500),
                      height: ScreenUtil().setHeight(120),
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: Colors.grey[300]
                                  )
                              ),
                              color: Colors.white,
                              onPressed:  () {
                                // Call validator code to direct to correct app.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                InkWell(
                    child: Container(
                      width: ScreenUtil().setWidth(500),
                      height: ScreenUtil().setHeight(120),
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: Colors.grey[300]
                                  )
                              ),
                              color: Colors.white,
                              onPressed:  () {
                                // Call validator code to direct to correct app.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUp()),
                                );
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Sign Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ]
      ),
    );
  }
}
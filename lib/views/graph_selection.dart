import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_reocrder/views/gantt_chart_painter.dart';
import 'package:voice_reocrder/views/pie_paint.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';
import 'package:voice_reocrder/views/signin.dart';
import 'package:voice_reocrder/views/signup.dart';
import 'package:voice_reocrder/views/history_record.dart';
class GraphSelection extends StatefulWidget {
  @override
  Map timeln_result = Map<String, String>();
  var gender_result = Map<String, String>();
  Map history;
  GraphSelection({Key key, @required this.timeln_result, @required this.gender_result, @required this.history}) : super(key: key);
  _GraphSelectionState createState() => new _GraphSelectionState();
}
class _GraphSelectionState extends State<GraphSelection> {
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
      appBar: AppBar(
        title: Text('Lines'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>historyRecords(result: widget.history),),
            );
          },
        ),
      ),
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
                                  MaterialPageRoute(builder: (context) => PiePainter(timeln_result: widget.timeln_result,gender_result: widget.gender_result,)),
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
                                        "Pie chart",
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
                                  MaterialPageRoute(builder: (context) => MyPainter(timeln_result: widget.timeln_result,gender_result: widget.gender_result,)),
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
                                        "Gnatt chart",
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
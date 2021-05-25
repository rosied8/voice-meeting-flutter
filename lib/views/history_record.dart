import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voice_reocrder/views/pie_paint.dart';
import 'gantt_chart_painter.dart';
import 'graph_selection.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';
class historyRecords extends StatefulWidget {
  @override
  Map result;
  // In the constructor, require a Todo.
  historyRecords({Key key, @required this.result}) : super(key: key);
  _historyRecordsState createState() => _historyRecordsState();
}
class _historyRecordsState extends State<historyRecords> {
  @override
  Map<String,double> finalTimeLine=new Map();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lines'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => RecorderHomeView(title: "Welcome to voice meeting",)),
            );
          },
        ),
      ),
      body: new ListView.builder(
        itemCount: widget.result.length,
        itemBuilder: (BuildContext context, int index) {
          String key = widget.result.keys.elementAt(index);
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text("$key"),
                onTap: (){
                  var storeInfo=widget.result[key];
                  Map<String,String> timeResult = Map.castFrom(json.decode(storeInfo[0]));
                  Map<String,String> storeResult = Map.castFrom(json.decode(storeInfo[1]));
                  print("${storeInfo}");
                  Navigator.push(context,
                      MaterialPageRoute(
                        // builder: (context) => MyPainter(timeln_result:timeResult, gender_result:storeResult),
                        builder: (context) => GraphSelection(timeln_result:timeResult, gender_result:storeResult, history: widget.result),
                      )
                  );
                },
              ),
              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
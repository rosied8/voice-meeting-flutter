import 'dart:ui';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:voice_reocrder/views/graph_selection.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';
// var color_pool = [Colors.red, Colors.green, Colors.blue, Colors.amber, Colors.deepOrangeAccent, Colors.deepPurple, Colors.black87, Colors.tealAccent];
class PiePainter extends StatelessWidget {
  @override
  Map timeln_result = Map<String, String>();
  var gender_result = Map<String, String>();
  PiePainter({Key key, @required this.timeln_result, @required this.gender_result}) : super(key: key);
  Widget build(BuildContext context) {
    double timeConvert(String time) {
      int min;
      int sec;
      int msec;
      List<String>minSec = time.split(':');
      print(minSec.toString());
      min = int.parse(minSec[0]);
      print(min.toString());
      List<String> secMsec = minSec[1].split(".");
      sec = int.parse(secMsec[0]);
      msec = int.parse(secMsec[1]);
      print(sec);
      print(msec);
      // return (msec + 1000 * sec + 60000 * min)/1000;
      return (msec+1000 * sec + 60000 * min)/1000;
    };
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    //the data processing for pie chart
    var male_colors=[Colors.green[100],Colors.green[200],Colors.green[300],Colors.green[400],Colors.green[500]];
    var female_colors=[Colors.red[100],Colors.red[200],Colors.red[300],Colors.red[400],Colors.red[500]];
    var female_index=0;
    var male_index=0;
    print("The timelin_result for analysis is ");
    print(timeln_result);
    print(timeln_result.runtimeType);
    Map<String,double> finalTimeLine=new Map();
    for (var speaker in timeln_result.keys) {
      var periods = timeln_result[speaker];
      var pieces = periods.split(";");
      for (var piece in pieces) {
        var _start = piece.split("==>")[0];
        var _end = piece.split("==>")[1];
        double start = timeConvert(_start);
        double end = timeConvert(_end);
        double result=end-start;
        double duration=result.toDouble();
        // _start = _start.split(":")[1];
        // _end = _end.split(":")[1];
        // var start = double.parse('$_start');
        // var end = double.parse('$_end');
        // var duration = end - start;
        if (finalTimeLine.keys.contains(speaker)) {
          finalTimeLine.update(speaker, (v) {
            return (v + duration);
          }
          );
        } else {
          finalTimeLine[speaker] = duration;
        }
      }
    };
    print("final timeline result");
    print(finalTimeLine);
    var values = finalTimeLine.values;
    List<Color> colorList=[];
    var total = values.reduce((sum, element) => sum + element);
    for(var speaker in finalTimeLine.keys){
      var name=speaker;
      var percentage=finalTimeLine[speaker]/total;
      var color;
      var key=speaker+".wav";
      if(gender_result[key]=="Male"){
        color=male_colors[male_index];
        male_index+=1;
      }else{
        color=female_colors[female_index];
        female_index+=1;
      }
      // data.add(Data(name: name,percent: percentage,color: color));
      colorList.add(color);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Lines'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GraphSelection(timeln_result: timeln_result, gender_result: gender_result)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                PieChart(
                  dataMap: finalTimeLine,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  //colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  colorList: colorList,
                  ringStrokeWidth: 32,
                  centerText: "result",
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    //legendShape: _BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}




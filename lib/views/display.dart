import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
class TimeLine extends StatefulWidget {
  @override
  Map result;
  // In the constructor, require a Todo.
  TimeLine({Key key, @required this.result}) : super(key: key);
  _TimeLineState createState() => _TimeLineState();
}
class _TimeLineState extends State<TimeLine> {
  @override
  Map<String,double> finalTimeLine=new Map();
  Widget build(BuildContext context) {
    for(var v in widget.result.keys){
      var duration=(v[1]-v[0]).toDouble();
      var speaker=widget.result[v].toString();
      if(finalTimeLine.keys.contains(speaker)){
        finalTimeLine.update(speaker,(v){
          return (v+duration);
        }
        );
      }else{
        finalTimeLine[speaker]=duration;
      }
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PieChart(
              dataMap: finalTimeLine,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              //colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
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
            Timeline.tileBuilder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              builder: TimelineTileBuilder.fromStyle(
                contentsAlign: ContentsAlign.alternating,
                contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children:<Widget>[
                        Text('Speaker ${widget.result.values.elementAt(index)}'),
                        SizedBox(width: 10),
                        Expanded(child:Text('${(widget.result.keys.elementAt(index)[0]/60000).toInt()}m ${(widget.result.keys.elementAt(index)[0] % 60000/1000).toInt()}s ${widget.result.keys.elementAt(index)[0]%1000}ms' )),
                      ],
                    )
                ),
                itemCount: widget.result.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Timeline.tileBuilder(
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
      ),
    );
  }
}
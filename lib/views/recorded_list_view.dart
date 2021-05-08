import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:voice_reocrder/views/recorder_view.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  const RecordListView({
    Key key,
    this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  int _totalDuration;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  // Recording _current;
  // AudioPlayerState _currentStatus=AudioPlayerState.COMPLETED;

  bool isPlaying = false;
  bool isStarted = false;
  Duration duration;
  int time;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    print(widget.records);
    return ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return ExpansionTile(
          title: Text('New recoding ${widget.records.length - i}'),
          subtitle: Text(
              _getDateFromFilePatah(filePath: widget.records.elementAt(i))),
          onExpansionChanged: ((newState) {
            if (newState) {
              setState(() {
                _selectedIndex = i;
              });
            }
          }),
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    value: _selectedIndex == i ? _completedPercentage : 0,
                  ),
                  IconButton(
                    icon: _selectedIndex == i
                        ? _isPlaying
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow)
                        : Icon(Icons.play_arrow),
                    onPressed: () => _onPlay(
                        filePath: widget.records.elementAt(i), index: i),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> _onPlay({@required String filePath, @required int index}) async {
    if (!_isPlaying&&!isStarted) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });
      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }else if(isStarted&&!_isPlaying){
      audioPlayer.resume();
      setState(() {
        _selectedIndex = index;
        _completedPercentage=_currentDuration.toDouble() / _totalDuration.toDouble();
        _isPlaying = true;
      });
      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
          isStarted=true;
        });
      });
      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          isStarted=false;
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
    }
    else{
      audioPlayer.pause();
      setState(() {
        _selectedIndex = index;
        _completedPercentage=_currentDuration.toDouble() / _totalDuration.toDouble();
        _isPlaying = false;
      });
    }
  }


  String _getDateFromFilePatah({@required String filePath}) {
    print(filePath);
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
    DateTime recordedDate =
    DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    return ('$year-$month-$day');
  }
}
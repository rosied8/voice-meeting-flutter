import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:voice_reocrder/views/Welcome.dart';
class InstructionPage extends StatefulWidget {
  @override
  _InstructionPageState createState() => _InstructionPageState();
}
class _InstructionPageState extends State<InstructionPage> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset('assets/instruction1.JPG', height: 20, width: 20, fit: BoxFit.fitWidth,),
          title: "Registration",
          body: "User need to register email and password information to login",
          // footer: Text("Footer Text here "),
          decoration: const PageDecoration(
            // pageColor: Colors.blue,
          )),
      PageViewModel(
        image: Image.asset('assets/instruction2.JPG', height: 20, width: 20, fit: BoxFit.fitWidth,),
        title: "Recording",
        body: "User could click this button to record and double click to stop recording",
        // footer: Text("Footer Text  here "),
      ),
      PageViewModel(
        image: Image.asset('assets/instruction3.JPG', height: 20, width: 20, fit: BoxFit.fitWidth,),
        title: "Result check",
        body: "User click the result button to fetch result, after a few minutes, click history button to see result",
        // footer: Text("Footer Text  here "),
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Introduction Screen"),
      ),
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Text("Skip"),
        done: Text("Got it "),
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
          );
        },
      ),
    );
  }
}
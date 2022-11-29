//import 'dart:html';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String,HighlightedWord> _highlights={
    'flutter':HighlightedWord(
      onTap: ()=>print('flutter'),
      textStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,

      )
    ),
    'voice':HighlightedWord(
      onTap: ()=> print('voice'),
      textStyle: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,

      )
    ),
    'subscribe':HighlightedWord(
  onTap: ()=> print('subscribe'),
  textStyle: TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.bold
  ),
    ),
  };




  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = 'press the button and start speaking ';
  double _confidence =1.0;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }
  //_speech =stt.SpeechToText();
   //final _speech = stt.SpeechToText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('confidence: ${(_confidence *100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton:AvatarGlow(
        animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(



        onPressed: _isListen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),


        ) ,

        body: SingleChildScrollView(
        reverse: true,
          child: Container(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: TextStyle(
                fontSize: 32.0,
                color: Colors.black,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
    ),
    );
  }
  void _isListen()async{
    if(!_isListening){
      bool available= await _speech!.initialize(
          onStatus: (val)=>print('onStatus:$val'),
          onError: (val)=> print('onError$val')
      );
      if (available){
        setState(() =>_isListening=true);
        _speech?.listen(
          onResult: (val)=>setState(() {
            _text =val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence>0){

              _confidence=val.confidence;
            }
          }),
        );



      }
      else{
        setState(()=> _isListening=false);
        _speech?.stop();


      }
    }
  }

}

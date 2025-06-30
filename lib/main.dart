import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(StopwatchApp());

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StopwatchHome(),
    );
  }
}

class StopwatchHome extends StatefulWidget {
  @override
  _StopwatchHomeState createState() => _StopwatchHomeState();
}

class _StopwatchHomeState extends State<StopwatchHome> {
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _milliseconds += 10;
      });
    });
    _isRunning = true;
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
    }
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _milliseconds = 0;
    });
  }

  String _formatTime(int ms) {
    int minutes = (ms ~/ 60000);
    int seconds = (ms ~/ 1000) % 60;
    int milli = (ms ~/ 10) % 100;
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}:${_twoDigits(milli)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stopwatch")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(_milliseconds),
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Start', Colors.green, _startTimer),
              SizedBox(width: 10),
              _buildButton('Pause', Colors.orange, _pauseTimer),
              SizedBox(width: 10),
              _buildButton('Reset', Colors.red, _resetTimer),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guides/home_app_bar.dart';
import 'home_app_bar.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: _text,
        onSelect: (text) => setState(() =>  _text = text),
      ),
      body: Text(_text == null ? "Home" : "Searched \"$_text\""),
    );
  }
}
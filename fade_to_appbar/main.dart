import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flexible_header.dart';

// credit https://stackoverflow.com/questions/51321804/how-to-fade-in-out-a-widget-from-sliverappbar-while-scrolling

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onBackPressed() {
    print("onBackPressed");
  }

  bool _allowBlocStateUpdates = false;
  _allowBlocUpdates(bool allow) => setState(() => _allowBlocStateUpdates = allow);

  static const _PADDING_LR = 7.0, _PADDING_B = 15.0;
  bool _isFirstItem = true;
  EdgeInsets _getPadding() {
    if (_isFirstItem) {
      // this first one is a workaround so that the header does not get rendered over the content
      _isFirstItem = false;
      return EdgeInsets.fromLTRB(_PADDING_LR, 56, _PADDING_LR, _PADDING_B);
    }
    return EdgeInsets.fromLTRB(_PADDING_LR, 0, _PADDING_LR, _PADDING_B);
  }

  @override
  Widget build(BuildContext context) {
    _isFirstItem = true;
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Listener(
        onPointerMove: (details) => _allowBlocUpdates(true),
        onPointerUp: (details) => _allowBlocUpdates(false),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            FlexibleHeader(
              allowBlocStateUpdates: _allowBlocStateUpdates,
              innerBoxIsScrolled: innerBoxIsScrolled,
              onBackPressed: _onBackPressed,
            ),
          ],
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: _getPadding(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  height: 240,
                  child: ListTile(
                    tileColor: const Color(0xff212121),
                    title: Text("Item ${index+1}", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


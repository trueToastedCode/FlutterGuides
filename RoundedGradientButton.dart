import 'package:flutter/material.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _GRADIENT_COLORS = [
    [Color(0xff2AFDB7), Color(0xff09C893)],
    [Color(0xff612CFB), Color(0xffBF63DB)],
    [Color(0xffFEC954), Color(0xffFF7B0C)]
  ];

  int _gradientColorIndex = 0;

  /// increase _gradientColorIndex by one, reset to zero at end
  void _nextColor() {
    setState(() => _gradientColorIndex = (_gradientColorIndex + 1) % _GRADIENT_COLORS.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    // stops: [0.0, 1.0],
                    colors: _GRADIENT_COLORS[_gradientColorIndex],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "MyButton",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: _nextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


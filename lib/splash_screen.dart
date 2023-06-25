import 'home_page.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    _controller.forward().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(customerId: 0)));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.14,
                  child: Image.asset(
                    'logo.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (BuildContext context, Widget? child) {
                final textLength = 'The House Coffee Shop'.length;
                final currentLength = (_textAnimation.value * textLength).floor();
                final text = 'The House Coffee Shop'.substring(0, currentLength);
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
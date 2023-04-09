import 'home_page.dart';
import'main.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(customerId: 0,)));
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
          Image.asset(
              'logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
           /*Image.network(
            'https://cdn1.picuki.com/hosted-by-instagram/q/0exhNuNYnjBcaS3SYdxKjf8K2fRyWg9SZ60STLepjSVmIR1vLHOapZA0mpCj4yRwKwVlASudYzxi4YItV1hVCz15OEHfSrOITD1S7KmRVOqqvDRv85Bjnbw2KnQcbHGm%7C%7CsspVwmYdSgIGaYDG7uo+qhT5aGuO1lGpTGSfLdAmHBtv8CbULYo2ZIv7LaCjl+o54Mwd3AYvGglKkAmscnbrSgLUbrzPcMymq90ebQNnppUu7mopCu7LmIieDNzLRigtazXh8xatALQSxtrq1OXAaw%7C%7CIhE%7C%7CqnCKkRM6kK0PqaTkN45vhKl15ObYRDtXD1NKoTc7pJCWnjrVTlqE5XJz2Xr5xefhRKksiJzgcvqpV+674y%7C%7CZY5rIHJdjUio+RvPTDgmIctCUJZwL0LRBH8dd3lrooFXoduP1.jpeg',
             width: 200,
             height: 200,
             fit: BoxFit.cover,
            ),*/

            Text(
              'The House Coffee Shop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

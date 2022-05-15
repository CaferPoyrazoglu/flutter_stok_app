import 'package:flutter/material.dart';
import 'package:flutter_stok/main.dart';
import 'package:flutter_stok/theme.dart';

import 'custom_headline.dart';
import 'delay_effect.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                const HomePage(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 500),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  DelayedDisplay(
                      delay: Duration(milliseconds: 100),
                      child: CustomHeadline(
                        text: MyTheme.appName,
                        myFW: FontWeight.bold,
                        fSize: 1.6,
                        myColor: MyTheme.renkSiyah,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  DelayedDisplay(
                      delay: Duration(milliseconds: 600),
                      child: CustomHeadline(
                        text: "Kolay ",
                        myColor: MyTheme.renkSiyah,
                      )),
                  DelayedDisplay(
                      delay: Duration(milliseconds: 800),
                      child: CustomHeadline(
                        text: "Stok",
                        myFW: FontWeight.bold,
                        myColor: MyTheme.renkSiyah,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  DelayedDisplay(
                      delay: Duration(milliseconds: 1000),
                      child: CustomHeadline(
                        text: "Uygulaması",
                        myColor: MyTheme.renkSiyah,
                      )),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}

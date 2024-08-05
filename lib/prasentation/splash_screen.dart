import 'dart:async';

import 'package:fitness_app/prasentation/resources/colors_manager.dart';
import 'package:fitness_app/prasentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   Timer? _timer;

  _startDelay(){
    _timer =  Timer(const Duration(seconds: 3),_goToNext);
  }

  _goToNext()async{
    Navigator.pushReplacementNamed(context, Routes.homePage);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            ColorManager.shadowColor.withOpacity(0.9),
                ColorManager.deepPurpleAccent.withOpacity(0.9),

          ],
          begin: Alignment.bottomLeft,
            end: Alignment.topRight
          )
        ),
        child: Center(
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.white,
              boxShadow:  [
                BoxShadow(
                  color: ColorManager.shadowColor,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                  spreadRadius: 5
                )
              ],
              image: DecorationImage(image: AssetImage('assets/images/vecteezy_fitness-icon-for-your-website-design-logo-app-ui_20195404.jpg'))
            ),

          ),        ),
      ),
    );
  }
}

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/prasentation/splash_screen.dart';
import 'package:flutter/material.dart';

import '../video_Info_dart.dart';

class Routes{
  static const String splashScreen = '/';
  static const String homePage =  '/homepage';
  static const String videDetailPage = '/videoDetailPage';
}



class RoutesGenerator{
  static Route<dynamic> getRoutes(RouteSettings settings){

    switch(settings.name){
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen(),);

      case Routes.homePage:
        return MaterialPageRoute(builder: (context) => const HomePage(),);

      case Routes.videDetailPage:
        return MaterialPageRoute(builder: (context) => const VideoInfo(),);
      default:
        return unknownRoute();
    }
  }

 static Route<dynamic> unknownRoute(){
    return MaterialPageRoute(builder: (context) => const Scaffold(
      body: Center(
        child: Text('No Routes Found'),
      ),
    ),);
  }
}



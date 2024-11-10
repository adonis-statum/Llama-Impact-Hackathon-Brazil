import 'package:conecta_ai_app/src/ui/pages/HomePage/home_page_screen.dart';
import 'package:conecta_ai_app/src/ui/pages/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conecta AI',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SplashScreen(
        nextScreen: HomePageScreen(),
      ),
    );
  }
}

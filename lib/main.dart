import 'package:coronamap_flutter/loading_screen.dart';
import 'package:coronamap_flutter/main_screen.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      home: LoadingScreen(),
    );
  }
}

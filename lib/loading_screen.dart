import 'package:coronamap_flutter/main_screen.dart';
import 'services/maskdata.dart';
import 'package:flutter/material.dart';
import 'services/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  Location location = Location();
  @override
  void initState() {
    super.initState();
    getLocationData();

  }

  double latitude;
  double longitude;


  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;

    var maskData = await Location().getCurrentLocation();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MainScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        )
//        FutureBuilder(
//          future: Future.delayed(Duration(seconds: 5)),
//          builder: (c,s) => s.connectionState == ConnectionState.done
//              ? MainScreen()
//          : SpinKitDoubleBounce(
//            color: Colors.white,
//            size: 100.0,
//          )
//
//          ,
//        ),
////        child: FlutterError.onError != null ? MainScreen()
////         : SpinKitDoubleBounce(
////          color: Colors.white,
////          size: 100.0,
////        ),
      ),
    );
  }
}

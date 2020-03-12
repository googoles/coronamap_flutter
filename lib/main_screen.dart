import 'dart:async';
import 'dart:ui';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'services/maskdata.dart';
import 'services/location.dart';

class MainScreen extends StatefulWidget {
  MainScreen({this.locationMask});

  final locationMask;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GetMaskData getMaskData = GetMaskData();

//  Location location = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print('${getMaskData.getLocationMask()}');
//    print(location.latitude);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('코로나 마스크 찾기'),
        ),
        body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                target: LatLng(35.967, 126.71),
                zoom: 16,
              ))),
        ));
  }
}

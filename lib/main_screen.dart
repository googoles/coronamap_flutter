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
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                target: LatLng(35.967, 126.71),
                zoom: 16,
              )),
            ),
            Positioned(
                left: 0,
                bottom: 0,
                child: MenuWidget())
          ],
        )
    );
  }
}

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {

    int distance = 1000;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height/3,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            width: width,
            height: height/3,
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    inactiveTrackColor: Color(0xFF8D8E98),
                    thumbColor: Color(0xFFEB1555),
                    activeTrackColor: Colors.white,
                    overlayColor: Color(0x29EB1555),
                    thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: 15.0),
                    overlayShape:
                    RoundSliderOverlayShape(overlayRadius: 30.0)),
                child: Slider(
                  value: distance.toDouble(),
                  max: 5000,
                  min: 100,
                  onChanged: (double newValue) {
                    setState(() {
                      distance = newValue.round();
                    });
                  },
                )),
          )

        ],
      ),
    );
  }
}


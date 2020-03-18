import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'services/maskdata.dart';
import 'services/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/models.dart';
import 'services/network.dart';

const maskUrl =
    'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json';

class MainScreen extends StatefulWidget {
  MainScreen({this.locationMask});

  final locationMask;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showBottomMenu = false;

  List storeData;
  double latitude;
  double longitude;
  Location location = Location();
//  latitude = Location().getCurrentLocation();


  void updateUI(dynamic locationData){
    setState(() {
      if (locationData == null) {
        latitude = 33.450701;
        longitude = 126.570667;
        return;
      }
      latitude = location.latitude;
      longitude = location.longitude;
    });
  }


  // 마스크 정보를 가져오는 기능 Location에서 위치를 가져오고 스크롤바로 거리조절 가능!!
  Future<Stores> getLocationMask() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$maskUrl?lat=${location.latitude}&lng=${location.longitude}&m=500');

    // ?lat=35.9674&lng=126.71&m=500
    var maskData = await networkHelper.getData();

    setState(() {
      storeData = maskData['stores'];
    });
//    print(storeData.toString());
//    print(maskData['stores'].length);
    return maskData['stores'];
  }

  Future<Stores> getLocationMaskDefault() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$maskUrl?lat=${location.latitude}&lng=${location.longitude}&m=500');

    // ?lat=35.9674&lng=126.71&m=500
    var maskData = await networkHelper.getData();

//    print(maskData);
    return maskData['stores'];
  }

  @override
  void initState() {
    this.getLocationMask();
    super.initState();
    location.getCurrentLocation();
    updateUI(widget.locationMask);
  }

  Widget _status(status) {
    if (status == 'empty') {
      return Text('재고소진', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),);

    } else if (status == 'break') {
      return Text('판매중지', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
    } else if (status == 'few') {
      return Text('30개 이하 남았어요', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
    } else if (status == 'some') {
      return Text('100개 이하 30개 이상 남았어요', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
    } else {
      return Text('넉넉해요!!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
    }
  }

  Color _colorStatus(status) {
    if (status == 'empty') {
      return Colors.grey;

    } else if (status == 'break') {
      return Colors.grey;
    } else if (status == 'few') {
      return Colors.red;
    } else if (status == 'some') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  GoogleMapController _controller;

  void _setMapController(GoogleMapController controller) {
    this._controller = controller;

    Future.delayed(Duration(milliseconds: 3000)).then((onValue) =>
        controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(35.9674, 126.71), 15)));
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    int _distance = 500; // initial value
    double width = MediaQuery.of(context).size.width;

    var threshold = 100;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            '코로나 마스크 찾기',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GestureDetector(
          onPanEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > threshold) {
              this.setState(() {
                showBottomMenu = false;
              });
            } else if (details.velocity.pixelsPerSecond.dy < -threshold) {
              this.setState(() {
                showBottomMenu = true;
              });
            }
          },
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                      compassEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      onMapCreated: this._setMapController,
                      onCameraMove: (cameraPosition) => print('Movee: $cameraPosition'),

                      initialCameraPosition: CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 15,
                      )


                  ),
                ),
                Opacity(
                  opacity: (showBottomMenu) ? 1.0 : 0.0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                AnimatedPositioned(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 200),
                    left: 0,
                    bottom: (showBottomMenu) ? -60 : -(height / 1.5),
                    child: Opacity(
                        opacity: 0.75,
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.black,
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(40),
                                  topRight: const Radius.circular(40))),
                          width: width,
                          height: height / 1.5 + 80 + (height / 15),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    Expanded(
                                      child: Container(
                                        width: width,
                                        height: height / 15,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            '거리조절하기',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: width - (width / 4),
                                    height: height / 15,
                                    child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            inactiveTrackColor:
                                                Color(0xFF8D8E98),
                                            thumbColor: Color(0xFFEB1555),
                                            activeTrackColor: Colors.white,
                                            overlayColor: Color(0x29EB1555),
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 15.0),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 30.0)),
                                        child: Slider(
                                          value: _distance.toDouble(),
                                          max: 3000,
                                          min: 100,
                                          onChanged: (double newValue) {
                                            setState(() {
                                              _distance = newValue.round();
                                            });
                                          },
                                          label: '$_distance',
                                        )),
                                  ),
                                  Container(
                                      width: width / 5,
                                      decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.red),
                                      child: FlatButton(
                                          onPressed: () {},
                                          child: Text(
                                            '찾기',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          )))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                    height: height/1.7,
                                    width: width,
                                    child: ListView.builder(
                                        itemCount: storeData == null
                                            ? 0
                                            : storeData.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                              child: Container(
                                                height: height/6,
                                                width: width - width/5,
                                            decoration: new BoxDecoration(
                                              borderRadius: new BorderRadius.all(Radius.circular(20)),
                                              color: _colorStatus(storeData[index]['remain_stat']),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  '${storeData[index]['name']}',
                                                  style:
                                                  TextStyle(color: Colors.black, fontSize: height/30, fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${storeData[index]['addr']}',
                                                  style:
                                                      TextStyle(color: Colors.black),
                                                ),

                                                Container(
                                                  child: _status(storeData[index]['remain_stat']),
                                                ),
//
                                                Text(
                                                  '${storeData[index]['stock_at']}',
                                                  style:
                                                  TextStyle(color: Colors.black, fontSize: height/50, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ));
                                        })),
                              )
                            ],
                          ),
                        )))
              ],
            ),
          ),


        )
    );



  }
}

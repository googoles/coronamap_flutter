import 'dart:async';
import 'dart:ui';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'services/maskdata.dart';
import 'services/location.dart';
import 'dart:convert';
import 'loading_screen.dart';
import 'package:http/http.dart' as http;
import 'services/models.dart';

class MainScreen extends StatefulWidget {
  
  MainScreen({this.locationMask});

  final locationMask;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  GetMaskData getMaskData = GetMaskData();

  bool showBottomMenu = false;


//  Location location = Location();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
//    print('${getMaskData.getLocationMask().then((val){
//    })}');
//    print(location.latitude);

    var threshold = 100;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text('코로나 마스크 찾기', style: TextStyle(color: Colors.white),),
        ),
        body: GestureDetector(
          onPanEnd: (details){
            if(details.velocity.pixelsPerSecond.dy > threshold) {
              this.setState((){
                showBottomMenu = false;
              });
            } else if (details.velocity.pixelsPerSecond.dy < -threshold){
              this.setState((){
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
                      initialCameraPosition: CameraPosition(
                        target: LatLng(35.967, 126.71),
                        zoom: 16,
                      )),
                ),
                Opacity(opacity: (showBottomMenu)?1.0:0.0,
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),),),
                
                AnimatedPositioned(
                  curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 200),
                    left: 0,
                    bottom: (showBottomMenu)?-60:-(height/1.5),
                    child: Opacity(opacity: 0.75, child: MenuWidget()))
              ],
            ),
          ),
        ));
  }
}

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {


  Location location = Location();
  List<Store> _stores = List<Store>();


  Future<List<Store>> fetchDatas() async {
//    var url = '$maskUrl?lat=${location.latitude}&lng=${location.longitude}&m=500';
    var url = '$maskUrl?lat=${35.9714}&lng=${126.6954}&m=500';
    var response = await http.get(url);

    var stores = List<Store>();

    if (response.statusCode == 200) {
      var storesJson = json.decode((response.body));
      print(response.body);
      for (var storesJson in storesJson) {
        stores.add(Store.fromJson(storesJson));
      }
    }
    return stores;
  }

  @override
    void initState() {
    fetchDatas();
//    print(fetchDatas());
    location = Location();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    int distance = 1000;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;



    return Container(
      decoration: new BoxDecoration(
          color: Colors.black,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40))),
      width: width,
      height: height / 1.5 + 80 + (height/15),
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
                    height: height/15,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
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
                width: width - (width/4),
                height: height / 15,
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        inactiveTrackColor: Color(0xFF8D8E98),
                        thumbColor: Color(0xFFEB1555),
                        activeTrackColor: Colors.white,
                        overlayColor: Color(0x29EB1555),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0)),
                    child: Slider(
                      value: distance.toDouble(),
                      max: 3000,
                      min: 100,
                      onChanged: (double newValue) {
                        setState(() {
                          distance = newValue.round();
                        });
                      },
                    )),
              ),
              Container(
                width: width/5,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.red
                ),
                  child: FlatButton(onPressed: (){}, child: Text('Find', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),)))
            ],
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}

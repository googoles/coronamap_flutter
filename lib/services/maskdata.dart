import 'package:coronamap_flutter/services/location.dart';
import 'package:coronamap_flutter/services/network.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';

const maskUrl =
    'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json';


class GetMaskData {

  Future<dynamic> getLocationMask() async {

    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$maskUrl?lat=${location.latitude}&lng=${location.longitude}&m=500');

    // ?lat=35.9674&lng=126.71&m=500
    var maskData = await networkHelper.getData();

    print(maskData);
    return maskData;
  }
}


import 'package:coronamap_flutter/services/location.dart';
import 'package:coronamap_flutter/services/network.dart';

const maskUrl = 'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json';

class GetMaskData {

  Future<dynamic> getLocationMask() async {

    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$maskUrl?lat=${location.latitude}&lng=${location.longitude}&m=500');

    // ?lat=35.9674&lng=126.71&m=500
    var maskData = await networkHelper.getData();

    return maskData;
  }


}
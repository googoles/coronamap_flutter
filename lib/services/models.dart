class Store{
  int count;
  List<StoreLocation> data;

  Store({this.count, this.data});

  factory Store.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<StoreLocation> data = list.map((i) => StoreLocation.fromJson(i)).toList();

    return Store(
        count: parsedJson['count'],
        data: data
    );
  }
}



class StoreLocation{
  String addr;
  int lat;
  int lng;
  String name;
  String remain_stat;
  String stock_at;
  String type;

  StoreLocation({this.addr, this.lat, this.lng, this.name, this.remain_stat,
    this.stock_at, this.type});

  factory StoreLocation.fromJson(Map<String, dynamic> parsedJson){
    return StoreLocation(
      addr: parsedJson['addr'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      name: parsedJson['name'],
      remain_stat: parsedJson['remain_stat'],
      stock_at: parsedJson['stock_at'],
      type: parsedJson['type'],
    );
  }

}

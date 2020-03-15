
class Stores{
  String addr;
  int lat;
  int lng;
  String name;
  String remain_stat;
  String stock_at;
  String type;

  Stores({this.addr, this.lat, this.lng, this.name, this.remain_stat,
    this.stock_at, this.type});

  factory Stores.fromJson(Map<String, dynamic> parsedJson){
    return Stores(
      addr: parsedJson['addr'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      name: parsedJson['name'],
      remain_stat: parsedJson['remain_stat'],
      stock_at: parsedJson['stock_at'],
      type: parsedJson['type'],
    );
  }

  @override
  String toString() {
    return '${this.addr},${this.lat},${this.lng},${this.name},${this.remain_stat},${this.stock_at},${this.type},';
  }

}

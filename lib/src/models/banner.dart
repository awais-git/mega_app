import '../models/media.dart';

class Banner {
  String id;
  String name;
  Media image;
  double range;
  String latitude;
  String longitude;
  double distance;

  Banner();

  Banner.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      range = jsonMap['range'] != null ? jsonMap['range'].toDouble() : 0.0;
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      range = 0.0;
      latitude = '0';
      longitude = '0';
      distance = 0.0;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'range': range,
      'distance': distance,
    };
  }
}

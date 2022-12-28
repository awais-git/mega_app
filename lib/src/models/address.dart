import 'package:location/location.dart';

class Address {
  String id;
  String description;
  String address;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;
  String nit_name;
  String nit;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null ? jsonMap['description'].toString() : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude = jsonMap['latitude'] != null ? jsonMap['latitude'] : null;
      longitude = jsonMap['longitude'] != null ? jsonMap['longitude'] : null;
      isDefault = jsonMap['is_default'] ?? false;
      nit_name = jsonMap['nit_name'] != null ? jsonMap['nit_name'] : null;
      nit = jsonMap['nit'] != 0 ? jsonMap['nit'] : 0;
    } catch (e) {
      print(e);
    }
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    map["nit_name"] = nit_name;
    map["nit"] = nit;
    return map;
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  bool nitCompleted() {
    //return address != null && address != '' && phone != null && phone != '';
    return nit != null && nit != '' && nit_name != null && nit_name != '' ;
  }
}

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/user.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressController extends ControllerMVC with ChangeNotifier {
  List<model.Address> addresses = <model.Address>[];
  model.Address direccion = null;
  GlobalKey<ScaffoldState> scaffoldKey;
  
  DeliveryAddressController() {
    print('**DeliveryAddressController');
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
  }

  void listenForAddresses({String message }) async {
    User _user = userRepo.currentUser.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('delivery_address')) {
      model.Address _address = model.Address.fromJSON(json.decode(prefs.getString('delivery_address')));
      setState(() {
        addresses.add(_address);
        addAddress(_address,showMsg:false);
        print("**listenForAddresses A session SUCCESS");
        direccion=_address;
      });
    }
    if (_user.apiToken != null) {
      print("devolviendo 0");
      final Stream<model.Address> stream = await userRepo.getAddresses();
      stream.listen((model.Address _address) {
        print("devolviendo 3");
        print(_address);
        setState(() {
          addresses=[];// Limpia 
          addresses.add(_address);
          print("**listenForAddresses A SUCCESS");
          direccion=_address;
        });
      }, onError: (a) {
        print("devolviendo 4e");
        print(a);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
        ));
      }, onDone: () {
        print("devolviendo 5");
        print(message);
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      });
    }
  }

  Future<void> refreshAddresses() async {
    print("**refreshAddresses");
    addresses.clear();
    listenForAddresses(message: S.of(context).addresses_refreshed_successfuly);
  }

  Future<void> changeDeliveryAddress(model.Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
    // model.Address _address = await settingRepo.setCurrentLocation();
    // setState(() {
    //   settingRepo.deliveryAddress.value = _address;
    // });
    // settingRepo.deliveryAddress.notifyListeners();
  }

  void addAddress(model.Address address,{bool showMsg=true }) {
    settingRepo.deliveryAddress.value = address;
    changeDeliveryAddress(address).then((value2) {
      userRepo.addAddress(address).then((value) {
        setState(() {
          this.addresses.insert(0, value);
          this.direccion=value;
        });
        if(showMsg==true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).new_address_added_successfully),
          ));
        }
      });
    });
  }

  void chooseDeliveryAddress(model.Address address ) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(model.Address address ) {
    settingRepo.deliveryAddress.value = address;
    changeDeliveryAddress(address).then((value2) {
      
      userRepo.updateAddress(address).then((value) {
        setState(() {});
        
        addresses.clear();
        listenForAddresses(message: S.of(context).the_address_updated_successfully);
      });
    });
    
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).delivery_address_removed_successfully),
      ));
    });
  }
}

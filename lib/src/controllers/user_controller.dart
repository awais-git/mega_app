import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'dart:convert';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as repository;
import '../models/address.dart' as model;
import '../models/route_argument.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      var valor = await repository.login(user).catchError((e) {
        String errMsg;
        print(e.message);
        if(e.message.contains('{')){
          Map<String, dynamic> er=jsonDecode(e.message);
          errMsg=er['message'];
        }else{
          if(e.message=='Connection failed'){
            errMsg=S.of(context).verify_your_internet_connection;
          }else{
            errMsg=e.message;
          }
        }

        loader.remove();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text(S.of(context).this_account_not_exist),
          content: Text(errMsg),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });;
      
      if (valor != null && valor.apiToken != null) {
        //Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        // Almacena la nueva direccion
        bool isNew=true;
        if (prefs.containsKey('delivery_address')) {
          model.Address _address = model.Address.fromJSON(json.decode(prefs.getString('delivery_address')));
          //TODO - gaston - verificar si no tienes direccion y adicionar 
          final Stream<model.Address> stream = await repository.getAddresses();
          stream.listen((model.Address _address1) async {
            print("devolviendo 3");
            print(_address1);
              print("**listenForAddresses LOGIN SUCCESS");
              _address.id=_address1.id;
              settingRepo.deliveryAddress.value = _address1;
              await repository.updateAddress(_address);
              isNew=false;
              prefs.setString('delivery_address', json.encode(_address.toMap()));
            
          }, onError: (a) {
            print("devolviendo LOGIN 4e");
            print(a);
          }, onDone: () async {
            print("devolviendo LOGIN 5");
            if(isNew){
              model.Address  value2 = await repository.addAddress(_address);
              settingRepo.deliveryAddress.value = value2;
              await prefs.setString('delivery_address', json.encode(value2.toMap()));
            }
          });
          print("devolviendo LOGIN 6");            
          

          
        }
        Navigator.of(scaffoldKey.currentContext).pop();
        Navigator.of(scaffoldKey.currentContext).pop();
        if (prefs.containsKey('last_product_id')) {
          Navigator.of(scaffoldKey.currentContext).pushNamed('/Product', arguments: RouteArgument(id: prefs.getString('last_product_id')));
          // Navigator.of(scaffoldKey.currentContext).popAndPushNamed('/Product', arguments: RouteArgument(id: prefs.getString('last_product_id')));
        }else{
          Navigator.of(scaffoldKey.currentContext).pushNamed('/Pages', arguments: 2);
        }
        //  Navigator.of(scaffoldKey.currentContext).pop();
        // Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/DeliveryAddressMain');
        // Navigator.of(scaffoldKey.currentContext).pushNamed('/Pages', arguments: 2);
      } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).wrong_email_or_password),
        ));
      }
    }
  }

  void register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      var valor = await repository.register(user).catchError((e) {
        String errMsg;
        print(e.message);
        if(e.message.contains('{')){
          Map<String, dynamic> er=jsonDecode(e.message);
          errMsg=er['message'];
        }else{
          if(e.message=='Connection failed'){
            errMsg=S.of(context).verify_your_internet_connection;
          }else{
            errMsg=e.message;
          }
        }
        
        loader.remove();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text(S.of(context).this_email_account_exists),
          // content: Text(er['message']),
           content: Text(errMsg),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
      if (valor != null && valor.apiToken != null) {
          // Almacena la nueva direccion
          if (prefs.containsKey('delivery_address')) {
            model.Address _address = model.Address.fromJSON(json.decode(prefs.getString('delivery_address')));
            model.Address  value2 = await repository.addAddress(_address);
            settingRepo.deliveryAddress.value = value2;
            await prefs.setString('delivery_address', json.encode(value2.toMap()));
          }
          if (prefs.containsKey('last_product_id')) {
            Navigator.of(scaffoldKey.currentContext).pop();
            Navigator.of(scaffoldKey.currentContext).pop();
            Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Product', arguments: RouteArgument(id: prefs.getString('last_product_id')));
            // Navigator.of(scaffoldKey.currentContext).pop();
          }else{
            Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
          }
          //Navigator.of(scaffoldKey.currentContext).pop();
          // antiguamente mandabamos a revisar direccion despues de registro
          //Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/DeliveryAddressMain');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
    }
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}

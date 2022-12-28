import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_address_controller.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../repository/settings_repository.dart';
// import '../models/route_argument.dart';
import '../helpers/app_config.dart' as config;

class DeliveryAddressWidget extends StatefulWidget {
  final dynamic compra;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  DeliveryAddressWidget({Key key, this.compra, this.parentScaffoldKey}) : super(key: key);

  @override
  _DeliveryAddressWidgetState createState() => _DeliveryAddressWidgetState();
}

class _DeliveryAddressWidgetState extends StateMVC<DeliveryAddressWidget> {
  DeliveryAddressController _con;
  PaymentMethodList list;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();
  bool _validateNombre = false;
  TextEditingController txt  = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();

  _DeliveryAddressWidgetState() : super(DeliveryAddressController()) {
    _con = controller;
  }

@override
  void initState() {
    // route param contains the payment method
    print("initState*****");
    print(widget.compra);
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    if(txt.text==""){
      txt.text=_con.direccion?.address?.isNotEmpty ?? false ? _con.direccion?.address : null;
    }
    if(txt2.text==""){
      txt2.text=_con.direccion?.description?.isNotEmpty ?? false ? _con.direccion?.description : null;
    }
    if(txt3.text==""){
      txt3.text=_con.direccion?.nit_name != null ? _con.direccion?.nit_name : null;
    }
    if(txt4.text==""){
      txt4.text= _con.direccion?.nit != null ? _con.direccion?.nit : null;
    }
    var latTxt= _con.direccion?.latitude != null ? _con.direccion?.latitude : null;
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_addresses,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        // ],
      ),
   resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
              
              bottom: bottom),
            child: Stack(
                // fit: StackFit.expand,
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Container(
          child:
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.map,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).delivery_addresses,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    'Para que el sistema pueda capturar su posición, presione el botón "Buscar su dirección en el Mapa"',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              //  Text( 'Dir: ${_con.direccion?.address}'   ),
              //  Text( 'Desc: ${_con.direccion?.description}'   ),
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                       new TextButton(
                        onPressed: () async {
                          LocationResult result = await showLocationPicker(
                            context,
                            setting.value.googleMapsKey,
                            initialCenter: LatLng(_con.direccion?.latitude ?? -16.496258361010756, _con.direccion?.longitude ?? -68.13366806799023),
                            automaticallyAnimateToCurrentLocation: true,
                            //mapStylePath: 'assets/mapStyle.json',
                            myLocationButtonEnabled: true,
                            //resultCardAlignment: Alignment.bottomCenter,
                          );
                          if(_con.direccion == null){
                            _con.addAddress(new Address.fromJSON({
                              'address': result.address,
                              'latitude': result.latLng.latitude,
                              'longitude': result.latLng.longitude,
                            }));
                          }else{
                          //  print("Editar");
                            }
                
                          _con.direccion.address=result.address;
                          _con.direccion.latitude=result.latLng.latitude;
                          _con.direccion.longitude=result.latLng.longitude;
                          //onChanged(address);
                          // _con.addAddress(new Address.fromJSON({
                          //   'address': result.address,
                          //   'latitude': result.latLng.latitude,
                          //   'longitude': result.latLng.longitude,
                          // }));
                          print("result = $result");
                          print("address = ${_con.direccion.address}");
                          setState(() {
                            _con.direccion;
                            txt.text=_con.direccion.address;
                          });
                        },
                        style: TextButton.styleFrom(
                           primary: Theme.of(context).colorScheme.secondary,
                             padding: EdgeInsets.all(10.0),
                               shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25),
                          ),
                        ),
                       
                  
                      
                        child: Row( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            //Icon(Icons.map),
                            Icon(Icons.gps_fixed, color: Theme.of(context).primaryColor),
                            Text("  Buscar su dirección en el Mapa" , style: TextStyle(color: Theme.of(context).primaryColor,),)
                          ],
                        ),
                              
                      ),
                    ),
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        controller: txt,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText: S.of(context).hint_full_address, labelText: S.of(context).full_address),
                        validator: (input) => input.trim().length == 0 ? 'No es una diracción válida' : null,
                        onSaved: (input) => _con.direccion.address = input,
                        onChanged: (input) =>_con.direccion.address = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        controller: txt2,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText:"Timbre 3", labelText: "Referencia"),
                        // validator: (input) => input.trim().length == 0 ? 'No es una referencia válida' : null,
                        validator:  null,
                        onSaved: (input) => _con.direccion.description = input,
                        onChanged: (input) =>_con.direccion.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        title: Text(
                          'Datos de Facturación',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          'estos datos seran usados para que el negocio le emita una factura con cada compra',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        controller: txt3,
                        // initialValue: nitNameTxt,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText:"Juan Perez", labelText: "Nombre para Factura"),
                        validator: (input) => _validateNombre && input.trim().length < 2 ? 'No es un nombre válido' : null,
                        onSaved: (input) => _con.direccion.nit_name = input,
                        onChanged: (input) =>_con.direccion.nit_name = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        controller: txt4,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText:"NIT ó CI", labelText: "NIT para Factura"),
                        validator: (input) => _validateNombre && input.trim().length < 7 ? 'No es un NIT válido' : null,
                        onSaved: (input) => _con.direccion.nit = input,
                        onChanged: (input) =>_con.direccion.nit = input,
                      ),
                    ),
                    
                  ],
                ),
              ),
              Container(
                height: (config.App(context).appHeight(1)*100)-500,
              ),
            ],
          ),
        ),
        latTxt != null // Valida que tenga LATITUD
          ? Positioned(
            bottom: 0,
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              txt3.text.isEmpty && txt4.text.isEmpty ? _validateNombre = false : _validateNombre = true;
                            });
                            _submit();
                          },
                         style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                          primary: 
                          Theme.of(context).colorScheme.secondary,
                          shape: StadiumBorder(),
                         ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Aceptar",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ]))
            )    
          )
          :SizedBox(height: 0),
        ]
      ),
      )
      )
    );
  }
  
  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }
    void _submit() {
      print('devolviendo submit ');
  //                           setState(() {
  //   _con.direccion.address='aaaa';
    
  // });
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      //onChanged(_con.direccion);
      //onChanged(address);
      print('direccion_id 2 => ${_con.direccion.id}');
      if(_con.direccion.id == "null"){
        _con.addAddress(_con.direccion);
      }else{
        _con.updateAddress(_con.direccion);
      }
      
      //Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      if(widget.compra){
        Navigator.of(context).pushNamed('/DeliveryPickup');
      }else{
        Navigator.pop(context);
      }
    }
  }
}

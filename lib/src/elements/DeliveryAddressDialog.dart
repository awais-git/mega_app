import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../helpers/checkbox_form_field.dart';
import '../models/address.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  String _direccion = '';

  DeliveryAddressDialog({this.context, this.address, this.onChanged}) {
    _direccion = address.address?.isNotEmpty ?? false ? address.address : null;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).home_address,
                            labelText: S.of(context).description),
                        initialValue: address.description?.isNotEmpty ?? false
                            ? address.description
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid address description'
                            : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).hint_full_address,
                            labelText: S.of(context).full_address),
                        initialValue: _direccion,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid address'
                            : null,
                        onSaved: (input) => address.address = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: new TextButton(
                        onPressed: () async {
                          // LocationResult result = await showLocationPicker(
                          //   context,
                          //   setting.value.googleMapsKey,
                          //   initialCenter: LatLng(address.latitude ?? -16.496258361010756, address.longitude ?? -68.13366806799023),
                          //   automaticallyAnimateToCurrentLocation: true,
                          //   //mapStylePath: 'assets/mapStyle.json',
                          //   myLocationButtonEnabled: true,
                          //   //resultCardAlignment: Alignment.bottomCenter,
                          // );
                          // _direccion=result.address;
                          // address.address=result.address;
                          // address.latitude=result.latLng.latitude;
                          // address.longitude=result.latLng.longitude;
                          // //onChanged(address);
                          // // _con.addAddress(new Address.fromJSON({
                          // //   'address': result.address,
                          // //   'latitude': result.latLng.latitude,
                          // //   'longitude': result.latLng.longitude,
                          // // }));
                          // print("result = $result");
                          // print("address = ${address.address}");
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.orange,
                        ),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[Icon(Icons.map), Text("Mapa")],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault ?? false,
                        onSaved: (input) => address.isDefault = input,
                        title: Text('Make it default'),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      // S.of(context).cancel,
                      "Cancelar",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      // S.of(context).save,
                      "Aceptar",
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}

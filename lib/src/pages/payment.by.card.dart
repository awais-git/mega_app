import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../helpers/input.formatter.dart';
import '../helpers/my_strings.dart';
import '../helpers/payment.type.dart';
import '../helpers/store.data.dart';
import '../models/payment.model.dart';
import '../models/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CardPayment extends StatefulWidget {
  final storage = SecureStorage();
  PaymentMethod paymentMethod;

  CardPayment({Key key, this.paymentMethod}) : super(key: key);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends StateMVC<CardPayment> {
  final storage = SecureStorage();
  bool loading = false;
  CheckoutController _con;

  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  final TextEditingController personName = TextEditingController();
  final TextEditingController cvv = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();

  var _card = new PaymentCard();
  //  List<int> expiryDate = [];
  _CardPaymentState() : super(CheckoutController()) {
    _con = controller;
  }

  var _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _con.listenForCarts();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    cvv.dispose();
    expiryDate.dispose();
    personName.dispose();
    super.dispose();
  }

  Future payment() async {
    final apiUrl =
        'http://cybersource.test.megadelivery.online/cybersource-rest-samples-php/Samples/Authentication/StandAloneHttpSignature.php';

    try {
      final orderid = await storage.readOrderId('order_id');

      log('This is my next line reading $orderid');
      setState(() {
        loading = true;
      });
      var url = Uri.parse(apiUrl);
      var response = await http.post(url, body: {
        'orderId': orderid,
        'card_no': numberController.text,
        'cvc': cvv.text,
        'card_type': numberController.text.startsWith(RegExp(
                r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))
            ? '002'
            : '001',
        'amount': _con.total.toString(),
        'expirationMonth': expiryDate.text.substring(0, 2),
        'expirationYear': expiryDate.text.substring(3, 5),
      });
      // print('data sent successfully');
      // print('All the data going is : ${response.body}');
      // print(numberController.text);
      // print(cvv.text);
      // print(personName.text);
      // print('The month is : ${expiryDate.text.substring(0, 2)}');
      // print('The year is ${expiryDate.text.substring(3, 5)}');
      // print(_con.total.toString());

      Paymentmodel model = paymentmodelFromJson(response.body);
      if (response.statusCode == 200 && model.status == 'AUTHORIZED') {
        log('I am good ');
        log(response.body);
        Navigator.of(context).pushReplacementNamed('/CashOnDelivery');
      }
      return response.body;
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).paymentUnsuccessful),
              content: Text(S.of(context).paymentDetailsCheck),
            );
          });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
    } else {
      form.save();
      var type = numberController.text.startsWith(RegExp(
              r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))
          ? '002'
          : '001';
      // await _con.listenForCarts();
      await storage.writeOrderId(numberController.text, 'number');
      await storage.writeOrderId(cvv.text, 'cvv');
      await storage.writeOrderId(_con.total.toString(), 'total_amount');
      await storage.writeOrderId(expiryDate.text.substring(0, 2), 'expmonth');
      await storage.writeOrderId(expiryDate.text.substring(3, 5), 'expyear');
      await storage.writeOrderId(type, 'type');

      Navigator.of(context).pushReplacementNamed('/CashOnDelivery');

      // await payment();

      // Encrypt and send send payment details to payment gateway

    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
        child: Text(
          S.of(context).pay,
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return SizedBox(
        width: 200,
        height: 50,
        child: new ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary),
          onPressed: _validateInputs,
          child: new Text(
            S.of(context).pay.toUpperCase(),
            style: const TextStyle(fontSize: 17.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: personName,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        icon: Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.grey[600],
                        ),
                        // hintText: 'What name is written on card?',
                        labelText: S.of(context).cardname,
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                    onSaved: (String value) {
                      _card.name = value;
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? Strings.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      new CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),

                      filled: true,
                      icon: CardUtils.getCardIcon(_paymentCard.type),
                      // hintText: 'What number is written on card?',
                      labelText: S.of(context).number,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    controller: cvv,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: new InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      filled: true,
                      icon: new Image.asset(
                        'assets/img/card_cvv.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      // hintText: 'Number behind the card',
                      labelText: 'CVV',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _paymentCard.cvv = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: expiryDate,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter()
                    ],
                    decoration: new InputDecoration(
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      filled: true,
                      icon: new Image.asset(
                        'assets/img/calender.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'MM/YY',
                      labelText: S.of(context).expiry_date,
                    ),
                    validator: CardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: _getPayButton(),
                        )
                ],
              )),
        ),
      ),
    );
  }
}

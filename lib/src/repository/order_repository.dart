import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../helpers/store.data.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;productOrders;productOrders.product;productOrders.options;orderStatus;payment;market&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
  print(CustomTrace(StackTrace.current, message: 'getOrders: ' + url.toString())
      .toString());
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Order.fromJSON({}));
  }
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;deliveryAddress;payment';
  print(CustomTrace(StackTrace.current, message: url.toString()).toString());
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });

  // await storage.writeSecureToken(streamedRest['order_id']);
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(
    Order order, Payment payment, BuildContext context) async {
  var orderid;
  final storage = SecureStorage();
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Order();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?$_apiToken';
  print('ATENCION------>');
  print(url);
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  print(params);
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  print('RESPUESTA----->');
  print(response.body);
  var data = json.decode(response.body);
  await storage.writeOrderId(data['data']['id'].toString(), 'order_id');
  log("This is my saved thing  ${data['data']['id'].toString()}");
  orderid = data['data']['id'].toString();
  // String readValue = await storage.readOrderId();

  // log('This is my reading ${readValue.toString()}');

  //  log(data.toString());

  // log("This is the log i am printing ${(data['data']['product_orders']['order_id']).toString()}");
  final data1 = await storage.readCash('cash');

  if (data1 == 'credit') {
    await paymentFunc(orderid, context);
  } else {}

  return Order.fromJSON(json.decode(response.body));
}

Future<Order> cancelOrder(Order order) async {
  print(order.toMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.cancelMap()),
  );
  if (response.statusCode == 200) {
    return Order.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}

Future paymentFunc(String orderId, BuildContext context) async {
  CheckoutController _con;

  final storage = SecureStorage();
  final apiUrl =
      'http://cybersource.test.megadelivery.online/cybersource-rest-samples-php/Samples/Authentication/StandAloneHttpSignature.php';

  try {
    // log('This is ${await storage.readOrderId('total_amount')}');
    var url = Uri.parse(apiUrl);
    var response = await http.post(url, body: {
      'orderId': orderId,
      'card_no': await storage.readOrderId('number'),
      'cvc': await storage.readOrderId('cvv'),
      'card_type': await storage.readOrderId('type'),
      'amount': await storage.readOrderId('total_amount'),
      'expirationMonth': await storage.readOrderId('expmonth'),
      'expirationYear': await storage.readOrderId('expyear'),
    });

    log(response.toString());
    // print('data sent successfully');
    // print('All the data going is : ${response.body}');
    // print(numberController.text);
    // print(cvv.text);
    // print(personName.text);
    // print('The month is : ${expiryDate.text.substring(0, 2)}');
    // print('The year is ${expiryDate.text.substring(3, 5)}');
    // print(_con.total.toString());

    // Paymentmodel model = paymentmodelFromJson(response.body);
    // if (response.statusCode == 200 && model.status == 'AUTHORIZED') {
    //   log('I am good ');
    //   log(response.body);
    //   // Navigator.of(context).pushReplacementNamed('/CashOnDelivery');
    // }
    return response.body;
  } catch (e) {
    print(e);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).paymentUnsuccessful),
            content: Text(S.of(context).paymentDetailsCheck),
          );
        });
  }
}

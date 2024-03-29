import '../helpers/store.data.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/checkout_controller.dart';
import '../models/payment_method.dart';
import 'package:flutter/material.dart';

import '../pages/payment.by.card.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatefulWidget {
  PaymentMethod paymentMethod;

  PaymentMethodListItemWidget({Key key, this.paymentMethod}) : super(key: key);

  @override
  _PaymentMethodListItemWidgetState createState() =>
      _PaymentMethodListItemWidgetState();
}

class _PaymentMethodListItemWidgetState
    extends StateMVC<PaymentMethodListItemWidget> {
  //  List<int> expiryDate = [];
  _PaymentMethodListItemWidgetState() : super(CheckoutController()) {}

  SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () async {
              print(this.widget.paymentMethod.name);

              await storage.cash('cash', 'cash');

              Navigator.of(context).pushNamed(this.widget.paymentMethod.route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                          image: AssetImage(widget.paymentMethod.logo),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.paymentMethod.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                widget.paymentMethod.description,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).focusColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //By card
          InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () async {
              await storage.cash("credit", 'cash');
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CardPayment()));
              // print(this.widget.paymentMethod.name);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                          image: AssetImage(widget.paymentMethod.logo),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Tarjeta de crédito',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Haga click para pagar con tarjeta',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).focusColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

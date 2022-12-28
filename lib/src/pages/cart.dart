import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/DrawerWidget.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
        bottomNavigationBar:CartBottomDetailsWidget(con: _con),
//         bottomNavigationBar: Column(
//                 // crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[CartBottomDetailsWidget(con: _con)],
// ),
        
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          // leading: IconButton(
          //   onPressed: () {
          //     if (widget.routeArgument.param == '/Product') {
          //       Navigator.of(context).pushReplacementNamed('/Product', arguments: RouteArgument(id: widget.routeArgument.id));
          //     } else {
          //       Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          //     }
          //   },
          //   icon: Icon(Icons.arrow_back),
          //   color: Theme.of(context).hintColor,
          // ),
          backgroundColor: Colors.transparent,
          
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
         
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Container(                
                    child: ListView(
                      // shrinkWrap: true,
                      // padding: EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).shopping_cart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S.of(context).verify_your_quantity_and_click_checkout,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.carts.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cart: _con.carts.elementAt(index),
                              heroTag: 'cart',
                              increment: () {
                                _con.incrementQuantity(_con.carts.elementAt(index));
                              },
                              decrement: () {
                                _con.decrementQuantity(_con.carts.elementAt(index));
                              },
                              onDismissed: () {
                                _con.removeFromCart(_con.carts.elementAt(index ));
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              "Información adicional del pedido",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: new TextFormField(
                            maxLines: 2,
                            // keyboardType: TextInputType.multiline,
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(hintText:"Información Adicional", labelText: "Información Adicional"),
                            style: TextStyle(color: Theme.of(context).hintColor),
                            // initialValue: _con.getOrderInfo().toString(),
                             initialValue: _con.adicional,
                            onChanged: (input) =>_con.changeOrderInfo(input),
                          ),
                        ),
                      ],
                    ),
                  
                  ),
          ),
        )
      ),
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
}
 

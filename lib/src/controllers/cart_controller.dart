import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class CartController extends ControllerMVC {

  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;
  String adicional='';

  CartController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    //=await settingRepo.getOrderInformation();
    
  }

  void listenForCarts({String message }) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
      getOrderInfo();
    });
  }

  void onLoadingCartDone() {}

  void changeOrderInfo(String texto) async {
    await settingRepo.setOrderInformation(texto);
  }
  getOrderInfo() async {
    String nuevo=await settingRepo.getOrderInformation();
    print("NUEVO********"+nuevo);
    adicional= nuevo;
     return nuevo;
  }
  void listenForCartsCount({String message }) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(
      
      message:
    
      
      S.of(context).carts_refreshed_successfuly
      );
  }

  void removeFromCart(Cart _cart ) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).the_product_was_removed_from_your_cart(_cart.product.name)),
      ));
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      var subTotalTmp= cart.product.price;
      cart.options.forEach((element) {
        subTotalTmp += element.price;
      });
      subTotal += subTotalTmp*cart.quantity;
    });
    if (Helper.canDelivery(carts[0].product.market, carts: carts)) {
      deliveryFee = await Helper.getTotalEnvio(carts[0].product.market);
    }
    taxAmount = (subTotal + deliveryFee) * carts[0].product.market.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout() {
    if (!currentUser.value.profileCompleted()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].product.market.closed) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).this_market_is_closed_),
        ));
      } else {
        var puedoEnviar=Helper.canDelivery(carts[0].product.market, carts: carts);
        if (puedoEnviar) {
          print("psamos enviar");
          Navigator.of(context).pushNamed('/DeliveryPickup');
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Esta fuera del Rango de entrega que es de: ' + (carts[0].product.market.deliveryRange).toString() +' Km desde el Negocio'),
          ));
        }
      }
    }
  }

 getTotal (){
  return this.total;
}
}

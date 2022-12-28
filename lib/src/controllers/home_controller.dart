import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// import '../helpers/helper.dart';
import '../helpers/helper.dart';
import '../models/banner.dart' as bannerModel;
import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/banner_repository.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/settings_repository.dart';

class HomeController extends ControllerMVC {
  List<bannerModel.Banner> banners = <bannerModel.Banner>[];
  List<Category> categories = <Category>[];
  List<Market> topMarkets = <Market>[];
  List<Market> popularMarkets = <Market>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];

  HomeController() {
    listenForTopMarkets();
    listenForTrendingProducts();
    listenForBanners();
    listenForCategories();
    listenForPopularMarkets();
    listenForRecentReviews();
  }

  Future<void> listenForBanners() async {
    final Stream<bannerModel.Banner> stream = await getNearBanners(settingsRepo.deliveryAddress.value, settingsRepo.deliveryAddress.value);
    stream.listen((bannerModel.Banner _banner) {
      setState(() => banners.add(_banner));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopMarkets() async {
    final Stream<Market> stream = await getNearMarkets(settingsRepo.deliveryAddress.value, settingsRepo.deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => topMarkets.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularMarkets() async {
    final Stream<Market> stream = await getPopularMarkets(settingsRepo.deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => popularMarkets.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingProducts() async {
    final Stream<Product> stream = await getTrendingProducts(settingsRepo.deliveryAddress.value);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void requestForCurrentLocation() {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      categories = <Category>[];
      topMarkets = <Market>[];
      // popularMarkets = <Market>[];
      // recentReviews = <Review>[];
      // trendingProducts = <Product>[];
    });
    await listenForTopMarkets();
    // await listenForTrendingProducts();
    await listenForBanners();
    await listenForCategories();
    // await listenForPopularMarkets();
    // await listenForRecentReviews();
  }
}

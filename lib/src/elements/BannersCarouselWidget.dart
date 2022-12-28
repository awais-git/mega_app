import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// import '../elements/BannerCarouselItemWidget.dart';
import '../models/banner.dart' as bannerModel;
// ignore: unused_element
int _current = 0;

class BannersCarouselWidget extends StatelessWidget {
  final List<bannerModel.Banner> banners;
  final String heroTag;
  

  BannersCarouselWidget({Key key, this.banners, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = this.banners.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Stack(
        children: <Widget>[
          Image.network(item.image.url, fit: BoxFit.cover, width: 1000.0),
        ],
      )
    ),
  ),
)).toList();
    return banners.isEmpty
        ? SizedBox(height: 0)
        : Column(
          children: [CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.4,
              // height: 230.0,
              onPageChanged: (index, reason) {
                // setState(() {
                  _current = index;
                // });
              }
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: this.banners.map((url) {
          //     int index = this.banners.indexOf(url);
          //     return Container(
          //       width: 8.0,
          //       height: 8.0,
          //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: _current == index
          //           ? Color.fromRGBO(0, 0, 0, 0.9)
          //           : Color.fromRGBO(0, 0, 0, 0.4),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ]
      )
        ;
  }
}

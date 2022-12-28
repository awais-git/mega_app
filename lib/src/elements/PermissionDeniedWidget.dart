import 'package:flutter/material.dart';

// import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class PermissionDeniedWidget extends StatefulWidget {
  PermissionDeniedWidget({
    Key key,
  }) : super(key: key);

  @override
  _PermissionDeniedWidgetState createState() => _PermissionDeniedWidgetState();
}

class _PermissionDeniedWidgetState extends State<PermissionDeniedWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: config.App(context).appHeight(70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(context).focusColor.withOpacity(0.7),
                          Theme.of(context).focusColor.withOpacity(0.05),
                        ])),
                child: Icon(
                  Icons.https,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 70,
                ),
              ),
              Positioned(
                right: -30,
                bottom: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: 0.4,
            child: Text(
              "Debe registrar dirección de entrega para poder continuar navegando",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .merge(TextStyle(fontWeight: FontWeight.w300)),
            ),
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/DeliveryAddress');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
              primary: Theme.of(context).colorScheme.secondary.withOpacity(1),
              shape: StadiumBorder(),
            ),
            child: Text(
              "Registrar dirección",
              style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
            ),
          ),
        ],
      ),
    );
  }
}

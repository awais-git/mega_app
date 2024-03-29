// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  String _projectVersion = '';
  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  void initState() {
    _initPlatformState();
    super.initState();
  }
  void _initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    // ignore: missing_required_param
    return WillPopScope(
      // onWillPop: Helper.of(context).onWillPop,
      // onWillPop: () { return null ;},
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: false,
       
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(
                  height: config.App(context).appHeight(1)*100,
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: config.App(context).appWidth(100),
                    height: config.App(context).appHeight(29.5),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Positioned(
                  top: config.App(context).appHeight(29.5) - 120,
                  child: Container(
                    width: config.App(context).appWidth(84),
                    height: config.App(context).appHeight(29.5),
                    child: Text(
                      S.of(context).lets_start_with_register,
                      style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                Positioned(
                  top: config.App(context).appHeight(29.5) - 50,
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                    width: config.App(context).appWidth(88),
    //              height: config.App(context).appHeight(55),
                    child: Form(
                      key: _con.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.user.name = input,
                            validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).full_name,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.all(12),
                              hintText: S.of(context).john_doe,
                              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.user.phone = input,
                            validator: (input) => (input.trim().length < 8 || input.trim().length > 8) ?S.of(context).not_a_valid_phone: null,
                            decoration: InputDecoration(
                              labelText: S.of(context).phone,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '76123456',
                              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.phone_android, color: Theme.of(context).colorScheme.secondary),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => _con.user.email = input,
                            validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).email,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'johndoe@gmail.com',
                              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).colorScheme.secondary),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            obscureText: _con.hidePassword,
                            onSaved: (input) => _con.user.password = input,
                            validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).password,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _con.hidePassword = !_con.hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 15),
                          BlockButtonWidget(
                            text: Text(
                              S.of(context).register,
                              style: TextStyle(color:
                              
                               Theme.of(context).primaryColor
                               ),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              _con.register();
                            },
                          ),
                          SizedBox(height: 10),
                          Center(child:Text(" Version: "+_projectVersion))
                          // SizedBox(height: 20),
    //                      FlatButton(
    //                        onPressed: () {
    //                          Navigator.of(context).pushNamed('/MobileVerification');
    //                        },
    //                        padding: EdgeInsets.symmetric(vertical: 14),
    //                        color: Theme.of(context).accentColor.withOpacity(0.1),
    //                        shape: StadiumBorder(),
    //                        child: Text(
    //                          'Register with Google',
    //                          textAlign: TextAlign.start,
    //                          style: TextStyle(
    //                            color: Theme.of(context).accentColor,
    //                          ),
    //                        ),
    //                      ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Login');
                    },
                
                    child: Text(S.of(context).i_have_account_back_to_login ,style: TextStyle(color :  Theme.of(context).hintColor,),),
                  ),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'complete_register_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _registerScaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _phoneController;

  TextEditingController _countryController;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _countryController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _registerScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("sign"),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () async {
                  String lang = await Preference.getLanguage();
                  if (lang == 'ar') {
                    setState(() {
                      setLang('en');
                      Phoenix.rebirth(context);
                    });
                  } else {
                    setState(() {
                      setLang('ar');
                      Phoenix.rebirth(context);
                    });
                  }
                },
                child: Center(
                  child: Text(
                    AppLocale.of(context).getTranslated('lang'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _drawPhoneEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    _drawChooseCountry(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
                    ),
                    _drawSignUpButton(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    _drawLoginButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawPhoneEditText() {
    return TextFormField(
      controller: _phoneController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_android),
        hintText: AppLocale.of(context).getTranslated('phone'),
      ),
    );
  }

  Widget _drawChooseCountry() {
    return TextFormField(
      controller: _countryController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.language),
        hintText: AppLocale.of(context).getTranslated('country'),
      ),
    );
  }

  Widget _drawSignUpButton() {
    return FlatButton(
      height: MediaQuery.of(context).size.height * .06,
      onPressed: () {
        if (_phoneController.text.isNotEmpty &&
            _countryController.text.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CompleteRegisterScreen(
                  _countryController.text, _phoneController.text)));
        } else {
          final snackBar = SnackBar(
              backgroundColor: CustomColors.ratingLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == 'En'
                    ? "برجاء التاكد من ادخال رقم الهاتف و ادخال البلد التابع لها"
                    : "Please make sure to enter the phone number and enter the country to which it belongs.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.ratingLightFont),
              ));

          _registerScaffoldKey.currentState.showSnackBar(snackBar);
        }
      },
      child: Text(
        AppLocale.of(context).getTranslated("gone"),
        style: TextStyle(
          color: CustomColors.primary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          color: CustomColors.primary,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      minWidth: MediaQuery.of(context).size.width,
    );
  }

  Widget _drawLoginButton() {
    return FlatButton(
      height: MediaQuery.of(context).size.height * .06,
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Text(
        AppLocale.of(context).getTranslated("log_que"),
        style: TextStyle(
          color: Color(0xff1ee3cf),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          color: Color(0xff1ee3cf),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      minWidth: MediaQuery.of(context).size.width,
    );
  }
}

Future setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}

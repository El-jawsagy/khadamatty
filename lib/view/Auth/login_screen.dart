import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:khadamatty/controller/Authentication_api.dart';
import 'package:khadamatty/controller/contriesApi.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

import '../main_screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Authentication authentication;

  CountriesAPI countriesAPI;
  final GlobalKey<ScaffoldState> _loginScaffoldKey =
      new GlobalKey<ScaffoldState>();

  IconData _icon = Icons.visibility_off;

  bool _isVisible = true;

  bool _isHash = true;

  @override
  void initState() {
    authentication = Authentication();
    countriesAPI = CountriesAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("log"),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
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
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _drawNameEditText(),
                    _drawPasswordEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    _drawLoginButton(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    // _drawForgetPass(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.48,
                    ),
                    _drawSignUpButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawNameEditText() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return TextFormField(
      controller: _nameController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        } else {
          if (!(regex.hasMatch(val))) {
            return "Invalid Email";
          }
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('email'),
      ),
    );
  }

  Widget _drawPasswordEditText() {
    return Container(
      child: TextFormField(
        obscureText: _isHash,
        controller: _passController,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated('pass'),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          fillColor: CustomColors.dark,
          suffixIcon: IconButton(
            onPressed: () {
              if (_isVisible) {
                setState(() {
                  _icon = Icons.visibility;
                  _isHash = false;
                  _isVisible = false;
                  this._nameController.text = _nameController.text;
                  this._passController.text = _passController.text;
                });
              } else if (!_isVisible) {
                setState(() {
                  _icon = Icons.visibility_off;
                  _isHash = true;
                  _isVisible = true;
                  this._nameController.text = _nameController.text;
                  this._passController.text = _passController.text;
                });
              }
            },
            icon: Icon(
              _icon,
              color: CustomColors.dark,
            ),
          ),
        ),
        validator: (val) {
          if (val.isEmpty) {
            return AppLocale.of(context).getTranslated('pass_empty');
          }
          return null;
        },
      ),
    );
  }

  Widget _drawLoginButton() {
    ValueNotifier<bool> state = ValueNotifier(false);

    return ValueListenableBuilder(
      valueListenable: state,
      builder: (BuildContext context, value, Widget child) {
        return Container(
          child: state.value
              ? Container(
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: CustomColors.primary)),
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: CustomColors.primaryHover,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomColors.primary),
                      ),
                    ),
                  ),
                )
              : FlatButton(
                  height: MediaQuery.of(context).size.height * .06,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      state.value = true;
                      final snackBar = SnackBar(
                        backgroundColor: CustomColors.primaryHover,
                        content: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? "يتم التواصل مع السيرفر الان. برجاء الانتظار.."
                              : "We are communicating with the server now. Please wait ...",
                          style: TextStyle(color: CustomColors.primary),
                        ),
                        duration: Duration(seconds: 1, milliseconds: 500),
                      );
                      _loginScaffoldKey.currentState.showSnackBar(snackBar);

                      authentication
                          .login(_nameController.text, _passController.text)
                          .then((value) async {
                        state.value = false;

                        print("this is value of login $value");
                        switch (value) {
                          case "email wrong":
                            showDialogWidget("make sure of email ", context);
                            break;

                          case "password wrong":
                            showDialogWidget("make sure of password ", context);
                            break;

                          default:
                            if (value.length > 100) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen(0)));
                            } else
                              showDialogWidget("we have an error", context);
                            break;
                        }
                      });
                    }
                  },
                  child: Text(
                    AppLocale.of(context).getTranslated("log"),
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
                ),
        );
      },
    );
  }

  Widget _drawForgetPass() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => ForgetPassword(widget.lang)));
            },
            child: Text(
              AppLocale.of(context).getTranslated("forget"),
              style: TextStyle(
                color: CustomColors.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawSignUpButton() {
    return FlatButton(
      height: MediaQuery.of(context).size.height * .06,
      onPressed: () async {
        final snackBar = SnackBar(
            backgroundColor: CustomColors.primaryHover,
            content: Text(
              AppLocale.of(context).getTranslated("lang") == 'En'
                  ? "يتم تحميل البلاد المتاحة برجاء الانتظار.."
                  : "available countries are loaded, please wait ...",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: CustomColors.primary),
            ));

        _loginScaffoldKey.currentState.showSnackBar(snackBar);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Text(
        AppLocale.of(context).getTranslated("sign"),
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

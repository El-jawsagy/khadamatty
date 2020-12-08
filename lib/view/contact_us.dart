import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:khadamatty/controller/about_contact_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

import 'main_screens/main_screen.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;

  TextEditingController _phoneController;

  TextEditingController _massageController;

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _completeDataScaffoldKey =
      new GlobalKey<ScaffoldState>();
  AboutAndTermsOfUseAPI aboutAndTermsOfUseAPI;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _massageController = TextEditingController();
    aboutAndTermsOfUseAPI = AboutAndTermsOfUseAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _completeDataScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocale.of(context).getTranslated("app_name"),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textWidthBasis: TextWidthBasis.parent,
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainScreen(0)));
          },
        ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawNameEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawEmailEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawPhoneEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawMassageEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    _drawSendDataButton(),

                    // _drawForgetPass(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
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
    return TextFormField(
      controller: _nameController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('name'),
      ),
    );
  }

  Widget _drawEmailEditText() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return TextFormField(
      controller: _emailController,
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
        labelText: AppLocale.of(context).getTranslated('phone'),
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
      ),
    );
  }

//todo:now you try to make button in register give info for user and make pass and conf pass readable
  Widget _drawMassageEditText() {
    return TextFormField(
      controller: _massageController,
      maxLines: 10,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('massage'),
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
      ),
    );
  }

  Widget _drawSendDataButton() {
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
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "يتم الان رفع البيانات برجاء الانتظار.."
                                : "The data is being uploaded, please wait..",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary),
                          ));

                      _completeDataScaffoldKey.currentState
                          .showSnackBar(snackBar);
                      aboutAndTermsOfUseAPI
                          .sendContactUs(
                        _nameController.text,
                        _phoneController.text,
                        _emailController.text,
                        _massageController.text,
                      )
                          .then((value) async {
                        state.value = false;

                        if (value == "true") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen(0)));
                        } else {
                          showDialogWidget("we have an error", context);
                        }
                      });
                    }
                  },
                  child: Text(
                    AppLocale.of(context).getTranslated("send"),
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
}

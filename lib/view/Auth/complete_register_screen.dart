import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadamatty/controller/Authentication_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

import '../main_screens/main_screen.dart';

ValueNotifier<File> _image = ValueNotifier(null);
final picker = ImagePicker();

class CompleteRegisterScreen extends StatefulWidget {
  String country;
  String phone;

  CompleteRegisterScreen(this.country, this.phone);

  @override
  _CompleteRegisterScreenState createState() => _CompleteRegisterScreenState();
}

class _CompleteRegisterScreenState extends State<CompleteRegisterScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;

  TextEditingController _passController;

  TextEditingController _conformPassController;

  final _formKey = GlobalKey<FormState>();
  Authentication authentication;

  final GlobalKey<ScaffoldState> _completeDataScaffoldKey =
      new GlobalKey<ScaffoldState>();
  IconData _icon = Icons.visibility_off;

  bool _isVisible = true;

  bool _isHash = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _conformPassController = TextEditingController();
    authentication = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _completeDataScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("sign"),
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
                    PersonImageTaker(_image),
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
                    _drawPassEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawConformPassEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    _drawSignUpButton(),

                    // _drawForgetPass(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    _drawLoginButton(),
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
      keyboardType: TextInputType.emailAddress,
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

  Widget _drawPassEditText() {
    return TextFormField(
      controller: _passController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      obscureText: _isHash,
      keyboardType: TextInputType.emailAddress,
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
        suffixIcon: IconButton(
          onPressed: () {
            if (_isVisible) {
              setState(() {
                _icon = Icons.visibility;
                _isHash = false;
                _isVisible = false;
                this._nameController.text = _nameController.text;
                this._passController.text = _passController.text;
                this._emailController.text = _emailController.text;
                this._conformPassController.text = _conformPassController.text;
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
    );
  }

//todo:now you try to make button in register give info for user and make pass and conf pass readable
  Widget _drawConformPassEditText() {
    return TextFormField(
      obscureText: _isHash,
      controller: _conformPassController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        } else if (val != _passController.text) {
          return AppLocale.of(context).getTranslated('conf_pass_wrong');
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('con_pass'),
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
        suffixIcon: IconButton(
          onPressed: () {
            if (_isVisible) {
              setState(() {
                _icon = Icons.visibility;
                _isHash = false;
                _isVisible = false;
                this._nameController.text = _nameController.text;
                this._passController.text = _passController.text;
                this._emailController.text = _emailController.text;
                this._conformPassController.text = _conformPassController.text;
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
    );
  }

  Widget _drawSignUpButton() {
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
                          duration: Duration(seconds: 1, milliseconds: 500),
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
                      authentication
                          .signUp(
                              widget.country,
                              _nameController.text,
                              widget.phone,
                              _emailController.text,
                              _passController.text,
                              _image.value)
                          .then((value) async {
                        state.value = false;

                        print("this is value of login $value");
                        switch (value) {
                          case "name exist":
                            showDialogWidget(
                                "this name is already used", context);
                            break;

                          case "email exist":
                            showDialogWidget(
                                "this email is already used", context);
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
                    AppLocale.of(context).getTranslated("sign"),
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

class PersonImageTaker extends StatefulWidget {
  ValueNotifier<File> image;

  PersonImageTaker(this.image);

  @override
  _PersonImageTakerState createState() => _PersonImageTakerState();
}

class _PersonImageTakerState extends State<PersonImageTaker> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.image,
      builder: (BuildContext context, File value, Widget child) {
        return widget.image.value == null
            ? InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 0.5, color: CustomColors.white),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .2,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Center(
                            child: ClipRect(
                              child: Image.asset(
                                'assets/images/person.png',
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.45,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                              gradient: LinearGradient(colors: [
                                CustomColors.gray,
                                CustomColors.gray
                              ]),
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: 36,
                            ))),
                      ],
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border:
                            Border.all(width: 0.5, color: CustomColors.white),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                            ),
                            child: Center(
                              child: ClipRect(
                                  child: Image.file(
                                widget.image.value,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ],
                      )),
                ),
              );
      },
    );
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.image.value = File(pickedFile.path);
    } else {
      widget.image.value = null;
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadamatty/controller/Authentication_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/complete_register_screen.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<File> _image = ValueNotifier(null);

class EditProfileScreen extends StatefulWidget {
  Map userData;
  String lang;

  EditProfileScreen(this.userData, this.lang);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _phoneController;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _oldPassController;
  TextEditingController _newPassController;
  TextEditingController _countryController;

  Authentication authentication;
  final _editProfileFormKey = GlobalKey<FormState>();

  List allCountries = [];
  List<String> editCategories;
  final GlobalKey<ScaffoldState> _editProfileScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    authentication = Authentication();

    _phoneController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _countryController = TextEditingController();
    _phoneController.text =
        widget.userData["phone"] == null ? "" : widget.userData["phone"];
    _nameController.text =
        widget.userData["username"] == null ? "" : widget.userData["username"];
    _emailController.text =
        widget.userData["email"] == null ? "" : widget.userData["email"];
    _countryController.text =
        widget.userData["country"] == null ? "" : widget.userData["country"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _editProfileScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("drawer_Set"),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _editProfileFormKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    FeatureImageTaker(_image,
                        networkImage: widget.userData["image"]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    _drawChooseCountry(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    _drawPhoneEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawNameEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawEmailEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawOldPassEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawNewPassEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    _drawUpdateButton(),
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
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
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
        labelText: AppLocale.of(context).getTranslated('country'),
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

  Widget _drawOldPassEditText() {
    return TextField(
      controller: _oldPassController,
      // validator: (val) {
      //   if (val.isEmpty) {
      //     return AppLocale.of(context).getTranslated('pass_empty');
      //   }
      //   return null;
      // },
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('old_pass'),
      ),
    );
  }

  Widget _drawNewPassEditText() {
    return TextField(
      controller: _newPassController,
      // validator: (val) {
      //   if (val.isEmpty) {
      //     return AppLocale.of(context).getTranslated('pass_empty');
      //   }
      //   return null;
      // },
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('new_pass'),
      ),
    );
  }

  Widget _drawUpdateButton() {
    ValueNotifier<bool> state = ValueNotifier(false);

    return ValueListenableBuilder(
      valueListenable: state,
      builder: (BuildContext context, bool value, Widget child) {
        return Container(
          width: MediaQuery.of(context).size.width * .85,
          child: state.value
              ? Container(
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: CustomColors.primary)),
                  child: Center(
                    child: Center(
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
                    if (_editProfileFormKey.currentState.validate()) {
                      final snackBar = SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: CustomColors.primaryHover,
                          content: Text(
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "يتم الان ارسال التعديل علي البيانات. برجاء الانتظار.."
                                : "The advertisement is being uploaded, please wait ...",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary),
                          ));

                      _editProfileScaffoldKey.currentState
                          .showSnackBar(snackBar);
                      state.value = true;
                      authentication
                          .updateUser(
                              widget.userData["id"],
                              _countryController.text,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _oldPassController.text,
                              _newPassController.text,
                              _image.value)
                          .then((value) async {
                        state.value = false;

                        if (value == "true") {
                          final snackBar = SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor: CustomColors.greenLightBG,
                            content: Text(
                              AppLocale.of(context).getTranslated("lang") ==
                                      "En"
                                  ? "تم تعديل بياناتك بنجاح.."
                                  : "Your information has been modified successfully..",
                              style:
                                  TextStyle(color: CustomColors.greenLightFont),
                            ),
                          );
                          _editProfileScaffoldKey.currentState
                              .showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            backgroundColor: CustomColors.ratingLightBG,
                            content: Text(
                              AppLocale.of(context).getTranslated("lang") ==
                                      "En"
                                  ? "لم يكتمل ارسال التعديل من فضلك تاكد من الاتصال بالانترنت و حاول مجدد.."
                                  : "The update has not been sent. Please check your internet connection and try again ...",
                              style:
                                  TextStyle(color: CustomColors.redLightFont),
                            ),
                            duration: Duration(seconds: 3),
                          );
                          _editProfileScaffoldKey.currentState
                              .showSnackBar(snackBar);
                        }

                      });
                    } else {
                      final snackBar = SnackBar(
                          backgroundColor: CustomColors.redLightBG,
                          content: Text(
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "نأسف لا يمكننا ارسل التعديل الا عند اكمل البيانات الاساسية"
                                : "We are sorry, we can only send the amendment when we complete the basic data..",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.redLightFont),
                          ));

                      _editProfileScaffoldKey.currentState
                          .showSnackBar(snackBar);
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

class FeatureImageTaker extends StatefulWidget {
  ValueNotifier<File> image;
  String networkImage;

  FeatureImageTaker(this.image, {this.networkImage});

  @override
  _FeatureImageTakerState createState() => _FeatureImageTakerState();
}

class _FeatureImageTakerState extends State<FeatureImageTaker> {
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
                          child: Center(
                            child: ClipRect(
                              child: (widget.networkImage == null ||
                                      widget.networkImage == '')
                                  ? Image.asset(
                                      'assets/images/khadamatty.png',
                                    )
                                  : Image(
                                      loadingBuilder: (context, image,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) {
                                          return image;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      image: NetworkImage(widget.networkImage,
                                          scale: 1.0),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.45,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
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

Future setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}

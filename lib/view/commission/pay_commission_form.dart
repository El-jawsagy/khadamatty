import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:khadamatty/controller/commission_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/main_screens/main_screen.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

ValueNotifier<File> _image = ValueNotifier(null);
final picker = ImagePicker();

class PayCommissionFormScreen extends StatefulWidget {
  String lang;
  List banks;

  PayCommissionFormScreen(this.lang, this.banks);

  @override
  _PayCommissionFormScreenState createState() =>
      _PayCommissionFormScreenState();
}

class _PayCommissionFormScreenState extends State<PayCommissionFormScreen> {
  TextEditingController _userNameController;
  TextEditingController _amountController;

  TextEditingController _transferNameController;
  TextEditingController _transferPhoneController;
  TextEditingController _adNameController;

  TextEditingController _commentController;
  ValueNotifier<String> bank;

  List<String> allBanks;

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _completeDataScaffoldKey =
      new GlobalKey<ScaffoldState>();
  CommissionAPI commissionAPI;

  String dateTime, _setDate;
  DateTime selectedDate;

  TextEditingController _dateController;

  @override
  void initState() {
    _userNameController = TextEditingController();
    _amountController = TextEditingController();
    _transferNameController = TextEditingController();
    _transferPhoneController = TextEditingController();
    _adNameController = TextEditingController();
    _commentController = TextEditingController();
    _dateController = TextEditingController();
    commissionAPI = CommissionAPI();
    selectedDate = DateTime.now();
    if (widget.lang == "En") {
      bank = ValueNotifier(
        "كل البنوك المتاحة",
      );
    } else {
      bank = ValueNotifier(
        "All Available Banks",
      );
    }
    _dateController.text = DateFormat.yMd().format(selectedDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    allBanks = [];

    if (AppLocale.of(context).getTranslated("lang") == "En") {
      allBanks.add(
        "كل البنوك المتاحة",
      );
    } else {
      allBanks.add(
        "All Available Banks",
      );
    }
    for (var i in widget.banks) {
      allBanks.add(i["bank"]);
    }

    return Scaffold(
      key: _completeDataScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("drawer_commission"),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocale.of(context).getTranslated("form_trans_title"),
                        style:
                            TextStyle(color: CustomColors.dark, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocale.of(context)
                            .getTranslated("form_trans_subtitle"),
                        style: TextStyle(
                            color: CustomColors.primary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("name"), 18),
                    _drawNameEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("amount"), 18),
                    _drawAmountEditText(),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context)
                            .getTranslated("choose_bank_title"),
                        18),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawChooseCountry(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("choose_time"), 18),
                    _drawDataPiker(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("transfer_name"),
                        18),

                    _drawTransferUserEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("transfer_phone"),
                        18),

                    _drawTransferPhoneEditText(),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("ads_name"), 18),

                    _drawAdNameEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("notes"), 18),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    _drawTransferNoteEditText(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    _drawTextHeader(
                        AppLocale.of(context).getTranslated("image_transfer"),
                        18),
                    TransformImageTaker(_image),
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

  Widget _drawTextHeader(string, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            string,
            style: TextStyle(
              fontSize: fontSize,
              color: CustomColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawChooseCountry() {
    return ValueListenableBuilder(
      valueListenable: bank,
      builder: (BuildContext context, value, Widget child) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: CustomColors.gray,
              ),
              borderRadius: BorderRadius.circular(3)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * .08,
          child: Center(
            child: DropdownButton<String>(
              value: bank.value,
              icon: Icon(Icons.arrow_drop_down_outlined),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                color: CustomColors.white,
              ),
              onChanged: (String newValue) {
                bank.value = newValue;
              },
              items: allBanks.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _drawNameEditText() {
    return TextFormField(
      controller: _userNameController,
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

  Widget _drawAmountEditText() {
    return TextFormField(
      controller: _amountController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('amount'),
      ),
    );
  }

  Widget _drawTransferUserEditText() {
    return TextFormField(
      controller: _transferNameController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        } else {}
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('transfer_name'),
      ),
    );
  }

  Widget _drawAdNameEditText() {
    return TextFormField(
      controller: _adNameController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        } else {}
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('ads_name'),
      ),
    );
  }

  Widget _drawTransferPhoneEditText() {
    return TextFormField(
      controller: _transferPhoneController,
      validator: (val) {
        if (val.isEmpty) {
          return AppLocale.of(context).getTranslated('pass_empty');
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('transfer_phone'),
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
  Widget _drawTransferNoteEditText() {
    return TextField(
      controller: _commentController,
      maxLines: 10,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).getTranslated('notes'),
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

  Widget _drawDataPiker() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.7,
        height: MediaQuery.of(context).size.height / 9,
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: TextFormField(
          style: TextStyle(fontSize: 40),
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _dateController,
          onSaved: (String val) {
            _setDate = val;
          },
          decoration: InputDecoration(
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.only(top: 0.0)),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
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
                      if (_image.value != null) {
                        if (bank.value != "كل البنوك المتاحة" &&
                            bank.value != "All Available Banks") {
                          state.value = true;

                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.primaryHover,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "يتم الان رفع البيانات برجاء الانتظار.."
                                    : "The data is being uploaded, please wait..",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primary),
                              ));

                          _completeDataScaffoldKey.currentState
                              .showSnackBar(snackBar);

                          commissionAPI
                              .sendBankTransfer(
                            _userNameController.text,
                            _amountController.text,
                            bank.value,
                            _dateController.text,
                            _transferNameController.text,
                            _transferPhoneController.text,
                            _adNameController.text,
                            _commentController.text,
                            _image.value,
                          )
                              .then((value) {
                            state.value = false;
                            if (value == "true") {
                              final snackBar = SnackBar(
                                backgroundColor: CustomColors.greenLightBG,
                                content: Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? "تم ارسال طلبك بنجاح .."
                                      : "Your order has been sent successfully ..",
                                  style: TextStyle(
                                      color: CustomColors.greenLightFont),
                                ),
                                duration: Duration(seconds: 3),
                              );
                              mainPageScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen(0)));
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: CustomColors.ratingLightBG,
                                content: Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? "لم يكتمل ارسال طلبك من فضلك تاكد من الاتصال بالانترنت و حاول مجدد.."
                                      : "The update has not been sent. Please check your internet connection and try again ...",
                                  style: TextStyle(
                                      color: CustomColors.redLightFont),
                                ),
                                duration: Duration(seconds: 1),
                              );
                              _completeDataScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                            }
                          });
                        } else {
                          state.value = false;

                          final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: CustomColors.ratingLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "يجب اختيار بنك من البنوك المتاحة"
                                    : "You must choose one of the available banks.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.ratingLightFont),
                              ));

                          _completeDataScaffoldKey.currentState
                              .showSnackBar(snackBar);
                        }
                      } else {
                        state.value = false;

                        final snackBar = SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: CustomColors.ratingLightBG,
                            content: Text(
                              AppLocale.of(context).getTranslated("lang") ==
                                      'En'
                                  ? "يجب ادخال الصورة الرئيسية"
                                  : "The main image must be entered",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.ratingLightFont),
                            ));

                        _completeDataScaffoldKey.currentState
                            .showSnackBar(snackBar);
                      }
                    }
                  }
                  // () {
                  //   if (_formKey.currentState.validate()) {
                  //     if (_image.value != null) {
                  //       if (bank.value != "كل الاقسام الرئيسية" &&
                  //           bank.value != "All Main Categories") {}
                  //     }
                  //
                  //     state.value = true;
                  //
                  //     final snackBar = SnackBar(
                  //         backgroundColor: CustomColors.primaryHover,
                  //         content: Text(
                  //           AppLocale.of(context).getTranslated("lang") == 'En'
                  //               ? "يتم الان رفع البيانات برجاء الانتظار.."
                  //               : "The data is being uploaded, please wait..",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: CustomColors.primary),
                  //         ));
                  //
                  //     _completeDataScaffoldKey.currentState
                  //         .showSnackBar(snackBar);
                  //     // aboutAndTermsOfUseAPI
                  //     //     .sendContactUs(
                  //     //   _nameController.text,
                  //     //   _phoneController.text,
                  //     //   _emailController.text,
                  //     //   _massageController.text,
                  //     // )
                  //     //     .then((value) async {
                  //     //   state.value = false;
                  //     //
                  //     //
                  //     // });
                  //   }
                  // },
                  ,
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

class TransformImageTaker extends StatefulWidget {
  ValueNotifier<File> image;

  TransformImageTaker(this.image);

  @override
  _TransformImageTakerState createState() => _TransformImageTakerState();
}

class _TransformImageTakerState extends State<TransformImageTaker> {
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
                                'assets/images/empty.png',
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

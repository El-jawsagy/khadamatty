import 'package:flutter/material.dart';
import 'package:khadamatty/controller/commission_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/commission/all_banks.dart';
import 'package:khadamatty/view/commission/pay_commission_form.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/main_screens/main_screen.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCommissionWayScreen extends StatefulWidget {
 final String title;

  ChooseCommissionWayScreen(this.title);

  @override
  _ChooseCommissionWayScreenState createState() =>
      _ChooseCommissionWayScreenState();
}

class _ChooseCommissionWayScreenState extends State<ChooseCommissionWayScreen> {
  final GlobalKey<ScaffoldState> _chooseCommissionScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _chooseCommissionScaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_commission"),
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
        ),
        drawer: sameDrawer(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(color: CustomColors.primary, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocale.of(context).getTranslated("choose_way"),
                  style: TextStyle(color: CustomColors.dark, fontSize: 18),
                ),
              ),
              _drawVisaCardPay(),
              _drawBankFormPay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawVisaCardPay() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppLocale.of(context).getTranslated("pay_visa_title"),
                  style: TextStyle(color: CustomColors.primary, fontSize: 18),
                ),
                Divider(
                  color: CustomColors.gray,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/credit.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Image.asset(
                      "assets/images/debit.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
                Container(
                  color: CustomColors.greenDarkBG,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocale.of(context).getTranslated("pay_visa_massage"),
                      style: TextStyle(
                          color: CustomColors.greenDarkFont, fontSize: 18),
                    ),
                  ),
                ),
                Divider(
                  color: CustomColors.gray,
                ),
                _drawPayVisaButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawPayVisaButton() {
    return FlatButton(
      height: MediaQuery.of(context).size.height * .06,
      child: Text(
        AppLocale.of(context).getTranslated("pay_visa"),
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
      onPressed: () {
        final snackBar = SnackBar(
          backgroundColor: CustomColors.ratingLightBG,
          content: Text(
            AppLocale.of(context).getTranslated("lang") == "En"
                ? "لم يتم تفعيل هذه الطريقة بعد.."
                : "This method has not been activated yet ..",
            style: TextStyle(
              color: CustomColors.ratingLightFont,
              fontSize: 18,
            ),
          ),
          duration: Duration(seconds: 1, milliseconds: 500),
        );
        _chooseCommissionScaffoldKey.currentState.showSnackBar(snackBar);
      },
    );
  }

  Widget _drawBankFormPay() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppLocale.of(context).getTranslated("pay_bank_title"),
                  style: TextStyle(color: CustomColors.primary, fontSize: 18),
                ),
                Divider(
                  color: CustomColors.gray,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? "ستجد جميع حساباتنا البنكية للتحويل في جميع البنوك"
                              : "You will find all our bank accounts for transfer in all banks.",
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllBanksScreen()));
                          },
                          child: Text(
                            AppLocale.of(context).getTranslated("lang") == "En"
                                ? " من هنا"
                                : "From Here",
                            style: TextStyle(
                              color: CustomColors.dark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  color: CustomColors.greenDarkBG,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocale.of(context).getTranslated("pay_bank_massage"),
                      style: TextStyle(
                          color: CustomColors.greenDarkFont, fontSize: 18),
                    ),
                  ),
                ),
                Divider(
                  color: CustomColors.gray,
                ),
                _drawPayBankButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawPayBankButton() {
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
                  child: Text(
                    AppLocale.of(context).getTranslated("pay_bank"),
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
                  onPressed: () async {
                    state.value = true;

                    SharedPreferences pref =
                        await SharedPreferences.getInstance();

                    if (pref.getString("token") == null ||
                        pref.getString("token") == "null") {
                      state.value = false;

                      final snackBar = SnackBar(
                        duration: Duration(
                          seconds: 3,
                        ),
                        backgroundColor: CustomColors.ratingLightBG,
                        content: Text(
                          AppLocale.of(context).getTranslated("lang") == 'En'
                              ? "يجب تسجيل الدخول اولا حتي يمكن المتابعة.."
                              : "You must be logged in first to be able to continue..",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.ratingLightFont),
                        ),
                        action: SnackBarAction(
                          label: AppLocale.of(context).getTranslated("log"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          textColor: CustomColors.ratingLightFont,
                        ),
                      );
                      _chooseCommissionScaffoldKey.currentState
                          .showSnackBar(snackBar);
                    } else {
                      state.value = false;

                      final snackBar = SnackBar(
                          duration: Duration(
                            seconds: 1,
                          ),
                          backgroundColor: CustomColors.primaryHover,
                          content: Text(
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "يتم الان الاستعلام عن كل البنوك المتاحة برجاء الانتظار.."
                                : "Inquiries are being made about all available banks, please wait..",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary),
                          ));

                      _chooseCommissionScaffoldKey.currentState
                          .showSnackBar(snackBar);
                      CommissionAPI commissionAPI = CommissionAPI();
                      commissionAPI.getAllBanks().then((value) {
                        state.value = false;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PayCommissionFormScreen(
                                    AppLocale.of(context).getTranslated("lang"),
                                    value)));
                      });
                    }
                  },
                ),
        );
      },
    );
  }

  Future<void> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    return null;

  }
}

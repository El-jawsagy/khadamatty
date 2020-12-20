import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/commission_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/about_us.dart';
import 'package:khadamatty/view/black_list.dart';
import 'package:khadamatty/view/commission/choose_commission_way.dart';
import 'package:khadamatty/view/contact_us.dart';
import 'package:khadamatty/view/discount.dart';
import 'package:khadamatty/view/usage_agreement.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screens/main_screen.dart';

Widget sameDrawer(BuildContext context) {
  return FutureBuilder(
      future: Preference.getToken(),
      builder: (context, snapshot) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.68,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Theme(
                data: ThemeData(canvasColor: CustomColors.white),
                child: Drawer(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Image.asset(
                              "assets/images/khadamatty.png",
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.home,
                              AppLocale.of(context)
                                  .getTranslated('drawer_home'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen(0)));
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.moneyBill,
                              AppLocale.of(context)
                                  .getTranslated('drawer_commission'),
                              () {
                                CommissionAPI commissionApi = CommissionAPI();
                                commissionApi
                                    .getCommissionValue(AppLocale.of(context)
                                                .getTranslated("lang") ==
                                            "En"
                                        ? "ar"
                                        : "en")
                                    .then((value) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChooseCommissionWayScreen(
                                                  value)));
                                });
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.percentage,
                              AppLocale.of(context)
                                  .getTranslated('drawer_discount'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiscountScreen()));
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.fileContract,
                              AppLocale.of(context)
                                  .getTranslated('drawer_agreement'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UsageAgreementScreen()));
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.ban,
                              AppLocale.of(context)
                                  .getTranslated('drawer_black_list'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BlackListScreen()));
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.phone,
                              AppLocale.of(context)
                                  .getTranslated('drawer_contact'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ContactUsScreen()));
                              },
                            ),
                            drawRow(
                              context,
                              FontAwesomeIcons.infoCircle,
                              AppLocale.of(context)
                                  .getTranslated('drawer_about'),
                              () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AboutUsScreen()));
                              },
                            ),
                            (!snapshot.hasData)
                                ? drawRow(
                                    context,
                                    FontAwesomeIcons.signInAlt,
                                    AppLocale.of(context).getTranslated('log'),
                                    () async {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                  )
                                : drawRow(
                                    context,
                                    FontAwesomeIcons.signOutAlt,
                                    AppLocale.of(context)
                                        .getTranslated('drawer_sign_out'),
                                    () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("token", null);
                                      prefs.setString("cart", null);
                                      prefs.setString("favorite", null);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(0)));
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

Widget drawRow(BuildContext context, IconData icon, String string, onPress) {
  return ListTile(
    onTap: onPress,
    leading: FaIcon(
      icon,
      color: CustomColors.primary.withOpacity(0.8),
      size: 16,
    ),
    title: Text(
      string,
      style: TextStyle(color: CustomColors.primary),
      textAlign: AppLocale.of(context).getTranslated("lang") == "En"
          ? TextAlign.right
          : TextAlign.left,
    ),
    trailing: FaIcon(
      AppLocale.of(context).getTranslated("lang") == "En"
          ? FontAwesomeIcons.chevronLeft
          : FontAwesomeIcons.chevronRight,
      color: CustomColors.primary.withOpacity(0.8),
      size: 16,
    ),
  );
}

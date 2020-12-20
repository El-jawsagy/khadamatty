import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamatty/controller/about_contact_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/main_screens/main_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  AboutAndTermsOfUseAPI aboutUsAPI;

  @override
  void initState() {
    aboutUsAPI = AboutAndTermsOfUseAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: CustomColors.white,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: aboutUsAPI.getInformationAboutUs(
                      AppLocale.of(context).getTranslated("lang") == "En"
                          ? "ar"
                          : "en"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return emptyPage(context, () {
                          setState(() {});
                        });
                        break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return loading(context, .75);
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          return Container(
                            child: _drawFirstCardOfInfo(snapshot.data),
                          );
                        } else
                          return emptyPage(context, () {
                            setState(() {});
                          });
                        break;
                    }
                    return emptyPage(context, () {
                      setState(() {});
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawFirstCardOfInfo(
    text,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      AppLocale.of(context).getTranslated("drawer_about"),
                      style: TextStyle(
                          color: CustomColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 2
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(0)));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/main_screens/profile/profile_screen.dart';
import 'package:khadamatty/view/product/add_new_product.dart';
import 'package:khadamatty/view/product/search/search_product_screen.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_Screen.dart';
import 'home_page_screen.dart';
import 'notification_screen.dart';

class MainScreen extends StatefulWidget {
  int pos;

  MainScreen(this.pos);

  @override
  _MainScreenState createState() => _MainScreenState();
}

final GlobalKey<ScaffoldState> mainPageScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  ValueNotifier<int> pos;
  AdsAPI adsAPI;

  @override
  void initState() {
    pos = ValueNotifier(widget.pos);
    adsAPI = AdsAPI();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: pos.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainPageScaffoldKey,
      backgroundColor: CustomColors.grayBack,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("app_name"),
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                );
              },
              icon: FaIcon(FontAwesomeIcons.solidBell),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: Icon(Icons.search),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
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
          ),
        ],
      ),
      drawer: sameDrawer(context),
      body: ValueListenableBuilder(
        valueListenable: pos,
        builder: (BuildContext context, value, Widget child) {
          if (_tabController.indexIsChanging) {
            pos.value = _tabController.index.floor();
          }
          print(_tabController.index);
          return TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              HomePage(),
              FavoriteScreen(),
              ProfileScreen(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SharedPreferences.getInstance().then((SharedPreferences value) async {
            SharedPreferences prefs = value;
            String token = prefs.get("token");
            if (token == null) {
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
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  textColor: CustomColors.ratingLightFont,
                ),
              );
              mainPageScaffoldKey.currentState.showSnackBar(snackBar);
            } else {
              final snackBar = SnackBar(
                  backgroundColor: CustomColors.primaryHover,
                  content: Text(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "يتم تحميل الاقسام الرئيسية برجاء الانتظار.."
                        : "Main sections are loaded, please wait ...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primary),
                  ));

              mainPageScaffoldKey.currentState.showSnackBar(snackBar);
              await adsAPI.getInfo().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAnnouncementScreen(value,
                            AppLocale.of(context).getTranslated("lang"))));
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: CustomColors.primary,
      ),
      bottomNavigationBar: drawBottomBar(),
    );
  }

  Widget drawBottomBar() {
    return ValueListenableBuilder(
      valueListenable: pos,
      builder: (BuildContext context, value, Widget child) {
        if (_tabController.indexIsChanging) {
          pos.value = _tabController.index.floor();
        }
        return BottomNavigationBar(
          currentIndex: pos.value,
          type: BottomNavigationBarType.fixed,
          onTap: (val) {
            pos.value = val;
            _tabController.animateTo(val,
                duration: Duration(seconds: 2), curve: Curves.easeInBack);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocale.of(context).getTranslated("lang") == "En"
                  ? 'خدماتي'
                  : "Khadamatty",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: AppLocale.of(context).getTranslated("lang") == "En"
                  ? 'المفضلة'
                  : "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: AppLocale.of(context).getTranslated("lang") == "En"
                  ? 'الصغحة الشخصية'
                  : "Profile",
            ),
          ],
          selectedFontSize: 12,
        );
      },
    );
  }
}

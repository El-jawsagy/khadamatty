import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khadamatty/view/main_screens/main_screen.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/lang/applocate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(
    Phoenix(child: lang()),
  );
}

class lang extends StatefulWidget {
  @override
  _langState createState() => _langState();
}

class _langState extends State<lang> {
  Future chooseLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("lang") == null) {
      prefs.setString("lang", "ar");
      return Locale(prefs.getString("lang"), '');
    } else {
      return Locale(prefs.getString("lang"), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chooseLang(),
        builder: (context, snapshot) {
          return MyApp(snapshot.data);
        });
  }
}

class MyApp extends StatefulWidget {
  final Locale locale;

  MyApp(this.locale);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Khadamaty',
        locale: widget.locale,
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localeResolutionCallback: (currentLocale, supportedLocales) {
          if (currentLocale != null) {
            print(currentLocale.countryCode);
            for (Locale locale in supportedLocales) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: CustomColors.primary,
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
            title: GoogleFonts.almarai(),
            body2: GoogleFonts.almarai(),
          )),

          textTheme: TextTheme(
            bodyText1: GoogleFonts.almarai(),
            bodyText2: GoogleFonts.almarai(),
            headline1: GoogleFonts.almarai(),

          ),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(0),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lootfat_owner/utils/localization/app_language.dart';
import 'package:lootfat_owner/utils/localization/app_localizations.dart';
import 'package:lootfat_owner/utils/theme/dark_theme_provider.dart';
import 'package:lootfat_owner/utils/theme/dark_themedata.dart';
import 'package:lootfat_owner/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguageProvider appLanguage = AppLanguageProvider();
  await Firebase.initializeApp();
  await appLanguage.fetchLocale();

  runApp(
    MyApp(appLanguage: appLanguage),
  );
}

class MyApp extends StatefulWidget {
  final AppLanguageProvider appLanguage;
  const MyApp({super.key, required this.appLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: Consumer2<AppLanguageProvider, DarkThemeProvider>(
        builder: (BuildContext context, language, theme, Widget? child) {
          return MaterialApp(
            title: 'LootFat Merchant',
            theme: Styles.themeData(theme.darkTheme, context),
            debugShowCheckedModeBanner: false,
            locale: language.appLocal,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: FToastBuilder(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

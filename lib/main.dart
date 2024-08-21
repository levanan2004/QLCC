import 'package:apartment_management/Auth/auth_page.dart';
import 'package:apartment_management/admob/open_app.dart';
import 'package:apartment_management/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

late Size mq;
final AppOpenAdService _appOpenAdService =
    AppOpenAdService(); // Khởi tạo dịch vụ quảng cáo mở ứng dụng

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  // Tải quảng cáo mở ứng dụng ngay khi ứng dụng khởi động
  _appOpenAdService.loadAppOpenAd();
  runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [Locale("vi"), Locale("en")],
      path: "assets/translations"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 10,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19,
              ),
              backgroundColor: Colors.white)),
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      home: AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

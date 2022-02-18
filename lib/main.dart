import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/screens/splash_screen.dart';
import 'provider/provider_bottom_nav_bar.dart';
import 'provider/provider_switch.dart';
import 'ui/theme/theme_data.dart';

void main() async {
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderBottomNavBar(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProviderSvitch(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
      home: SplashScreen(),
    );
  }
}

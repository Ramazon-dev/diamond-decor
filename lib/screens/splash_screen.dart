import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/screens/home/home_page.dart';
import 'package:wallpaper/screens/home/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    islogin(context);

    return Scaffold(
      body: splash(context),
    );
  }

  InkWell splash(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Image.asset('assets/images/splash.jpg'),
      ),
    );
  }

  islogin(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (tokenIsExpired()) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  bool tokenIsExpired() {
    String token = "";
    bool value = true;

    try {
      token = box.read("token");
      value = JwtDecoder.isExpired(token);
      return value;
    } catch (e) {}
    return value;
  }
}

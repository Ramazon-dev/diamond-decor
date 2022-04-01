import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/core/query.dart';
import 'package:wallpaper/screens/home/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emainController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        height: getHeight(844),
        width: getWidth(390),
        child: SingleChildScrollView(
          child: Container(
            // height: getHeight(641),
            // width: getWidth(324),
            padding: EdgeInsets.only(left: getHeight(22), top: getHeight(36),bottom:20 ),
            margin: EdgeInsets.symmetric(
              horizontal: getWidth(30),
              vertical: getHeight(60),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(getHeight(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                  blurStyle: BlurStyle.normal,
                ),
              ], // color: Colors.cyan,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xff878787),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: getHeight(180),
                    width: getWidth(280),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/splash.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(getHeight(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                          blurStyle: BlurStyle.normal,
                        ),
                      ], // color: Colors.cyan,
                      border: Border.all(
                        color: const Color(0xff878787),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: getHeight(42)),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: getHeight(16),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: getHeight(9), right: getWidth(22)),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emainController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: "Enter your email",
                        labelStyle: const TextStyle(
                          color: hitTextColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: getHeight(38)),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: getHeight(16),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: getHeight(9), right: getWidth(22)),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.remove_red_eye,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelText: "Enter your Password",
                        labelStyle: const TextStyle(
                          color: hitTextColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: getHeight(79)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        fixedSize: Size(getWidth(280), getHeight(57)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getHeight(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {});
                        if (formKey.currentState!.validate()) {
                          QueryResult result =
                              await client.value.mutate(MutationOptions(
                            document: gql(loginQuery(
                                emainController.text, passwordController.text)),
                          ));
                          final productlist = result.data?['login'];
                          String accesstoken = productlist['accessToken'] ?? '';
                          if (accesstoken == "") {
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                'Parol xato',
                                style: TextStyle(color: Colors.red),
                              ),
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'Qayta kiriting',
                                onPressed: () {},
                              ),
                            ));
                          } else {
                            int? id = productlist['user']['id'];

                            await box.write('token', accesstoken);
                            await box.write('id', id.toString());
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                'Login to\'g\'ri',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'Kuting',
                                onPressed: () {},
                              ),
                            ));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                (route) => false);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

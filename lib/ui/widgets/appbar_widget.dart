import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/provider/provider_bottom_nav_bar.dart';
import 'package:wallpaper/provider/provider_switch.dart';
import 'package:wallpaper/screens/appbar/settings.dart';
import 'package:wallpaper/screens/home/sign_in_page.dart';

class AppBArClass extends StatelessWidget with PreferredSizeWidget {
  List<String> listOfString = [
    "Товары",
    "История заказов",
    "Деньги чат",
  ];
  late ProviderBottomNavBar _bottomNavBar;

  bool ozgaruvchi = false;
  late ProviderSvitch _providerSvitch;
  TextEditingController nameController = TextEditingController();

  AppBArClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _bottomNavBar = context.watch();
    _providerSvitch = context.watch();

    SizeConfig().init(context);
    return AppBar(
      title: Text(
        listOfString[_bottomNavBar.currentIndex],
        style: TextStyle(
          color: Colors.white,
          fontSize: getHeight(20),
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage()));
          },
          child: Container(
              alignment: Alignment.center,
              height: getWidth(44),
              width: getWidth(44),
              margin: EdgeInsets.only(right: getWidth(15)),
              child: SvgPicture.asset('assets/icons/settings.svg')),
        ),
        Container(
          height: getWidth(44),
          width: getWidth(44),
          margin: EdgeInsets.only(right: getWidth(20)),
          child: InkWell(
              onTap: () {
                showAlertDialogExit(context);
              },
              child: SvgPicture.asset(
                'assets/icons/logout.svg',
                fit: BoxFit.fitWidth,
              )),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(getWidth(390), getHeight(74));
  showAlertDialogExit(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(getWidth(100), getHeight(45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
      child: Text(
        "Назад",
        style: TextStyle(
          color: Colors.white,
          fontSize: getHeight(12),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(getWidth(100), getHeight(45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
      child: Text(
        "Выход",
        style: TextStyle(
          color: Colors.white,
          fontSize: getHeight(12),
        ),
      ),
      onPressed: () async {
        box.remove("token");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 10,
      buttonPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: const Text("Выход"),
      actionsAlignment: MainAxisAlignment.spaceAround,
      content: textMethod("Вы хотите выйти из профиля?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Text textMethod(String stringName) {
    return Text(
      stringName,
      style: TextStyle(
        color: Colors.black,
        fontSize: getHeight(16),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

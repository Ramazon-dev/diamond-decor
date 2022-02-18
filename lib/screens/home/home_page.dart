import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/provider/provider_bottom_nav_bar.dart';
import 'package:wallpaper/screens/chat/moneychat.dart';
import 'package:wallpaper/screens/home/products.dart';
import 'package:wallpaper/screens/home/sign_in_page.dart';
import 'package:wallpaper/ui/widgets/appbar_widget.dart';
import 'package:wallpaper/ui/widgets/bottom_nav_bar.dart';

import 'history_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<Widget> listOfPages = [
    ProductsPage(),
    const HistoryPage(),
    const ChatPageMoney(),
  ];
  late ProviderBottomNavBar _bottomNavBar;
  @override
  Widget build(BuildContext context) {
    _bottomNavBar = context.watch();
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        bool? showdialog = await showAlertDialogExit(context);
        return showdialog ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBArClass(),
        bottomNavigationBar: MyBottomBar(),
        body: listOfPages[_bottomNavBar.currentIndex],
      ),
    );
  }

  showAlertDialogExit(BuildContext context) {
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
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

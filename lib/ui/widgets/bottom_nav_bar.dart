import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/provider/provider_bottom_nav_bar.dart';

class MyBottomBar extends StatelessWidget {
  MyBottomBar({Key? key}) : super(key: key);

  late ProviderBottomNavBar _bottomNavBar;

  @override
  Widget build(BuildContext context) {
    _bottomNavBar = context.watch();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(getWidth(50)))),
      height: getHeight(65),
      child: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        unselectedItemColor: whiteColor,
        selectedItemColor: whiteColor,
        selectedFontSize: 16,
        elevation: 10,
        currentIndex: _bottomNavBar.currentIndex,
        onTap: _bottomNavBar.setCurrentIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/Home.svg"),
            label: "Товары",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/Bookmark.svg"),
            label: "Заказы",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/comment.svg"),
            label: "Деньги чат",
          ),
        ],
      ),
    );
  }
}

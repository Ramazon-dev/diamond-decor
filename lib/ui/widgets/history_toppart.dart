import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/provider/provider_switch.dart';
import 'package:wallpaper/screens/appbar/filterpage.dart';

class HistoryTop extends StatefulWidget {
  @override
  State<HistoryTop> createState() => _HistoryTopState();
}

class _HistoryTopState extends State<HistoryTop> {
  List<String> listOfFilters = [
    "ID",
    "Дата заказа",
    "Количество",
    "Артикул",
    "Статус",
    "Действия",
  ];

  List<bool>? ozgaruvchi;

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ozgaruvchi = context.watch<ProviderSvitch>().filterlist;
    SizeConfig().init(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: getWidth(23),
            right: getWidth(23),
          ),
          height: getHeight(60),
          width: getWidth(390),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Filters()));
                },
                child: SvgPicture.asset("assets/images/Vector.svg"),
              ),
              Container(
                  margin: EdgeInsets.only(left: getWidth(220)),
                  child: const Icon(Icons.file_download_outlined, size: 28)),
              SvgPicture.asset("assets/images/Vector(1).svg"),
            ],
          ),
        ),
      ],
    );
  }

  Text textMethod(String nameOfString) {
    return Text(
      nameOfString,
      style: TextStyle(
          fontSize: getHeight(16),
          fontWeight: FontWeight.w600,
          color: primaryColor),
    );
  }
}

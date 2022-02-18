import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/provider/provider_switch.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  List<String> listOfFilters = [
    "Деньги",
    "Заказать чат",
    "Tулбар",
    "Заказы",
  ];

  bool ozgaruvchi = false;
  late ProviderSvitch _providerSvitch;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _providerSvitch = context.watch();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Обновить пароль",
            style: TextStyle(
                fontSize: getHeight(16),
                fontWeight: FontWeight.w600,
                color: whiteColor),
          ),
          iconTheme: const IconThemeData(color: whiteColor),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: getHeight(40),
                  margin: EdgeInsets.only(
                    top: getHeight(30),
                    // right: getWidth(20),
                    // left: getWidth(20),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Пароль",
                      labelStyle: TextStyle(
                        color: hitTextColor,
                        fontSize: getHeight(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: getHeight(40),
                  margin: EdgeInsets.only(
                    top: getHeight(10),
                    // right: getWidth(20),
                    // left: getWidth(20),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Подтвердите пароль",
                      labelStyle: TextStyle(
                        fontSize: getHeight(12),
                        color: hitTextColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: getHeight(250),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                // left: getWidth(20),
                                top: getHeight(10),
                              ),
                              child: textMethod(listOfFilters[index]),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: getWidth(10),
                                // right: getWidth(20),
                                top: getHeight(10),
                              ),
                              child: CupertinoSwitch(
                                value: _providerSvitch.switchboollist[index],
                                onChanged: (bool v) {
                                  context
                                      .read<ProviderSvitch>()
                                      .setAddProducktCounter(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: listOfFilters.length,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(getWidth(280), getHeight(55)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Сохранить",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getHeight(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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

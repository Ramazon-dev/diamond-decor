import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/provider/provider_switch.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  TextEditingController nameController = TextEditingController();

  List<String> listOfFilters = [
    "ID",
    "Дата заказа",
    "Количество",
    "Артикул",
    "Статус",
    "Действия",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Фильтр",
          style: TextStyle(
              fontSize: getHeight(16),
              fontWeight: FontWeight.w600,
              color: whiteColor),
        ),
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: getHeight(40),
                margin: EdgeInsets.only(
                  top: getHeight(24),
                  right: getWidth(20),
                  left: getWidth(20),
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
                    labelText: "Дата начала",
                    labelStyle: const TextStyle(
                      color: hitTextColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: getHeight(40),
                margin: EdgeInsets.only(
                  top: getHeight(20),
                  right: getWidth(20),
                  left: getWidth(20),
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
                    labelText: "Дата конца",
                    labelStyle: const TextStyle(
                      color: hitTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(350),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: getWidth(20),
                              top: getHeight(10),
                            ),
                            child: textMethod(listOfFilters[index]),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: getWidth(10),
                              right: getWidth(20),
                              top: getHeight(10),
                            ),
                            child: CupertinoSwitch(
                              value: context
                                  .watch<ProviderSvitch>()
                                  .filterlist[index],
                              onChanged: (bool v) {
                                context.read<ProviderSvitch>().setfilter(index);
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: Size(getWidth(280), getHeight(55))),
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
      ),
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

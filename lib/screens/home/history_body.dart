import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/core/query.dart';
import 'package:wallpaper/provider/provider_switch.dart';
import 'package:wallpaper/screens/appbar/filterpage.dart';
import 'package:wallpaper/screens/chat/ordercoment.dart';

class HistoryOrderPage extends StatefulWidget {
  @override
  State<HistoryOrderPage> createState() => _HistoryOrderPageState();
}

class _HistoryOrderPageState extends State<HistoryOrderPage> {
  List listOfStrings = ["id", "Дата заказа", "N%", "Артикул", "Статус", 'Чат'];
  List<double> sizeList = [65, 90, 60, 100, 85, 70];

  List listOfRows = [];

  String amount = "last:10";
  bool isAllcheck = false;
  List deleteList = List.generate(10, (index) => false);
  int st = 0;

  int end = 10;
  List? snapshot;
  List<bool>? listorder;

  @override
  Widget build(BuildContext context) {
    listorder = context.watch<ProviderSvitch>().filterlist;
    List<Widget> row = List.generate(6, (i) {
      if (listorder![i]) {
        return elevatedButtonMethod(context, listOfStrings[i], sizeList[i]);
      } else {
        return Container();
      }
    });
    return Column(
      children: [
        FutureBuilder(
          future: funkorder(),
          builder: (context, AsyncSnapshot snap) {
            if (snap.hasData) {
              snapshot = snap.data;

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Filters()));
                          },
                          child: SvgPicture.asset("assets/images/Vector.svg"),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: getWidth(220)),
                            child: const Icon(Icons.file_download_outlined,
                                size: 28)),
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      buttonPadding: const EdgeInsets.all(10),
                                      title: const Text(
                                        "Вы хотите отменить заказ ?",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Назад'),
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                                getWidth(110), getHeight(45)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                  getWidth(110), getHeight(45)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            onPressed: () async {
                                              for (var i = 0;
                                                  i < snap.data.length;
                                                  i++) {
                                                if (deleteList[i]) {
                                                  var res = await clientAll
                                                      .value
                                                      .mutate(MutationOptions(
                                                    document: gql(
                                                      deleteOrdder(
                                                        snap.data.reversed
                                                                .toList()[i]
                                                            ['node']['id'],
                                                      ),
                                                    ),
                                                  ));
                                                }
                                              }
                                              deleteList = List.generate(
                                                  10, (index) => false);
                                              isAllcheck = false;

                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text('Да'))
                                      ],
                                    );
                                  });
                            },
                            icon: SvgPicture.asset(
                                "assets/images/Vector(1).svg")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getHeight(555),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: getWidth(3)),
                          width: getWidth(540),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(
                                    left: getWidth(1), right: getWidth(14)),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: secondaryColor,
                                  child: Row(
                                    children: [
                                      Container(
                                        color: whiteColor,
                                        height: getHeight(17),
                                        width: getWidth(17),
                                        margin: const EdgeInsets.all(16),
                                        child: Checkbox(
                                            // hoverColor: Colors.white,
                                            // focusColor: Colors.white,
                                            checkColor: Colors.white,
                                            activeColor: secondaryColor,
                                            value: isAllcheck,
                                            onChanged: (v) {
                                              isAllcheck = v!;
                                              deleteList =
                                                  List.generate(10, (i) {
                                                return v;
                                              });

                                              setState(() {});
                                            }),
                                      ),
                                      Row(
                                        children: row,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: getHeight(5)),
                              SizedBox(
                                height: getHeight(498),
                                child: CustomRefreshIndicator(
                                  onRefresh: () {
                                    setState(() {});
                                    return Future.delayed(
                                        const Duration(seconds: 3));
                                  },
                                  builder: (BuildContext context, Widget child,
                                      IndicatorController controller) {
                                    return AnimatedBuilder(
                                      animation: controller,
                                      builder: (BuildContext context, _) {
                                        return Stack(
                                          alignment: Alignment.topCenter,
                                          children: <Widget>[
                                            if (!controller.isIdle)
                                              Positioned(
                                                top: getHeight(30) *
                                                    controller.value,
                                                child: SizedBox(
                                                  height: getHeight(30),
                                                  width: getWidth(30),
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: !controller.isLoading
                                                        ? controller.value
                                                            .clamp(0.0, 1.0)
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            Transform.translate(
                                              offset: Offset(
                                                  0, 100.0 * controller.value),
                                              child: child,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: listViewBuilderMethod(snapshot!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                height: getHeight(555),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
        SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width / 1.6,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: getHeight(30),
                width: getWidth(55),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    if (st > 9) {
                      amount = snapshot!.isEmpty
                          ? "first:10"
                          : "first:10, after:\"${snapshot![snapshot!.length - 1]['cursor']}\"";
                      setState(() {
                        st = st - 10;
                        end = end - 10;
                      });
                    }
                  },
                  child: SvgPicture.asset('assets/icons/arrow_back.svg'),
                ),
              ),
              Container(
                height: getHeight(35),
                width: getWidth(65),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  "$st/$end",
                  style: TextStyle(
                      fontSize: getHeight(16),
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                ),
              ),
              Container(
                height: getHeight(30),
                width: getWidth(55),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    if (snapshot!.length == 10) {
                      amount = "last:10 before:\"${snapshot![0]['cursor']}\"";
                      setState(() {
                        st = st + 10;
                        end = end + 10;
                      });
                    }
                  },
                  child: SvgPicture.asset('assets/icons/arrow_forward.svg'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ListView listViewBuilderMethod(List<dynamic> snapshot1) {
    List snapshot = snapshot1.reversed.toList();
    List listOfRows = List.generate(
        snapshot.length, (index) => snapshot[index]['node']['id']);
    return ListView.builder(
      itemBuilder: (context, index) {
        List date = snapshot[index]['node']['dateOrder'].split("T");
        String str1 = date[0];
        String str2 = date[1].split('.')[0];

        return Container(
          height: getHeight(50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Checkbox(
                  checkColor: Colors.white,
                  activeColor: primaryColor,
                  value: deleteList[index],
                  onChanged: (v) {
                    deleteList.removeAt(index);
                    deleteList.insert(index, v);
                    isAllcheck = false;

                    setState(() {});
                  }),
              listorder![0]
                  ? containerMethod(snapshot, index,
                      snapshot[index]['node']['id'].toString(), 60)
                  : Container(),
              listorder![1]
                  ? containerMethod(
                      snapshot,
                      index,
                      "$str1 \n $str2",
                      110,
                    )
                  : Container(),
              listorder![2]
                  ? containerMethod(
                      snapshot,
                      index,
                      snapshot[index]['node']['amount'].toString(),
                      50,
                    )
                  : Container(),
              listorder![3]
                  ? containerMethod(
                      snapshot,
                      index,
                      snapshot[index]['node']['product']['article'].toString(),
                      110,
                    )
                  : Container(),
              listorder![4]
                  ? containerMethod(
                      snapshot,
                      index,
                      snapshot[index]['node']['status'].toString() == 'WAITING'
                          ? 'Ожидает'
                          : 'Получено',
                      90,
                    )
                  : Container(),
              listorder![5]
                  ? Container(
                      alignment: Alignment.center,
                      height: getHeight(30),
                      width: getWidth(60),
                      child: IconButton(
                        // Chat
                        icon: Icon(
                          Icons.mode_comment_outlined,
                          size: getHeight(20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatPageOrder()));
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
      itemCount: snapshot.length,
    );
  }

  Container containerMethod(
      List<dynamic> snapshot, int index, String name, double widgth) {
    return Container(
      height: getHeight(50),
      width: getWidth(widgth),
      alignment: Alignment.center,
      // id
      child: Text(name),
    );
  }

  ElevatedButton elevatedButtonMethod(
      BuildContext context, String nameOfButton, double width) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        nameOfButton,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        fixedSize: Size(
          getWidth(50),
          getHeight(50),
        ),
        minimumSize: Size(
          getWidth(width),
          getHeight(50),
        ),
      ),
    );
  }

  funkorder() async {
    QueryResult? products = await clientAll.value.mutate(MutationOptions(
      document: gql(ordersAllQuery(amount)),
    ));
    final List productlist = products.data?["orders"]['edges'];
    return productlist;
  }
}
 /* 
              IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceAround,
                            buttonPadding: const EdgeInsets.all(10),
                            title: Text(
                              "Вы хотите отменить заказ ${snapshot[index]['node']['id']} ?",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Назад'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(getWidth(110), getHeight(45)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize:
                                        Size(getWidth(110), getHeight(45)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var res = await clientAll.value
                                        .mutate(MutationOptions(
                                      document: gql(deleteOrdder(
                                          snapshot[index]['node']['id'])),
                                    ));

                                    setState(() {});
                                    Navigator.pop(context);
                                    if (res.data == null) {
                                      const snackBar = SnackBar(
                                        content: Text(
                                          'Вы не можете отменить этот заказ!',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text('Отменить'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete)),
                  */
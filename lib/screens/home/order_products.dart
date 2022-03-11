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
import 'package:wallpaper/provider/provider_bottom_nav_bar.dart';
import 'package:wallpaper/ui/widgets/appbar_widget.dart';

class OrderProducts extends StatefulWidget {
  final List<int> sonlardaa;
  final List? datalist;

  const OrderProducts(
      {required this.sonlardaa, required this.datalist, Key? key})
      : super(key: key);
  @override
  State<OrderProducts> createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {
  late ProviderBottomNavBar _bottomNavBar;
  bool providerSvitch = false;

  late List<int> sonlar;
  late List? datalist;
  late TextEditingController controller;
  List orders = [];
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sonlar = widget.sonlardaa;
    datalist = widget.datalist;
  }

  @override
  Widget build(BuildContext context) {
    _bottomNavBar = context.watch();
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBArClass(),
        bottomNavigationBar: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(2, 2),
                blurStyle: BlurStyle.normal,
              ),
            ], // color: Colors.cyan,
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              // color: const Color(0xff878787),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              fixedSize: Size(getWidth(280), getHeight(57)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              for (var i = 0; i < datalist!.length; i++) {
                if (sonlar[i] != 0) {
                  orders.add(
                      {"amount": sonlar[i], "productId": datalist![i]['id']});
                }
              }
              if (orders.isEmpty) {
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  Navigator.pop(context);
                  setState(() {});
                });
              } else {
                await createarray(orders);
                orders.clear();
                sonlar = List<int>.generate(10, (i) => i * 0);
                Navigator.pop(context);
                setState(() {});
                _bottomNavBar.currentint = 1;
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  providerSvitch = false;
                  setState(() {});
                });
              }
            },
            child: Text(
              "Подтвердить",
              style: TextStyle(
                color: Colors.white,
                fontSize: getHeight(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(20),
                vertical: getHeight(20),
              ),
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 44,
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
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/icons/arrow_back.svg',
                      ),
                    ),
                  ),
                  Container(
                    height: getHeight(35),
                    width: getWidth(60),
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
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        "0/10",
                        style: TextStyle(
                          fontSize: getHeight(16),
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: getHeight(30),
                    width: getWidth(40),
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
                      onTap: () {},
                      child: SvgPicture.asset('assets/icons/arrow_forward.svg'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getHeight(589),
              child: CustomRefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(const Duration(seconds: 2));
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
                              top: getHeight(35) * controller.value,
                              child: SizedBox(
                                height: getHeight(30),
                                width: getWidth(30),
                                child: CircularProgressIndicator(
                                  value: !controller.isLoading
                                      ? controller.value.clamp(0.0, 1.0)
                                      : null,
                                ),
                              ),
                            ),
                          Transform.translate(
                            offset: Offset(0, 100.0 * controller.value),
                            child: child,
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    controller = TextEditingController(
                      text: '${sonlar[index]}',
                    );
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: getWidth(10),
                        horizontal: getHeight(20),
                      ),
                      height: getHeight(180),
                      width: getWidth(350),
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
                      child: Column(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: getHeight(20),
                                      left: getHeight(getWidth(20)),
                                      right: getWidth(8)),
                                  child: datalist![index]['photo'] == null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: listTileColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      getWidth(6)))),
                                          height: getHeight(63),
                                          width: getWidth(63),
                                        )
                                      : SizedBox(
                                          height: getHeight(63),
                                          width: getWidth(63),
                                          child: Image.network(
                                              "https://diamond.softcity.uz/media/${datalist![index]['photo']}"),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: getHeight(20),
                                          bottom: getHeight(11)),
                                      child: Text(
                                        datalist![index]['article'].toString(),
                                        style: TextStyle(
                                          fontSize: getWidth(16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getWidth(200),
                                      child: Text(
                                        datalist![index]['nameModel']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: getWidth(12),
                                          color: const Color(0xffD0D2DE),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: getHeight(30), left: getWidth(55)),
                                width: getWidth(70),
                                height: getHeight(40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  boxShadow: const [
                                    BoxShadow(blurRadius: 1),
                                    BoxShadow(
                                      spreadRadius: 0.8,
                                      color: Color(0xffD0D2DE),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize:
                                        Size(getWidth(70), getHeight(40)),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    if (sonlar[index] > 0) {
                                      sonlar[index] = sonlar[index] - 1;
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: getHeight(24),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: getHeight(35),
                                width: getWidth(65),
                                margin: EdgeInsets.only(top: getHeight(30)),
                                child: TextField(
                                  style: TextStyle(fontSize: 14),

                                  // controller: controller,
                                  controller: TextEditingController(
                                    text: "${sonlar[index]}",
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) {
                                    sonlar[index] = int.parse(v);
                                  },
                                  decoration: InputDecoration(
                                    // hintText: '0',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //     "${sonlar[index]}",
                              //     style: TextStyle(
                              //       fontSize: getHeight(20),
                              //       fontWeight: FontWeight.w500,
                              //     ),
                              //   ),

                              Container(
                                margin: EdgeInsets.only(
                                    top: getHeight(30), right: getWidth(55)),
                                height: getHeight(40),
                                width: getWidth(70),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  boxShadow: const [
                                    BoxShadow(blurRadius: 1),
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: Color(0xffD0D2DE))
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize:
                                        Size(getWidth(70), getHeight(40)),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    sonlar[index] = sonlar[index] + 1;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: getHeight(24),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: datalist!.length,
                ),
              ),
            ),
          ],
        ));
  }

  Future<List> getproduct(String serch) async {
    QueryResult? products = await clientAll.value.mutate(MutationOptions(
      document: gql(getWithArticleP(serch)),
    ));
    final List productlist = products.data?["productsType"];
    return productlist;
  }

  Future create(int productId, int amount) async {
    QueryResult? user = await clientAll.value.mutate(MutationOptions(
      document: gql(getUser()),
    ));
    final userJson = user.data?["user"];
    QueryResult? create = await clientAll.value.mutate(MutationOptions(
      document: gql(createOrderQuery(
          userJson["id"], userJson['counterpartyId'], productId, amount)),
    ));
    return "ok";
  }

  Future createarray(List orders1) async {
    QueryResult? user = await clientAll.value.mutate(MutationOptions(
      document: gql(getUser()),
    ));
    final userJson = user.data?["user"];
    QueryResult? create = await clientAll.value.mutate(MutationOptions(
      document: gql(createorderarray(userJson['counterpartyId'], orders1)),
    ));
    return "ok";
  }

  showAlertDialog(BuildContext context, List orders2) {
    // set up the buttons

    Widget continueButton = ElevatedButton(
      child: const Text("zakaz"),
      onPressed: () async {
        Navigator.pop(context);
        await createarray(orders2);
        orders.clear();
        sonlar = List<int>.generate(10, (i) => i * 0);

        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Zakazlarni qo'sh"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
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
}

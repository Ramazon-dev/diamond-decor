import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/constants/constants.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/core/query.dart';
import 'package:wallpaper/provider/provider_bottom_nav_bar.dart';
import 'package:wallpaper/screens/home/order_products.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProviderBottomNavBar _bottomNavBar;

  bool _providerSvitch = false;
  List<int> sonlar = List<int>.generate(10, (i) => i * 0);
  int st = 0;
  int end = 10;

  int isbook = -1;

  List? datalist = [];
  late TextEditingController controller;
  var formKey = GlobalKey<FormState>();

  var searchController =
      TextEditingController.fromValue(const TextEditingValue(text: ""));
  List orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bottomNavBar = context.watch();
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: getproduct(searchController.text.toString()),
        builder: (context, AsyncSnapshot<List> snap) {
          if (snap.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snap.data!.length < end) {
              if (snap.data!.length < 10) {
                datalist =
                    snap.data!.getRange(st, snap.data!.length % 10).toList();
              } else {
                datalist = snap.data!
                    .getRange(st, snap.data!.length % 10 + end)
                    .toList();
              }
            } else {
              datalist = snap.data!.getRange(st, end).toList();
            }
            return Column(
              //!  ////////////
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(20), vertical: getWidth(15)),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: "Search",
                      constraints: BoxConstraints(),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    controller: searchController,
                    onChanged: (v) {
                      setState(() {
                        st = 0;
                        end = 10;
                      });
                    },
                    onTap: () {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
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
                                onTap: () {
                                  sonlar = List<int>.generate(10, (i) => i * 0);
                                  if (st != 0) {
                                    st = st - 10;
                                    end = end - 10;
                                    setState(() {});
                                  }
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/arrow_back.svg'),
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
                                  "$st/$end",
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
                                onTap: () {
                                  sonlar = List<int>.generate(10, (i) => i * 0);
                                  if (snap.data!.length > end + 10) {
                                    st = st + 10;
                                    setState(() {});
                                    end = end + 10;
                                  }
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/arrow_forward.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.shopping_bag),
                      ),
                      SizedBox(
                        child: CupertinoSwitch(
                          value: _providerSvitch,
                          onChanged: (value) async {
                            _providerSvitch = value;

                            setState(() {});
                            debugPrint('');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderProducts(
                                  sonlardaa: sonlar,
                                  datalist: datalist,
                                  end: end,
                                  isbook: isbook,
                                  st: st,
                                  orders: orders,
                                ),
                              ),
                            );
                            _providerSvitch != value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(552),
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: getHeight(20),
                                              bottom: getHeight(11)),
                                          child: Text(
                                            datalist![index]['article']
                                                .toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    height: 30,
                                    width: 60,
                                    margin: EdgeInsets.only(top: getHeight(30)),
                                    child: TextField(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getHeight(30),
                                        right: getWidth(55)),
                                    height: getHeight(40),
                                    width: getWidth(70),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.transparent,
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 1),
                                        BoxShadow(
                                          spreadRadius: 1,
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
            );
          }
        },
      ),
    );
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
    print(create.toString());
    return "ok";
  }

  Future createarray(List orders1) async {
    QueryResult? user = await clientAll.value.mutate(MutationOptions(
      document: gql(getUser()),
    ));
    final userJson = user.data?["user"];
    print(userJson['counterpartyId'].toString());
    print(orders1.toString());
    QueryResult? create = await clientAll.value.mutate(MutationOptions(
      document: gql(createorderarray(userJson['counterpartyId'], orders1)),
    ));
    print(create.toString());
    return "ok";
  }

  showAlertDialog(BuildContext context, List orders2) {
    // set up the buttons

    Widget continueButton = ElevatedButton(
      child: const Text("zakaz"),
      onPressed: () async {
        print(orders2.toString());
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

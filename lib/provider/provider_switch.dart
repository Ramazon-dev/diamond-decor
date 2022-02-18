import 'package:flutter/foundation.dart';

class ProviderSvitch with ChangeNotifier {
  List<bool> filterlist = [true, true, true, true, true, true];
  bool switchprovider = false;
  List<bool> switchboollist = [false, false, false, false];

  setfilter(int i) {
    int changecount = 0;
    for (var item in filterlist) {
      if (item == false) {
        changecount++;
      }
    }
    if (changecount < 6) {
      filterlist[i] == true ? filterlist[i] = false : filterlist[i] = true;
    }

    notifyListeners();
  }

  void setAddProducktCounter(int i) {
    switchboollist[i] == true
        ? switchboollist[i] = false
        : switchboollist[i] = true;

    notifyListeners();
  }
}

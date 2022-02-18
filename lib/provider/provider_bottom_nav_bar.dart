import 'package:flutter/foundation.dart';

class ProviderBottomNavBar with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentint(int i) {
    _currentIndex = i;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

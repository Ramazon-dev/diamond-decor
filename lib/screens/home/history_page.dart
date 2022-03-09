import 'package:flutter/material.dart';
import 'package:wallpaper/screens/home/history_body.dart';
import 'package:wallpaper/ui/widgets/history_toppart.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HistoryTop(),
          HistoryOrderPage(),
        ],
      ),
    );
  }
}

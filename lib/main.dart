import 'package:flutter/material.dart';
import 'package:myapp/ui/HistoryPage.dart';
import 'package:myapp/ui/widgets/action_button.dart';
import 'package:myapp/ui/widgets/buildSectionTitle.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'ui/room_details_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoomDetailsPage(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/ui/HistoryPage.dart';
import 'package:myapp/ui/room_list.dart';
import 'package:myapp/ui/serviceAvalible.dart';
import 'package:myapp/ui/widgets/custom_bottom_nav_bar.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockData().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      RoomListPage(),
      HistoryPage(),
      ServicesAvailablePage(),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

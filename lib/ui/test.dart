import 'package:flutter/material.dart';
import 'package:myapp/ui/HistoryPage.dart';
import 'package:myapp/ui/add_tenant_to_room.dart';
import 'package:myapp/ui/room_list.dart';
import 'package:myapp/ui/tenant_form.dart';
import 'package:myapp/ui/widgets/custom_bottom_nav_bar.dart';

void main() => runApp( AddTenantToRoom());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainLayout(),
//     );
//   }
// }
// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//      RoomListPage(),
//      HistoryPage(),
//      Center(child: Text("Dashboarda")),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

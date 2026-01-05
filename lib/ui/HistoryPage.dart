import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/buildHistoryItem.dart';
import 'package:myapp/ui/widgets/buildSectionHeader.dart';
import 'package:myapp/ui/widgets/custom_textfield.dart';
import 'package:myapp/ui/widgets/filter_chip_button.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = const ['All', 'Payment', 'Services', 'Rooms'];
  List<dynamic> _displayList = []; 

  @override
  void initState() {
    super.initState();
    _refreshData();
    _searchController.addListener(_refreshData);
  }

  @override
  void dispose() {
    _searchController.removeListener(_refreshData);
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final searchQuery = _searchController.text.toLowerCase();
    final allLogs = List<RoomHistory>.from(MockData.historyLogs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final filteredLogs = allLogs.where((item) {
      final matchesSearch = item.description.toLowerCase().contains(searchQuery);
      if (!matchesSearch) return false;

      switch (_selectedFilter) {
        case 'Payment':
          return item.actionType == HistoryActionType.paymentAdded;
        case 'Services':
          return item.actionType == HistoryActionType.serviceUpdated;
        case 'Rooms':
          return item.actionType == HistoryActionType.roomDeadlineChanged ||
                 item.actionType == HistoryActionType.newTenantAdded ||
                 item.actionType == HistoryActionType.roomCardUpdated;
        case 'All':
        default:
          return true;
      }
    }).toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    List<dynamic> tempList = [];

    final todayItems = filteredLogs.where((i) {
      final d = i.timestamp;
      return d.year == today.year && d.month == today.month && d.day == today.day;
    }).toList();

    if (todayItems.isNotEmpty) {
      tempList.add("Today");
      tempList.addAll(todayItems);
    }
    final yesterdayItems = filteredLogs.where((i) {
      final d = i.timestamp;
      return d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day;
    }).toList();

    if (yesterdayItems.isNotEmpty) {
      tempList.add("Yesterday");
      tempList.addAll(yesterdayItems);
    }

    final olderItems = filteredLogs.where((i) {
      final d = i.timestamp;
      final dateOnly = DateTime(d.year, d.month, d.day);
      return dateOnly.isBefore(yesterday);
    }).toList();

    if (olderItems.isNotEmpty) {
      tempList.add("Older");
      tempList.addAll(olderItems);
    }

    if (tempList.isEmpty) {
      tempList.add("EMPTY_STATE");
    }

    setState(() {
      _displayList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hint: 'Search History...',
                    icon: Icons.search,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChipButton(
                      label: filter,
                      isSelected: _selectedFilter == filter,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        _refreshData(); 
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _displayList.length,
                itemBuilder: (context, index) {
                  final item = _displayList[index];


                  if (item is String) {
                    if (item == "EMPTY_STATE") {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: Text('No history found')),
                      );
                    }
                    return HistorySectionHeader(title: item);
                  }


                  if (item is RoomHistory) {
                    return HistoryItemCard(item: item);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


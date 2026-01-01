import 'package:flutter/material.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/custom_textfield.dart';
import 'package:myapp/ui/widgets/filter_chip_button.dart';
import 'package:myapp/ui/widgets/service_item.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Payment', 'Services', 'Rooms'];
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      id: '1',
      type: HistoryType.payment,
      title: 'Payment For Room 201',
      subtitle: 'Amount: 250\$',
      dateTime: DateTime.now(),
      icon: Icons.money,
      iconColor: Colors.green,
    ),
    HistoryItem(
      id: '2',
      type: HistoryType.service,
      title: 'Laundry Service Completed',
      subtitle: 'For Room 201',
      dateTime: DateTime.now(),
      icon: Icons.local_laundry_service,
      iconColor: Colors.orange,
    ),
    HistoryItem(
      id: '3',
      type: HistoryType.room,
      title: 'Cleaning Room',
      subtitle: 'Room 201',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.cleaning_services_outlined,
      iconColor: Colors.green,
    ),
    HistoryItem(
      id: '4',
      type: HistoryType.service,
      title: 'WIFI Service',
      subtitle: 'Room 201',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.wifi,
      iconColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final todayItems = _historyItems.where(_isToday).toList();
    final yesterdayItems = _historyItems.where(_isYesterday).toList();

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
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  if (todayItems.isNotEmpty) ...[
                    _buildSectionHeader('Today'),
                    ...todayItems.map(_buildHistoryItem),
                  ],
                  if (yesterdayItems.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildSectionHeader('Yesterday'),
                    ...yesterdayItems.map(_buildHistoryItem),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    return _buildHistoryCard(
      icon: item.icon,
      iconColor: item.iconColor,
      title: item.title,
      subtitle: item.subtitle,
      time: _formatTime(item.dateTime),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ServiceItem(
        icon: icon,
        iconColor: iconColor,
        name: title,
        description: subtitle,
        price: '',
        dateTime: time,
      ),
    );
  }

  bool _isToday(HistoryItem item) {
    final now = DateTime.now();
    return item.dateTime.year == now.year &&
        item.dateTime.month == now.month &&
        item.dateTime.day == now.day;
  }

  bool _isYesterday(HistoryItem item) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return item.dateTime.year == yesterday.year &&
        item.dateTime.month == yesterday.month &&
        item.dateTime.day == yesterday.day;
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

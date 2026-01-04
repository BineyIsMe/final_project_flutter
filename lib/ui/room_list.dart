import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/room.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/roomListWidgets/emptyRoomState.dart';
import 'package:myapp/ui/widgets/roomListWidgets/roomFilterChip.dart';
import 'package:myapp/ui/widgets/roomListWidgets/room_rental_card.dart';
import 'widgets/room_card.dart';
import 'widgets/buildSectionTitle.dart';
import 'tenant_form.dart';
import 'room_details_page.dart';
import 'add_tenant_to_room.dart';


class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<dynamic> _uiDisplayList = [];

  @override
  void initState() {
    super.initState();
    _calculateDisplayList();
  }

  Future<void> _refreshList() async {
    _calculateDisplayList();
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _calculateDisplayList();
  }

  void _onFilterChanged(String value) {
    _selectedFilter = value;
    _calculateDisplayList();
  }

  void _calculateDisplayList() {
    final query = _searchQuery.toLowerCase();
    
    final allRentals = List<RentalService>.from(MockData.rentalServices);
    final allRooms = List<Room>.from(MockData.rooms);

    final occupied = allRentals.where((r) {
      if (r.room.status != Status.active) return false;
      return !r.isLate && r.daysUntilExpiry > 30;
    }).where((r) => _matchesSearch(r.room.roomNumber, r.tenant.name, query)).toList();

    final expiring = allRentals.where((r) {
      if (r.room.status != Status.active) return false;
      return !r.isLate && r.daysUntilExpiry >= 0 && r.daysUntilExpiry <= 30;
    }).where((r) => _matchesSearch(r.room.roomNumber, r.tenant.name, query)).toList();

    final late = allRentals.where((r) {
      if (r.room.status != Status.active && r.room.status != Status.expired) return false;
      return r.isLate;
    }).where((r) => _matchesSearch(r.room.roomNumber, r.tenant.name, query)).toList();

    final vacant = allRooms.where((r) {
      return r.status == Status.available || r.status == Status.available;
    }).where((r) => _matchesSearch(r.roomNumber, 'Available', query)).toList();

    final List<dynamic> newList = [];

    if ((_selectedFilter == 'All' || _selectedFilter == 'Occupied') && occupied.isNotEmpty) {
      newList.add("HEADER:Occupied");
      newList.addAll(occupied);
    }
    if ((_selectedFilter == 'All' || _selectedFilter == 'Vacant') && vacant.isNotEmpty) {
      newList.add("HEADER:Vacant");
      newList.addAll(vacant);
    }
    if ((_selectedFilter == 'All' || _selectedFilter == 'Expire soon') && expiring.isNotEmpty) {
      newList.add("HEADER:Expire Soon");
      newList.addAll(expiring);
    }
    if (_selectedFilter == 'All' && late.isNotEmpty) {
      newList.add("HEADER:Late");
      newList.addAll(late);
    }
    setState(() {
      _uiDisplayList = newList;
    });
  }

  bool _matchesSearch(String roomNum, String name, String query) {
    if (query.isEmpty) return true;
    return roomNum.toLowerCase().contains(query) || name.toLowerCase().contains(query);
  }
  Future<void> _navigateToDetail(RentalService rental) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => RoomDetailsPage(rentalService: rental)),
    );
    _refreshList();
  }

  Future<void> _navigateToCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => const TenantForm()),
    );
    _refreshList();
  }

  Future<void> _navigateToAddTenantToRoom(String roomNumber) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => AddTenantToRoom(roomNumber: roomNumber)),
    );
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Rooms', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(color: Color(0xFF81B4A1), shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _navigateToCreate,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by Room or Tenant',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChipItem('All'),
                    const SizedBox(width: 8),
                    _buildChipItem('Occupied'),
                    const SizedBox(width: 8),
                    _buildChipItem('Vacant'),
                    const SizedBox(width: 8),
                    _buildChipItem('Expire soon'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _uiDisplayList.isEmpty 
                ? EmptyRoomState(onAddRoom: _navigateToCreate)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _uiDisplayList.length,
                    itemBuilder: (context, index) {
                      final item = _uiDisplayList[index];

                      if (item is String && item.startsWith("HEADER:")) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SectionTitle(title: item.substring(7)),
                        );
                      }


                      if (item is RentalService) {

                        return RoomRentalCard(
                          item: item,
                          onTap: () => _navigateToDetail(item),
                        );
                      }
                      if (item is Room) {
                        return RoomCard(
                          roomNumber: 'Room ${item.roomNumber}',
                          tenantName: 'Available',
                          contractDuration: 'No Tenant',
                          contractPlan: '-',
                          expiryDate: '-',
                          phone: '-',
                          email: '-',
                          services: const [],
                          statusColor: Colors.blue,
                          onViewDetail: () => _navigateToAddTenantToRoom(item.roomNumber),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipItem(String label) {
    return RoomFilterChip(
      label: label, 
      isSelected: _selectedFilter == label, 
      onSelected: (_) => _onFilterChanged(label),
    );
  }
}
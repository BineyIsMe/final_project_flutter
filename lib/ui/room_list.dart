import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/enum.dart';
import 'widgets/room_card.dart';
import 'widgets/buildSectionTitle.dart';
import 'tenant_form.dart';


class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; 

  List<RentalService> get occupiedRooms {
    return MockData.rentalServices.where((rental) {
      if (rental.room.status != Status.active) return false;
      final leaseEndDate = rental.tenant.leaseEndDate;
      
      final daysUntilExpiry = leaseEndDate.difference(DateTime.now()).inDays;
      return daysUntilExpiry > 30; 
    }).toList();
  }

  List<RentalService> get expiringSoonRooms {
    return MockData.rentalServices.where((rental) {
      if (rental.room.status != Status.active) return false;
      final leaseEndDate = rental.tenant.leaseEndDate;
      final daysUntilExpiry = leaseEndDate.difference(DateTime.now()).inDays;
      return daysUntilExpiry > 0 && daysUntilExpiry <= 30; 
    }).toList();
  }

  List<RentalService> get lateRooms {
    return MockData.rentalServices.where((rental) {
      final leaseEndDate = rental.tenant.leaseEndDate;
      final daysUntilExpiry = leaseEndDate.difference(DateTime.now()).inDays;
      return daysUntilExpiry < 0; 
    }).toList();
  }

  List<dynamic> get vacantRooms {
    final rentedRoomIds = MockData.rentalServices.map((r) => r.room.roomId).toSet();
    return MockData.rooms.where((room) => 
      !rentedRoomIds.contains(room.roomId) && (room.status == Status.available)
    ).toList();
  }

  bool _matchesSearch(String roomNumber, String tenantName) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    return roomNumber.toLowerCase().contains(query) || 
           tenantName.toLowerCase().contains(query);
  }

  List<RentalService> get _filteredOccupiedRooms {
    return occupiedRooms.where((rental) => 
      _matchesSearch(rental.room.roomNumber, rental.tenant.name)
    ).toList();
  }

  List<RentalService> get _filteredExpiringSoonRooms {
    return expiringSoonRooms.where((rental) => 
      _matchesSearch(rental.room.roomNumber, rental.tenant.name)
    ).toList();
  }

  List<RentalService> get _filteredLateRooms {
    return lateRooms.where((rental) => 
      _matchesSearch(rental.room.roomNumber, rental.tenant.name)
    ).toList();
  }

  List<dynamic> get _filteredVacantRooms {
    return vacantRooms.where((room) => 
      _matchesSearch(room.roomNumber, 'Available')
    ).toList();
  }

  bool get _hasNoRooms {
    if (_selectedFilter == 'All') {
      return _filteredOccupiedRooms.isEmpty && 
             _filteredVacantRooms.isEmpty && 
             _filteredExpiringSoonRooms.isEmpty && 
             _filteredLateRooms.isEmpty;
    } else if (_selectedFilter == 'Occupied') {
      return _filteredOccupiedRooms.isEmpty;
    } else if (_selectedFilter == 'Vacant') {
      return _filteredVacantRooms.isEmpty;
    } else if (_selectedFilter == 'Expire soon') {
      return _filteredExpiringSoonRooms.isEmpty;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rooms',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF81B4A1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TenantForm(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Room or Tenant',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Occupied'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Vacant'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Expire soon'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

          
            Expanded(
              child: _hasNoRooms 
                ? _buildEmptyState() 
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Occupied Section
                    if ((_selectedFilter == 'All' || _selectedFilter == 'Occupied') && _filteredOccupiedRooms.isNotEmpty) ...[
                      SectionTitle(title: 'Occupied'),
                      const SizedBox(height: 12),
                      ..._filteredOccupiedRooms.map((rental) => RoomCard(
                        roomNumber: 'Room ${rental.room.roomNumber}',
                        tenantName: rental.tenant.name,
                        contractDuration: _formatDaysLeft(rental.tenant.leaseEndDate),
                        contractPlan: _formatContractPlan(rental.tenant.paymentPlan),
                        expiryDate: _formatDate(rental.tenant.leaseEndDate),
                        phone: rental.tenant.phone,
                        email: rental.tenant.contactInfo ?? '',
                        services: rental.services.map((s) => s.serviceType.name).toList(),
                        statusColor: Colors.green,
                      )),
                      const SizedBox(height: 24),
                    ],
                    
                    // Vacant Section
                    if ((_selectedFilter == 'All' || _selectedFilter == 'Vacant') && _filteredVacantRooms.isNotEmpty) ...[
                      SectionTitle(title: 'Vacant'),
                      const SizedBox(height: 12),
                      ..._filteredVacantRooms.map((room) => RoomCard(
                        roomNumber: 'Room ${room.roomNumber}',
                        tenantName: 'Available',
                        contractDuration: 'No Tenant',
                        contractPlan: '-',
                        expiryDate: '-',
                        phone: '-',
                        email: '-',
                        services: [],
                        statusColor: Colors.blue,
                      )),
                      const SizedBox(height: 24),
                    ],
                    
                    // Expire Soon Section
                    if ((_selectedFilter == 'All' || _selectedFilter == 'Expire soon') && _filteredExpiringSoonRooms.isNotEmpty) ...[
                      SectionTitle(title: 'Expire Soon'),
                      const SizedBox(height: 12),
                      ..._filteredExpiringSoonRooms.map((rental) => RoomCard(
                        roomNumber: 'Room ${rental.room.roomNumber}',
                        tenantName: rental.tenant.name,
                        contractDuration: _formatDaysLeft(rental.tenant.leaseEndDate),
                        contractPlan: _formatContractPlan(rental.tenant.paymentPlan),
                        expiryDate: _formatDate(rental.tenant.leaseEndDate),
                        phone: rental.tenant.phone,
                        email: rental.tenant.contactInfo ?? '',
                        services: rental.services.map((s) => s.serviceType.name).toList(),
                        statusColor: Colors.orange,
                      )),
                      const SizedBox(height: 24),
                    ],
                    
                    // Late Section
                    if ((_selectedFilter == 'All') && _filteredLateRooms.isNotEmpty) ...[
                      SectionTitle(title: 'Late'),
                      const SizedBox(height: 12),
                      ..._filteredLateRooms.map((rental) => RoomCard(
                        roomNumber: 'Room ${rental.room.roomNumber}',
                        tenantName: rental.tenant.name,
                        contractDuration: _formatDaysLeft(rental.tenant.leaseEndDate),
                        contractPlan: _formatContractPlan(rental.tenant.paymentPlan),
                        expiryDate: _formatDate(rental.tenant.leaseEndDate),
                        phone: rental.tenant.phone,
                        email: rental.tenant.contactInfo ?? '',
                        services: rental.services.map((s) => s.serviceType.name).toList(),
                        statusColor: Colors.red,
                        lateWarning: 'Late ${_daysLate(rental.tenant.leaseEndDate)} Days',
                      )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.door_front_door_outlined,
              size: 60,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Rooms Available',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'lalallallallallalallallalallallalla\nlalla,lalals',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TenantForm(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF81B4A1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Add New Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF81B4A1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF81B4A1) : Colors.transparent,
        ),
      ),
    );
  }



  String _formatDaysLeft(DateTime? endDate) {
    if (endDate == null) return 'N/A';
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    if (daysLeft < 0) return 'Expired';
    if (daysLeft < 30) return '$daysLeft Days Left';
    final monthsLeft = (daysLeft / 30).round();
    return '$monthsLeft ${monthsLeft == 1 ? 'Month' : 'Months'} Left';
  }

  int _daysLate(DateTime? endDate) {
    if (endDate == null) return 0;
    return DateTime.now().difference(endDate).inDays.abs();
  }

 


  String _formatContractPlan(PaymentPlan plan) {
    switch (plan) {
      case PaymentPlan.oneWeek:
        return '1 week';
      case PaymentPlan.twoWeeks:
        return '2 Weeks';
      case PaymentPlan.oneMonth:
        return '1 Month';
      case PaymentPlan.threeMonths:
        return '3 Months';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }


}
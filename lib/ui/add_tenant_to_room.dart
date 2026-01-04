import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/Services.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/service_checkbox_item.dart';

class AddTenantToRoom extends StatefulWidget {
  final String? roomNumber;

  const AddTenantToRoom({super.key, this.roomNumber});

  @override
  State<AddTenantToRoom> createState() => _AddTenantToRoomState();
}

class _AddTenantToRoomState extends State<AddTenantToRoom> {
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedTenantId;
  String? _selectedTenantName;

  bool _isElectricitySelected = false;
  bool _isWaterSelected = false;
  bool _isTrashSelected = false;
  bool _isWifiSelected = false;
  bool _isParkingSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.roomNumber != null) {
      _roomNumberController.text = widget.roomNumber!;
    }
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleAddTenant() {
    final roomInput = _roomNumberController.text.trim();
    if (_selectedTenantId == null || roomInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a tenant and enter room number'),
        ),
      );
      return;
    }

    try {
      final room = MockData.rooms.firstWhere(
        (r) => r.roomNumber.toLowerCase() == roomInput.toLowerCase(),
      );

      if (room.status == Status.active) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room is already occupied (Active)')),
        );
        return;
      }

      room.changeStatus(Status.active);
      if (_notesController.text.isNotEmpty) {
        room.updateNotes(_notesController.text);
      }

      List<RoomService> selectedServices = [];
      void addSvc(ServiceType type) {
        selectedServices.add(
          RoomService(
            roomId: room.roomId,
            serviceType: type,
            status: ServiceStatus.on,
          ),
        );
      }

      if (_isElectricitySelected) addSvc(ServiceType.electricity);
      if (_isWaterSelected) addSvc(ServiceType.water);
      if (_isTrashSelected) addSvc(ServiceType.rubbish);
      if (_isWifiSelected) addSvc(ServiceType.wifi);
      if (_isParkingSelected) addSvc(ServiceType.laundry);

      final existingTenant = MockData.tenants.firstWhere(
        (t) => t.tenantId == _selectedTenantId,
      );

      final assignedTenant = existingTenant.copyWith(roomId: room.roomId);

      final index = MockData.tenants.indexWhere(
        (t) => t.tenantId == existingTenant.tenantId,
      );
      if (index != -1) {
        MockData.tenants[index] = assignedTenant;
      }

      final newRental = RentalService(
        room: room,
        tenant: assignedTenant,
        services: selectedServices,
      );

      MockData.rentalServices.add(newRental);
      MockData().sync();

      RoomHistory.createHistory(
        room.roomId,
        HistoryActionType.newTenantAdded,
        "Tenant ${assignedTenant.name} assigned to room ${room.roomNumber}",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully added ${assignedTenant.name} to Room $roomInput',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room "$roomInput" not found in database')),
      );
    }
  }

  List<Tenant> _getAvailableTenants() {
    final occupiedTenantIds = MockData.rentalServices
        .map((r) => r.tenant.tenantId)
        .toSet();
    return MockData.tenants
        .where((t) => !occupiedTenantIds.contains(t.tenantId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableTenants = _getAvailableTenants();

    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Available Room',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tenant Name',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              availableTenants.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "No available tenants. Please add a new tenant first.",
                      ),
                    )
                  : CustomDropdown(
                      value: _selectedTenantName,
                      hint: 'Select Available Tenant',
                      icon: Icons.person_outline,
                      items: availableTenants
                          .map(
                            (tenant) => DropdownMenuItem(
                              value: tenant.name,
                              child: Text(tenant.name),
                              onTap: () {
                                setState(() {
                                  _selectedTenantId = tenant.tenantId;
                                });
                              },
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTenantName = value;
                        });
                      },
                    ),

              const SizedBox(height: 20),
              const Text(
                'Room number',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _roomNumberController,
                hint: 'Room number',
                icon: Icons.door_front_door_outlined,
              ),
              const SizedBox(height: 30),
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ServiceCheckboxItem(
                      isSelected: _isElectricitySelected,
                      onChanged: (value) {
                        setState(() {
                          _isElectricitySelected = value!;
                        });
                      },
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.amber,
                      serviceName: 'Electricity',
                      description: 'Power supply',
                      price: '\$50/month',
                      dateTime: 'Date/time',
                    ),
                    ServiceCheckboxItem(
                      isSelected: _isWaterSelected,
                      onChanged: (value) {
                        setState(() {
                          _isWaterSelected = value!;
                        });
                      },
                      icon: Icons.water_drop_outlined,
                      iconColor: Colors.blue,
                      serviceName: 'Water',
                      description: 'Water supply',
                      price: '\$30/month',
                      dateTime: 'Date/time',
                    ),
                    ServiceCheckboxItem(
                      isSelected: _isTrashSelected,
                      onChanged: (value) {
                        setState(() {
                          _isTrashSelected = value!;
                        });
                      },
                      icon: Icons.delete_outline,
                      iconColor: Colors.grey,
                      serviceName: 'Trash',
                      description: 'Waste collection',
                      price: '\$10/month',
                      dateTime: 'Date/time',
                    ),
                    ServiceCheckboxItem(
                      isSelected: _isWifiSelected,
                      onChanged: (value) {
                        setState(() {
                          _isWifiSelected = value!;
                        });
                      },
                      icon: Icons.wifi,
                      iconColor: Colors.green,
                      serviceName: 'WiFi',
                      description: 'Internet access',
                      price: '\$40/month',
                      dateTime: 'Date/time',
                    ),
                    ServiceCheckboxItem(
                      isSelected: _isParkingSelected,
                      onChanged: (value) {
                        setState(() {
                          _isParkingSelected = value!;
                        });
                      },
                      icon: Icons.local_parking_outlined,
                      iconColor: Colors.grey,
                      serviceName: 'Parking',
                      description: 'Parking space',
                      price: '\$20/month',
                      dateTime: 'Date/time',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _notesController,
                hint: 'Text',
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Add tenant to Available Room',
                onPressed: _handleAddTenant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

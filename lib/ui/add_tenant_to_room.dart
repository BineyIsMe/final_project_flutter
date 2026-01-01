import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/service_checkbox_item.dart';

class AddTenantToRoom extends StatefulWidget {
  const AddTenantToRoom({super.key});

  @override
  State<AddTenantToRoom> createState() => _AddTenantToRoomState();
}

class _AddTenantToRoomState extends State<AddTenantToRoom> {
 
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
 
  String? _selectedTenant;
  
  
  bool _isElectricitySelected = false;
  bool _isWaterSelected = false;
  bool _isTrashSelected = false;
  bool _isWifiSelected = false;
  bool _isParkingSelected = false;

  @override
  void dispose() {
    _roomNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              CustomDropdown(
                value: _selectedTenant,
                hint: 'John Doe',
                icon: Icons.person_outline,
                items: MockData.rentalServices
                    .map((rental) => rental.tenant.name)
                    .toSet()
                    .map((name) => DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTenant = value;
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
                onPressed: () {
                  // Print to console for test 
                  print('Tenant: $_selectedTenant');
                  print('Room: ${_roomNumberController.text}');
                  print('Notes: ${_notesController.text}');
                  print('Electricity: $_isElectricitySelected');
                  print('Water: $_isWaterSelected');
                  print('Trash: $_isTrashSelected');
                  print('WiFi: $_isWifiSelected');
                  print('Parking: $_isParkingSelected');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

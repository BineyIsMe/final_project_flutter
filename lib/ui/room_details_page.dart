import 'package:flutter/material.dart';
import 'widgets/info_row.dart';
import 'widgets/service_item.dart';
import 'widgets/action_button.dart';
import 'widgets/custom_textfield.dart';

class RoomDetailsPage extends StatefulWidget {
  const RoomDetailsPage({super.key});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomController.text = 'E.g 110';
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Room XXX Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Edit action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+1(xxx)xxx-xxxx',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'NhatS@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Contract Info
            const InfoRow(label: 'Contract: 12months', value: 'Lease End'),
            const InfoRow(label: 'Plan: 6months', value: 'Date/time'),
            
            const SizedBox(height: 20),
            
            // Notes Section
             CustomTextField(
              controller: _notesController,
              hint: 'Notes',
              maxLines: 4,
              ),            
            const SizedBox(height: 24),
            
            // Room Section
            const SizedBox(height: 20),
            const Text(
              'Room',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _roomController,
              hint: 'E.g 110',
              icon: Icons.meeting_room_outlined,
            ),
            
            const SizedBox(height: 24),
            
            // Service Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF81B4A1), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ServiceItem(
                    icon: Icons.flash_on,
                    name: 'Electricity',
                    description: 'Description',
                    price: 'Price',
                    dateTime: 'Date/time',
                    iconColor: Colors.yellow[700]!,
                  ),
                  const Divider(),
                  
                  ServiceItem(
                    icon: Icons.water_drop,
                    name: 'Water',
                    description: 'Description',
                    price: 'Price',
                    dateTime: 'Date/time',
                    iconColor: Colors.blue,
                  ),
                  const Divider(),
                  
                  ServiceItem(
                    icon: Icons.delete_outline,
                    name: 'Rubbish',
                    description: 'Description',
                    price: 'Price',
                    dateTime: 'Date/time',
                    iconColor: Colors.grey,
                  ),
                  const Divider(),
                  
                  ServiceItem(
                    icon: Icons.local_laundry_service,
                    name: 'Laundry',
                    description: 'Description',
                    price: 'Price',
                    dateTime: 'Date/time',
                    iconColor: Colors.purple,
                  ),
                  const Divider(),
                  
                  ServiceItem(
                    icon: Icons.wifi,
                    name: 'WiFi',
                    description: 'Description',
                    price: 'Price',
                    dateTime: 'Date/time',
                    iconColor: Colors.green,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Actions Section
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        icon: Icons.attach_money,
                        label: 'Add Payment',
                        iconColor: Colors.green,
                        onPressed: () {
                          // Add payment action not implemented yet
                        },
                      ),
                      ActionButton(
                        icon: Icons.refresh,
                        label: 'Update Service',
                        iconColor: Colors.green,
                        onPressed: () {
                          // Update service action not implemented yet
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
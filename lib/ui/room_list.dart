import 'package:flutter/material.dart';
import 'widgets/room_card.dart';


class RoomListPage extends StatelessWidget {
  const RoomListPage({super.key});

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
                // Navigate to add room not implemented yet
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Occupied'),
              const SizedBox(height: 12),
              RoomCard(
                roomNumber: 'Room 101',
                tenantName: 'Evelyn Reed',
                contractDuration: '6 Months Left',
                contractPlan: '2 Weeks',
                expiryDate: '15 Aug 2024',
                phone: '(856) 123-4567',
                email: 'evelyn.reed@example.com',
                services: ['Wi-Fi', 'Laundry'],
                statusColor: Colors.green,
              ),
              RoomCard(
                roomNumber: 'Room 102',
                tenantName: 'Marcus Jor',
                contractDuration: '3 Months Left',
                contractPlan: '1 Month',
                expiryDate: '15 Aug 2024',
                phone: '(856) 123-4567',
                email: 'marcus.jor@example.com',
                services: ['Wi-Fi', 'Laundry'],
                statusColor: Colors.green,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Expiring Soon'),
              const SizedBox(height: 12),
              RoomCard(
                roomNumber: 'Room 102',
                tenantName: 'Marcus Jor',
                contractDuration: '2 Weeks Left',
                contractPlan: '1 Month',
                expiryDate: '15 Aug 2024',
                phone: '(856) 123-4567',
                email: 'marcus.jor@example.com',
                services: ['Wi-Fi', 'Laundry'],
                statusColor: Colors.orange,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Late'),
              const SizedBox(height: 12),
              RoomCard(
                roomNumber: 'Room 101',
                tenantName: 'Evelyn Reed',
                contractDuration: '6 Months Left',
                contractPlan: '2 Weeks',
                expiryDate: '15 Aug 2024',
                phone: '(856) 123-4567',
                email: 'evelyn.reed@example.com',
                services: ['Wi-Fi', 'Laundry'],
                statusColor: Colors.red,
                lateWarning: 'Late 10 Days',
              ),
              RoomCard(
                roomNumber: 'Room 102',
                tenantName: 'Marcus Jor',
                contractDuration: '3 Months Left',
                contractPlan: '1 Month',
                expiryDate: '15 Aug 2024',
                phone: '(856) 123-4567',
                email: 'marcus.jor@example.com',
                services: ['Wi-Fi', 'Laundry'],
                statusColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
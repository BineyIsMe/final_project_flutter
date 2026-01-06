import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_textfield.dart';

class RoomInputForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController roomNumberController;
  final TextEditingController rentFeeController;
  final TextEditingController notesController;
  final VoidCallback onSave;

  const RoomInputForm({
    super.key,
    required this.formKey,
    required this.roomNumberController,
    required this.rentFeeController,
    required this.notesController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Room Number',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: roomNumberController,
            hint: 'E.g 101',
            icon: Icons.meeting_room_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Room number is required';
              }
              final existingRoom = MockData.rooms.where(
                (r) => r.roomNumber.toLowerCase() == value.trim().toLowerCase(),
              );
              if (existingRoom.isNotEmpty) {
                return 'Room number already exists';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          const Text(
            'Rent Fee',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: rentFeeController,
            hint: '0.00',
            icon: Icons.attach_money_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Rent fee is required';
              }
              final rentFee = double.tryParse(value.trim());
              if (rentFee == null) {
                return 'Please enter a valid number for rent fee';
              }
              if (rentFee <= 0) {
                return 'Rent fee must be greater than 0';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
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
            controller: notesController,
            hint: 'Text',
            maxLines: 4,
          ),

          const SizedBox(height: 30),
          CustomButton(text: 'Save Room', onPressed: onSave),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
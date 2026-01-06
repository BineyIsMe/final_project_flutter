import 'package:flutter/material.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/room.dart';
import 'package:myapp/ui/widgets/tenantFormWidget/roomInputForm.dart';
import 'package:myapp/ui/widgets/tenantFormWidget/tenantInputForm.dart';

class TenantForm extends StatefulWidget {
  const TenantForm({super.key});

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  bool _isAddingTenant = true;

  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tenantNotesController = TextEditingController();

  String? _selectedContractPlan;
  String? _selectedPaymentPlan;

  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _rentFeeController = TextEditingController();
  final TextEditingController _roomNotesController = TextEditingController();

  @override
  void dispose() {
    _tenantNameController.dispose();
    _contactInfoController.dispose();
    _emailController.dispose();
    _tenantNotesController.dispose();
    _roomNumberController.dispose();
    _rentFeeController.dispose();
    _roomNotesController.dispose();
    super.dispose();
  }

  String? _validateTenantForm() {
    if (_tenantNameController.text.trim().isEmpty) {
      return 'Tenant name is required';
    }
    
    if (_tenantNameController.text.trim().length < 2) {
      return 'Tenant name must be at least 2 characters';
    }

    if (_contactInfoController.text.trim().isEmpty) {
      return 'Contact info is required';
    }


    final digitsOnly = _contactInfoController.text.trim().replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 9) {
      return 'Phone number must have at least 9 digits';
    }

    
    if (_emailController.text.trim().isNotEmpty) {
      if (!_emailController.text.trim().contains('@')) {
        return 'Email must contain @ symbol';
      }
    }

    if (_selectedContractPlan == null) {
      return 'Please select a contract plan';
    }

    if (_selectedPaymentPlan == null) {
      return 'Please select a payment plan';
    }

    return null;
  }

  void _handleSaveTenant() {
    final validationError = _validateTenantForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    try {
      final contractPlan = ContractPlan.values.firstWhere(
        (e) => e.name == _selectedContractPlan,
      );
      final paymentPlan = PaymentPlan.values.firstWhere(
        (e) => e.name == _selectedPaymentPlan,
      );

      final newTenant = Tenant(
        roomId: null,
        name: _tenantNameController.text.trim(),
        phone: _contactInfoController.text.trim(),
        contactInfo: _emailController.text.trim(),
        contractPlan: contractPlan,
        paymentPlan: paymentPlan,
      );

      MockData.tenants.add(newTenant);
      MockData().sync();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${newTenant.name} created. Go to Room list to assign.',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding tenant: $e')));
    }
  }

  String? _validateRoomForm() {
    if (_roomNumberController.text.trim().isEmpty) {
      return 'Room number is required';
    }

  
    final existingRoom = MockData.rooms.where(
      (r) => r.roomNumber.toLowerCase() == _roomNumberController.text.trim().toLowerCase(),
    );
    if (existingRoom.isNotEmpty) {
      return 'Room number already exists';
    }

    if (_rentFeeController.text.trim().isEmpty) {
      return 'Rent fee is required';
    }


    final rentFee = double.tryParse(_rentFeeController.text.trim());
    if (rentFee == null) {
      return 'Please enter a valid number for rent fee';
    }

    if (rentFee <= 0) {
      return 'Rent fee must be greater than 0';
    }

    return null;
  }

  void _handleSaveRoom() {
    final validationError = _validateRoomForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    try {
      double rentFee = double.parse(_rentFeeController.text.trim());

      final room = Room.create(
        roomNumber: _roomNumberController.text.trim(),
        rentFee: rentFee,
        notes: _roomNotesController.text.trim().isEmpty
            ? null
            : _roomNotesController.text.trim(),
      );

      room.changeStatus(Status.available);

      MockData.rooms.add(room);
      MockData().sync();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Room added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding room: $e')));
    }
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
        title: Text(
          _isAddingTenant ? 'Add New Tenant' : 'New Room',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAddingTenant = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isAddingTenant
                            ? const Color(0xFF81B4A1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Add New Tenant',
                          style: TextStyle(
                            color: _isAddingTenant
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAddingTenant = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isAddingTenant
                            ? const Color(0xFF81B4A1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Add New Room',
                          style: TextStyle(
                            color: !_isAddingTenant
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child: _isAddingTenant 
              ? TenantInputForm(
                  nameController: _tenantNameController,
                  contactController: _contactInfoController,
                  emailController: _emailController,
                  notesController: _tenantNotesController,
                  selectedContractPlan: _selectedContractPlan,
                  selectedPaymentPlan: _selectedPaymentPlan,
                  onContractChanged: (v) => setState(() => _selectedContractPlan = v),
                  onPaymentChanged: (v) => setState(() => _selectedPaymentPlan = v),
                  onSave: _handleSaveTenant,
                ) 
              : RoomInputForm(
                  roomNumberController: _roomNumberController,
                  rentFeeController: _rentFeeController,
                  notesController: _roomNotesController,
                  onSave: _handleSaveRoom,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
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

  String? _selectedStatus;

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

  void _handleSaveTenant() {
    if (_tenantNameController.text.isEmpty ||
        _contactInfoController.text.isEmpty ||
        _selectedContractPlan == null ||
        _selectedPaymentPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
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
        name: _tenantNameController.text,
        phone: _contactInfoController.text,
        contactInfo: _emailController.text,
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

  void _handleSaveRoom() {
    if (_roomNumberController.text.isEmpty ||
        _rentFeeController.text.isEmpty ||
        _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      double rentFee = double.parse(_rentFeeController.text);

      final room = Room.create(
        roomNumber: _roomNumberController.text,
        rentFee: rentFee,
        notes: _roomNotesController.text.isEmpty
            ? null
            : _roomNotesController.text,
      );

      Status status = Status.values.firstWhere(
        (e) => e.name == _selectedStatus,
      );
      room.changeStatus(status);

      MockData.rooms.add(room);
      MockData().sync();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Room added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid Rent Fee format')));
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
                  selectedStatus: _selectedStatus,
                  onStatusChanged: (v) => setState(() => _selectedStatus = v),
                  onSave: _handleSaveRoom,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
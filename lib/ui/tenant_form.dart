import 'package:flutter/material.dart';
import 'package:myapp/model/enum.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

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
                    onTap: () {
                      setState(() {
                        _isAddingTenant = true;
                      });
                    },
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
                            color: _isAddingTenant ? Colors.white : Colors.grey[600],
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
                    onTap: () {
                      setState(() {
                        _isAddingTenant = false;
                      });
                    },
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
                            color: !_isAddingTenant ? Colors.white : Colors.grey[600],
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _isAddingTenant ? _buildTenantForm() : _buildRoomForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantForm() {
    return Column(
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
        CustomTextField(
          controller: _tenantNameController,
          hint: 'John Doe',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        const Text(
          'Contact Info',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _contactInfoController,
          hint: '(856)-456-7890',
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 20),
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emailController,
          hint: 'Keaklarmer.Cambodia@gmail.com',
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        const Text(
          'Contract plan',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          value: _selectedContractPlan,
          hint: 'Contract plan',
          icon: Icons.description_outlined,
          items: ContractPlan.values.map((plan) {
            String displayName;
            switch (plan) {
              case ContractPlan.threeMonths:
                displayName = '3 Months';
                break;
              case ContractPlan.sixMonths:
                displayName = '6 Months';
                break;
              case ContractPlan.oneYear:
                displayName = '1 Year';
                break;
              case ContractPlan.oneAndHalfYears:
                displayName = '1.5 Years';
                break;
              case ContractPlan.twoYears:
                displayName = '2 Years';
                break;
            }
            return DropdownMenuItem(
              value: plan.name,
              child: Text(displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedContractPlan = value;
            });
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Payment plan',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          value: _selectedPaymentPlan,
          hint: 'Payment plan',
          icon: Icons.payment_outlined,
          items: PaymentPlan.values.map((plan) {
            String displayName;
            switch (plan) {
              case PaymentPlan.oneWeek:
                displayName = '1 Week';
                break;
              case PaymentPlan.twoWeeks:
                displayName = '2 Weeks';
                break;
              case PaymentPlan.oneMonth:
                displayName = '1 Month';
                break;
              case PaymentPlan.threeMonths:
                displayName = '3 Months';
                break;
            }
            return DropdownMenuItem(
              value: plan.name,
              child: Text(displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPaymentPlan = value;
            });
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
          controller: _tenantNotesController,
          hint: 'Text',
          maxLines: 4,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Save',
          onPressed: () {
            // Handle save tenant action here but not implemented yet
          },
        ),
      ],
    );
  }

  Widget _buildRoomForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          controller: _roomNumberController,
          hint: 'John Doe',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          value: _selectedStatus,
          hint: 'Status',
          icon: Icons.info_outline,
          items: Status.values.map((status) {
            String displayName;
            switch (status) {
              case Status.active:
                displayName = 'Active';
                break;
              case Status.available:
                displayName = 'Available';
                break;
              case Status.expired:
                displayName = 'Expired';
                break;
              case Status.other:
                displayName = 'Other';
                break;
            }
            return DropdownMenuItem(
              value: status.name,
              child: Text(displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
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
          controller: _rentFeeController,
          hint: 'Keaklarmer.Cambodia@gmail.com',
          icon: Icons.attach_money_outlined,
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
          controller: _roomNotesController,
          hint: 'Text',
          maxLines: 4,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Save',
          onPressed: () {
            // Handle save room action here but not implemented yet
          },
        ),
      ],
    );
  }
}
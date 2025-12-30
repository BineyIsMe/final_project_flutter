import 'package:flutter/material.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class TenantForm extends StatefulWidget {
  const TenantForm({super.key});

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  String? _selectedContractPlan;
  String? _selectedPaymentPlan;

  @override
  void dispose() {
    _tenantNameController.dispose();
    _contactInfoController.dispose();
    _emailController.dispose();
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
          'Add New Tenant',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                      items: const [
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                      ],
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
                      items: const [
                        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                      ],
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
                      controller: _notesController,
                      hint: 'Text',
                      icon: Icons.note_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Save',
                      onPressed: () {
                        // Handle save action
                      },
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
}
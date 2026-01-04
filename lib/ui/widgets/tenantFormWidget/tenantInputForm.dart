import 'package:flutter/material.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/custom_dropdown.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_textfield.dart';

class TenantInputForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController contactController;
  final TextEditingController emailController;
  final TextEditingController notesController;
  
  final String? selectedContractPlan;
  final String? selectedPaymentPlan;
  
  final ValueChanged<String?> onContractChanged;
  final ValueChanged<String?> onPaymentChanged;
  final VoidCallback onSave;

  const TenantInputForm({
    super.key,
    required this.nameController,
    required this.contactController,
    required this.emailController,
    required this.notesController,
    required this.selectedContractPlan,
    required this.selectedPaymentPlan,
    required this.onContractChanged,
    required this.onPaymentChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
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
          controller: nameController,
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
          controller: contactController,
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
          controller: emailController,
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
          value: selectedContractPlan,
          hint: 'Contract plan',
          icon: Icons.description_outlined,
          items: ContractPlan.values.map((plan) {
            return DropdownMenuItem(
              value: plan.name,
              child: Text('${plan.durationInMonths} Months'),
            );
          }).toList(),
          onChanged: onContractChanged,
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
          value: selectedPaymentPlan,
          hint: 'Payment plan',
          icon: Icons.payment_outlined,
          items: PaymentPlan.values.map((plan) {
            final label = plan.name.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
            return DropdownMenuItem(value: plan.name, child: Text(label));
          }).toList(),
          onChanged: onPaymentChanged,
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
        CustomButton(text: 'Save Tenant', onPressed: onSave),
        const SizedBox(height: 20),
      ],
    );
  }
}
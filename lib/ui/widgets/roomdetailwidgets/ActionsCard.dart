import 'package:flutter/material.dart';
import 'package:myapp/ui/widgets/action_button.dart';

class ActionsCard extends StatelessWidget {
  final VoidCallback onPayment;
  final VoidCallback onRenew;

  const ActionsCard({
    super.key,
    required this.onPayment,
    required this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.attach_money,
                label: 'Add Payment',
                iconColor: Colors.green,
                onPressed: onPayment,
              ),
              ActionButton(
                icon: Icons.autorenew,
                label: 'Renew',
                iconColor: Colors.blue,
                onPressed: onRenew,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
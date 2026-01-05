import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/info_row.dart';

class RentalInfoCard extends StatelessWidget {
  final ContractPlan contractPlan;
  final PaymentPlan paymentPlan;
  final DateTime leaseStartDate;
  final DateTime leaseEndDate;
  final DateTime nextPaymentDue;

  const RentalInfoCard({
    super.key,
    required this.contractPlan,
    required this.paymentPlan,
    required this.leaseStartDate,
    required this.leaseEndDate,
    required this.nextPaymentDue,
  });

  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);
  String _formatPaymentPlan(PaymentPlan plan) =>
      plan.name.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
  String _formatContractPlan(ContractPlan plan) =>
      '${plan.durationInMonths} Months';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InfoRow(
              label: 'Contract: ${_formatContractPlan(contractPlan)}',
              value: 'Due ${_formatDate(leaseEndDate)}'),
          const SizedBox(height: 8),
          InfoRow(
              label: 'Pay Plan: ${_formatPaymentPlan(paymentPlan)}',
              value: 'Next Due ${_formatDate(nextPaymentDue)}'),
        ],
      ),
    );
  }
}

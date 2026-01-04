import 'package:flutter/material.dart';

import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/room_card.dart'; 

class RoomRentalCard extends StatelessWidget {
  final RentalService item;
  final VoidCallback onTap;

  const RoomRentalCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    String? lateText;
    final days = item.daysUntilExpiry; 

    if (days < 0) {
      statusColor = Colors.red;
      lateText = 'Late ${days.abs()} Days';
    } else if (days <= 30) {
      statusColor = Colors.orange;
    }

    return RoomCard(
      roomNumber: 'Room ${item.room.roomNumber}',
      tenantName: item.tenant.name,
      contractDuration: _formatDaysLeft(days),
      contractPlan: _formatContractPlan(item.tenant.paymentPlan),
      expiryDate: _formatDate(item.tenant.leaseEndDate),
      phone: item.tenant.phone,
      email: item.tenant.contactInfo ?? 'N/A',
      services: item.services
          .where((s) => s.status == ServiceStatus.on)
          .map((s) => s.serviceType.name)
          .toList(),
      statusColor: statusColor,
      lateWarning: lateText,
      onViewDetail: onTap,
    );
  }
  String _formatDaysLeft(int days) {
    if (days < 0) return 'Expired';
    if (days == 0) return 'Due Today';
    if (days < 30) return '$days Days Left';
    final months = (days / 30).round();
    return '$months ${months == 1 ? 'Month' : 'Months'} Left';
  }

  String _formatContractPlan(PaymentPlan plan) {
    switch (plan) {
      case PaymentPlan.oneWeek: return '1 Week';
      case PaymentPlan.twoWeeks: return '2 Weeks';
      case PaymentPlan.oneMonth: return '1 Month';
      case PaymentPlan.threeMonths: return '3 Months';
      default: return plan.name;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/Services.dart';
import 'package:myapp/ui/widgets/service_item.dart';
import 'package:myapp/model/enum.dart';


class ActiveServiceTile extends StatelessWidget {
  final RoomService service;

  const ActiveServiceTile({super.key, required this.service});

  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (service.serviceType) {
      case ServiceType.electricity:
        icon = Icons.flash_on;
        color = Colors.yellow[700]!;
        break;
      case ServiceType.water:
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case ServiceType.rubbish:
        icon = Icons.delete_outline;
        color = Colors.grey;
        break;
      case ServiceType.laundry:
        icon = Icons.local_laundry_service;
        color = Colors.purple;
        break;
      case ServiceType.wifi:
        icon = Icons.wifi;
        color = Colors.green;
        break;
    }

    final startDate = service.updatedAt;
    final dueDate = startDate.add(const Duration(days: 30));
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    bool isExpired = now.isAfter(dueDate);
    String dateDisplay = isExpired
        ? "Expired (${_formatDate(dueDate)})"
        : "Due: ${_formatDate(dueDate)} ($difference days left)";

    return ServiceItem(
      icon: icon,
      name: service.serviceType.name[0].toUpperCase() +
          service.serviceType.name.substring(1),
      description: isExpired ? "Disabled" : "Active",
      price: '\$${service.serviceType.fee.toStringAsFixed(2)}',
      dateTime: dateDisplay,
      iconColor: isExpired ? Colors.grey : color,
    );
  }
}

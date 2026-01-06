import 'package:flutter/material.dart';
import 'package:myapp/model/enum.dart';

class ServiceDismissibleItem extends StatelessWidget {
  final ServiceType service;
  final bool isActive;
  final VoidCallback onDismissed;

  const ServiceDismissibleItem({
    super.key,
    required this.service,
    required this.isActive,
    required this.onDismissed,
  });

  Color _getServiceColor(ServiceType type) {
    switch (type) {
      case ServiceType.electricity:
        return Colors.yellow[700]!;
      case ServiceType.water:
        return Colors.blue;
      case ServiceType.rubbish:
        return Colors.grey;
      case ServiceType.laundry:
        return Colors.purple;
      case ServiceType.wifi:
        return Colors.green;
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.electricity:
        return Icons.flash_on;
      case ServiceType.water:
        return Icons.water_drop;
      case ServiceType.rubbish:
        return Icons.delete_outline;
      case ServiceType.laundry:
        return Icons.local_laundry_service;
      case ServiceType.wifi:
        return Icons.wifi;
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = ValueKey(service);

    return Dismissible(
      key: key,
      direction: isActive
          ? DismissDirection.startToEnd
          : DismissDirection.startToEnd,
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
          isActive ? Icons.arrow_downward : Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Icon(
          isActive ? Icons.arrow_downward : Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getServiceColor(service),
              radius: 20,
              child: Icon(
                _getServiceIcon(service),
                color: Colors.white,
                
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                service.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
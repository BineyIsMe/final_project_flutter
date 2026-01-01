import 'package:flutter/material.dart';

class ServiceCheckboxItem extends StatelessWidget {
  final bool isSelected;
  final Function(bool?) onChanged;
  final IconData icon;
  final Color iconColor;
  final String serviceName;
  final String description;
  final String price;
  final String dateTime;

  const ServiceCheckboxItem({
    super.key,
    required this.isSelected,
    required this.onChanged,
    required this.icon,
    required this.iconColor,
    required this.serviceName,
    required this.description,
    required this.price,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: const Color(0xFF81B4A1),
          ),
          const SizedBox(width: 8),
          // Service icon
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          // Service details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
         
          Text(
            dateTime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

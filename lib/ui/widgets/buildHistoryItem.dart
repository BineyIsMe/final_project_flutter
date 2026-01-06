import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/service_item.dart';

class HistoryItemCard extends StatelessWidget {
  final RoomHistory item;

  const HistoryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (item.actionType) {
      case HistoryActionType.paymentAdded:
        icon = Icons.attach_money;
        iconColor = Colors.green;
        break;
      case HistoryActionType.serviceUpdated:
        icon = Icons.build;
        iconColor = Colors.orange;
        break;
      case HistoryActionType.newTenantAdded:
        icon = Icons.person_add;
        iconColor = Colors.blue;
        break;
      case HistoryActionType.roomDeadlineChanged:
        icon = Icons.timer;
        iconColor = Colors.red;
        break;
      case HistoryActionType.roomCardUpdated:
      default:
        icon = Icons.edit_note;
        iconColor = Colors.grey;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ServiceItem(
        icon: icon,
        iconColor: iconColor,
        name: _formatActionTitle(item.actionType),
        description: '${item.description} (Room ${item.roomNum})',
        price: '', 
        dateTime: _formatTime(item.timestamp),
      ),
    );
  }

  String _formatActionTitle(HistoryActionType type) {
    switch (type) {
      case HistoryActionType.paymentAdded: return 'Payment Received';
      case HistoryActionType.serviceUpdated: return 'Service Update';
      case HistoryActionType.newTenantAdded: return 'New Tenant';
      case HistoryActionType.roomDeadlineChanged: return 'Deadline Change';
      case HistoryActionType.roomCardUpdated: return 'Room Info Updated';
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat.Hm().format(dateTime);
  }
}

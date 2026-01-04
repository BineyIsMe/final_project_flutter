import 'package:flutter/material.dart';
import 'info_row.dart';

class RoomCard extends StatefulWidget {
  final String roomNumber;
  final String tenantName;
  final String contractDuration;
  final String contractPlan;
  final String expiryDate;
  final String phone;
  final String email;
  final List<String> services;
  final Color statusColor;
  final String? lateWarning;
  
  final VoidCallback? onViewDetail;

  const RoomCard({
    super.key,
    required this.roomNumber,
    required this.tenantName,
    required this.contractDuration,
    required this.contractPlan,
    required this.expiryDate,
    required this.phone,
    required this.email,
    required this.services,
    required this.statusColor,
    this.lateWarning,
    this.onViewDetail,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${widget.roomNumber} - ${widget.tenantName}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: _isExpanded ? null : Text(
              'Expires: ${widget.expiryDate}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.lateWarning != null)
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                    child: Text(widget.lateWarning!, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w600)),
                   ),
                const SizedBox(width: 8),
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(color: widget.statusColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final bool isVacant = widget.tenantName == 'Available';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          InfoRow(label: 'Contract:', value: widget.contractDuration),
          InfoRow(label: 'Plan:', value: widget.contractPlan),
          InfoRow(label: 'Expires:', value: widget.expiryDate),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onViewDetail, 
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                isVacant ? 'Add Tenant' : 'View-Detail',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    IconData icon = Icons.wifi;
    if (service.toLowerCase() == 'laundry') icon = Icons.local_laundry_service;
    else if (service.toLowerCase().contains('elec')) icon = Icons.flash_on; 
    else if (service.toLowerCase().contains('water')) icon = Icons.water_drop;

    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.grey[600]),
      label: Text(service, style: const TextStyle(fontSize: 11)),
      backgroundColor: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
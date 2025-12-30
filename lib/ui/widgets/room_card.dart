import 'package:flutter/material.dart';

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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: _isExpanded ? null : Text(
              'Expires: ${widget.expiryDate}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.lateWarning != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.lateWarning!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: widget.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          _buildInfoRow('Contract:', widget.contractDuration),
          _buildInfoRow('Plan:', widget.contractPlan),
          _buildInfoRow('', 'Expires: ${widget.expiryDate}'),
          const SizedBox(height: 12),
          const Text(
            'TENANT DETAILS',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Phone ${widget.phone}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Email: ${widget.email}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          const Text(
            'SERVICES',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.services
                .map((service) => _buildServiceChip(service))
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to detail page
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'View-Detail',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          if (label.isNotEmpty) const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    IconData icon = Icons.wifi;
    if (service.toLowerCase() == 'laundry') {
      icon = Icons.local_laundry_service;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.grey[600]),
      label: Text(
        service,
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
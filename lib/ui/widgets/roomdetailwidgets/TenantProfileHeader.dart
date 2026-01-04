import 'package:flutter/material.dart';

class TenantProfileHeader extends StatelessWidget {
  final dynamic tenant; 

  const TenantProfileHeader({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              image: tenant.imageUrl != null
                  ? DecorationImage(
                      image: ResizeImage(
                        NetworkImage(tenant.imageUrl!),
                        width: 160,
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: tenant.imageUrl == null
                ? const Icon(Icons.person_outline,
                    size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            tenant.name,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            tenant.phone,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (tenant.contactInfo != null)
            Text(
              tenant.contactInfo!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

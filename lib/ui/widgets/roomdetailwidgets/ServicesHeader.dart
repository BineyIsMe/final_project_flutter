import 'package:flutter/material.dart';

class ServicesHeader extends StatelessWidget {
  final double rentFee;
  const ServicesHeader({super.key, required this.rentFee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Active Services',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            "Rent: \$${rentFee.toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green),
          )
        ],
      ),
    );
  }
}

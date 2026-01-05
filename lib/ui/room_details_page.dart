import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/ActionsCard.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/ActiveServiceTile.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/RentalInfoCard.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/SectionHeader.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/ServicesHeader.dart';
import 'package:myapp/ui/widgets/roomdetailwidgets/TenantProfileHeader.dart';

class RoomDetailsPage extends StatefulWidget {
  final RentalService rentalService;

  const RoomDetailsPage({super.key, required this.rentalService});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  late RentalService currentRental;

  @override
  void initState() {
    super.initState();
    try {
      currentRental = MockData.rentalServices.firstWhere(
        (r) => r.rentalId == widget.rentalService.rentalId,
      );
    } catch (e) {
      currentRental = widget.rentalService;
    }
  }

  void _handlePayment() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text(
          "Mark rent as paid for ${currentRental.tenant.name}?\n\nThis will extend the due date by ${_formatPaymentPlan(currentRental.tenant.paymentPlan)}.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("No", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processPayment();
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Color(0xFF81B4A1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    Duration durationToAdd;
    switch (currentRental.tenant.paymentPlan) {
      case PaymentPlan.oneWeek:
        durationToAdd = const Duration(days: 7);
        break;
      case PaymentPlan.twoWeeks:
        durationToAdd = const Duration(days: 14);
        break;
      case PaymentPlan.oneMonth:
        durationToAdd = const Duration(days: 30);
        break;
      case PaymentPlan.threeMonths:
        durationToAdd = const Duration(days: 90);
        break;
    }

    final newDate = currentRental.tenant.leaseEndDate.add(durationToAdd);
    final paymentDate = DateTime.now();
    final newNextPaymentDue = currentRental.tenant.nextPaymentDue.add(durationToAdd);
    
    setState(() {
      final updatedTenant = currentRental.tenant.copyWith(
        leaseEndDate: newDate,
        lastPaymentDate: paymentDate,
        nextPaymentDue: newNextPaymentDue,
      );

      currentRental.updateTenantData(updatedTenant);

  
      final index = MockData.rentalServices.indexWhere(
        (r) => r.rentalId == currentRental.rentalId,
      );
      if (index != -1) {
        MockData.rentalServices[index] = currentRental;
      }

      RoomHistory.createHistory(
        currentRental.room.roomId,
        HistoryActionType.paymentAdded,
        "Rent paid. Extended to ${_formatDate(newDate)}",
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Added. Next Due: ${_formatDate(newNextPaymentDue)}'),
        backgroundColor: const Color(0xFF81B4A1),
      ),
    );
  }

  void _handleRenewContract() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Renew Contract"),
        content: Text("Extend contract for ${currentRental.tenant.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processRenewal();
            },
            child: const Text(
              "Renew",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _processRenewal() {
    final int months = currentRental.tenant.contractPlan.durationInMonths;
    final newEnd = currentRental.tenant.leaseEndDate.add(
      Duration(days: months * 30),
    );

    setState(() {
      final updatedTenant = currentRental.tenant.copyWith(leaseEndDate: newEnd);
      currentRental.updateTenantData(updatedTenant);

    
      final index = MockData.rentalServices.indexWhere(
        (r) => r.rentalId == currentRental.rentalId,
      );
      if (index != -1) {
        MockData.rentalServices[index] = currentRental;
      }

      RoomHistory.createHistory(
        currentRental.room.roomId,
        HistoryActionType.roomDeadlineChanged,
        "Contract renewed ($months m). New End: ${_formatDate(newEnd)}",
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contract Renewed. Ends: ${_formatDate(newEnd)}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatPaymentPlan(PaymentPlan plan) =>
      plan.name.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    final activeServices = currentRental.services
        .where((s) => s.status == ServiceStatus.on)
        .toList();

    const serviceStartIndex = 7;
    final servicesCount = activeServices.isEmpty ? 1 : activeServices.length;
    final totalItems = serviceStartIndex + servicesCount + 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          'Room ${currentRental.room.roomNumber}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return TenantProfileHeader(tenant: currentRental.tenant);
          }
          if (index == 1) {
            return RentalInfoCard(
              key: ValueKey('${currentRental.tenant.leaseEndDate}_${currentRental.tenant.nextPaymentDue}'),
              contractPlan: currentRental.tenant.contractPlan,
              paymentPlan: currentRental.tenant.paymentPlan,
              leaseStartDate: currentRental.tenant.leaseStartDate,
              leaseEndDate: currentRental.tenant.leaseEndDate,
              nextPaymentDue: currentRental.tenant.nextPaymentDue,
            );
          }
          if (index == 2) {
            return const SectionHeader(title: 'Notes');
          }
          if (index == 3) {
            final notes = currentRental.room.notes;
            if (notes == null || notes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No notes available',
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                notes,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            );
          }
          if (index == 4) {
            return const SectionHeader(title: 'Room Number');
          }
          if (index == 5) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.meeting_room_outlined,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currentRental.room.roomNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          if (index == 6) {
            return ServicesHeader(rentFee: currentRental.room.rentFee);
          }

          final listIndex = index - serviceStartIndex;
          if (listIndex < servicesCount) {
            if (activeServices.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "No active services",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return Column(
              children: [
                ActiveServiceTile(service: activeServices[listIndex]),
                const Divider(),
              ],
            );
          }

          return ActionsCard(
            onPayment: _handlePayment,
            onRenew: _handleRenewContract,
          );
        },
      ),
    );
  }
}

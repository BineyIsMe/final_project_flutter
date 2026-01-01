import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/Services.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/model/room.dart';
import 'package:uuid/uuid.dart';

class RentalService {
  static final uuid = Uuid();

  final String rentalId;
  Room room;
  Tenant tenant;
  List<RoomService> services;
  final DateTime createdAt;
  DateTime updatedAt;

  RentalService({
    String? rentalId,
    required this.room,
    required this.tenant,
    required this.services,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : rentalId = rentalId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  void assignTenantToRoom(
    Tenant newTenant,
    Room newRoom,
    ContractPlan contractPlan,
    PaymentPlan paymentPlan,
    DateTime startDate,
    RoomHistory historyService,
  ) {
    room = newRoom;
    tenant = newTenant;
    updatedAt = DateTime.now();
    tenant = tenant.copyWith(
      roomId: room.roomId,
      contractPlan: contractPlan,
      paymentPlan: paymentPlan,
      leaseStartDate: startDate,
      leaseEndDate: contractPlan.getLeaseEndDate(startDate: startDate),
    );
    room.changeStatus(Status.active, historyService);
    historyService.createHistory(
      room.roomId,
      HistoryActionType.newTenantAdded,
      "Rental Contract started for ${tenant.name}. Plan: ${contractPlan.name}",
    );

    print("Tenant ${tenant.name} assigned to Room ${room.roomNumber}");
  }

  void endRental(Tenant t, DateTime endDate, RoomHistory historyService) {
    if (tenant.tenantId != t.tenantId) {
      print("Can't find tenant id");
      return;
    }

    tenant.removeFromRoom(historyService);
    room.changeStatus(Status.expired, historyService);
    historyService.createHistory(
      room.roomId,
      HistoryActionType.roomDeadlineChanged,
      "Rental ended on $endDate",
    );

    updatedAt = DateTime.now();
  }

  void enableService(
    Room r,
    ServiceType serviceType,
    RoomHistory historyService,
  ) {
    final index = services.indexWhere((s) => s.serviceType == serviceType);

    if (index != -1) {
      services[index].updateService(serviceType, true, historyService);
      updatedAt = DateTime.now();
    } else {
      print("Service ${serviceType.name} not found for this room.");
    }
  }

  void disableService(
    Room r,
    ServiceType serviceType,
    RoomHistory historyService,
  ) {
    final index = services.indexWhere((s) => s.serviceType == serviceType);

    if (index != -1) {
      services[index].updateService(serviceType, false, historyService);
      updatedAt = DateTime.now();
    }
  }

  void rentDeadline(Tenant tenant) {
    final today = DateTime.now();
    final difference = tenant.leaseEndDate.difference(today).inDays;

    if (difference < 0) {
      print(
        "ALERT: Rent for ${tenant.name} was due ${difference.abs()} days ago!",
      );
    } else if (difference <= 3) {
      print("WARNING: Rent for ${tenant.name} is due in $difference days.");
    } else {
      print("STATUS: Rent is safe. Due in $difference days.");
    }
  }

  void allSevicesDeadline(Room room, Tenant tenant) {
    final now = DateTime.now();
    if (now.day > 25) {
      print(
        "REMINDER: Check meter readings for Room ${room.roomNumber}. End of month approaching.",
      );
    }
    for (var s in services) {
      if (s.status == ServiceStatus.on) {
        print("Service Active: ${s.serviceType.name} - Fee accumulating.");
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'rentalId': rentalId,
      'room': room.toMap(),
      'tenant': tenant.toMap(),
      'services': services.map((s) => s.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RentalService.fromMap(Map<String, dynamic> map) {
    return RentalService(
      rentalId: map['rentalId'],
      room: Room.fromMap(Map<String, dynamic>.from(map['room'])),
      tenant: Tenant.fromMap(Map<String, dynamic>.from(map['tenant'])),
      services: List<RoomService>.from(
        (map['services'] as List).map(
          (s) => RoomService.fromMap(Map<String, dynamic>.from(s)),
        ),
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  RentalService copyWith({
    String? rentalId,
    Room? room,
    Tenant? tenant,
    List<RoomService>? services,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RentalService(
      rentalId: rentalId ?? this.rentalId,
      room: room ?? this.room,
      tenant: tenant ?? this.tenant,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

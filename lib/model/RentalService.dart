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

  int get daysUntilExpiry {
    final now = DateTime.now();

    return tenant.leaseEndDate.difference(now).inDays;
  }

  bool get isLate {
    return daysUntilExpiry < 0;
  }
  bool get expireSoon{
    return daysUntilExpiry < 1;
  }

  void updateTenantData(Tenant updatedTenant) {
    tenant = updatedTenant;
    updatedAt = DateTime.now();
  }

  void assignTenantToRoom(
    Tenant newTenant,
    Room newRoom,
    ContractPlan contractPlan,
    PaymentPlan paymentPlan,
    DateTime startDate,
    List<RoomService> newServices,
  ) {
    room = newRoom;
    tenant = newTenant;
    services = newServices; 
    updatedAt = DateTime.now();

    tenant = tenant.copyWith(
      roomId: room.roomId,
      contractPlan: contractPlan,
      paymentPlan: paymentPlan,
      leaseStartDate: startDate,
      leaseEndDate: contractPlan.getLeaseEndDate(startDate: startDate),
    );
    
    room.changeStatus(Status.active);

    RoomHistory.createHistory(
      room.roomId,
      HistoryActionType.newTenantAdded,
      "Rental Contract started for ${tenant.name}. Plan: ${contractPlan.name}",
    );

    print("Tenant ${tenant.name} assigned to Room ${room.roomNumber}");
  }

  void endRental(Tenant t, DateTime endDate) {
    if (tenant.tenantId != t.tenantId) {
      print("Can't find tenant id");
      return;
    }

    tenant.removeFromRoom(); 
    room.changeStatus(Status.expired); 

    RoomHistory.createHistory(
      room.roomId,
      HistoryActionType.roomDeadlineChanged,
      "Rental ended on $endDate",
    );

    updatedAt = DateTime.now();
  }

  void enableService(Room r, ServiceType serviceType) {
    final index = services.indexWhere((s) => s.serviceType == serviceType);

    if (index != -1) {
      services[index].updateService(serviceType, true);
      updatedAt = DateTime.now();
    } else {
      print("Service ${serviceType.name} not found for this room.");
    }
  }

  void disableService(Room r, ServiceType serviceType) {
    final index = services.indexWhere((s) => s.serviceType == serviceType);

    if (index != -1) {
      services[index].updateService(serviceType, false);
      updatedAt = DateTime.now();
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
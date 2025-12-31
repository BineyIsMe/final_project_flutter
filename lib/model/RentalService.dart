import 'package:myapp/model/Services.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/room.dart';
import 'package:uuid/uuid.dart';

class RentalService {
  static final uuid = Uuid();

  final String rentalId;
  final Room room;
  final Tenant tenant;
  final List<RoomService> services;
  final DateTime createdAt;
  final DateTime updatedAt;

  RentalService({
    String? rentalId,
    required this.room,
    required this.tenant,
    required this.services,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : rentalId = rentalId ?? uuid.v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
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
        (map['services'] as List).map((s) => RoomService.fromMap(Map<String, dynamic>.from(s))),
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

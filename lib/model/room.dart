import 'package:myapp/model/enum.dart';
import 'package:uuid/uuid.dart';

class Room {
  static final uuid = Uuid();

  final String roomId;
  final String roomNumber;
  Status status;
  final double rentFee; 
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    String? roomId,
    required this.roomNumber,
    required this.status,
    required this.rentFee,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  }) : roomId = roomId ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomNumber': roomNumber,
      'status': status.name,
      'rentFee': rentFee,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      roomId: map['roomId'],
      roomNumber: map['roomNumber'],
      status: Status.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => Status.active,
      ),
      rentFee: (map['rentFee'] as num).toDouble(),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Room copyWith({
    String? roomId,
    String? roomNumber,
    Status? status,
    double? rentFee,
    DateTime? leaseStartDate,
    DateTime? leaseEndDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      roomId: roomId ?? this.roomId,
      roomNumber: roomNumber ?? this.roomNumber,
      status: status ?? this.status,
      rentFee: rentFee ?? this.rentFee,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

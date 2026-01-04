import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/enum.dart';
import 'package:uuid/uuid.dart';

class RoomService {
  static final _uuid = Uuid();

  final String serviceId;
  final String roomId;
  final ServiceType serviceType;
  DateTime updatedAt;
  final DateTime timestamp;
  ServiceStatus status;

  RoomService({
    String? serviceId,
    required this.roomId,
    required this.serviceType,
    ServiceStatus? status,
    DateTime? updatedAt,
    DateTime? timestamp,
  }) : serviceId = serviceId ?? _uuid.v4(),
       status = status ?? serviceType.status,
       updatedAt = updatedAt ?? DateTime.now(),
       timestamp = timestamp ?? DateTime.now();

  void updateService(ServiceType type, bool isOn) {
    if (serviceType == type) {
      final newStatus = isOn ? ServiceStatus.on : ServiceStatus.off;
      status = newStatus;
      updatedAt = DateTime.now();
      recordServiceChange(type, newStatus);
    }
  }

  void recordServiceChange(
    ServiceType serviceType,
    ServiceStatus newStatus,
  ) {
    RoomHistory.createHistory(
      roomId,
      HistoryActionType.serviceUpdated,
      "${serviceType.name.toUpperCase()} service turned ${newStatus.name}",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'roomId': roomId,
      'serviceType': serviceType.name,
      'updatedAt': updatedAt.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory RoomService.fromMap(Map<String, dynamic> map) {
    return RoomService(
      serviceId: map['serviceId'],
      roomId: map['roomId'],
      serviceType: ServiceType.values.firstWhere(
        (e) => e.name == map['serviceType'],
      ),
      updatedAt: DateTime.parse(map['updatedAt']),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
  
  RoomService copyWith({
    String? serviceId,
    String? roomId,
    ServiceType? serviceType,
    DateTime? updatedAt,
    DateTime? timestamp,
  }) {
    return RoomService(
      serviceId: serviceId ?? this.serviceId,
      roomId: roomId ?? this.roomId,
      serviceType: serviceType ?? this.serviceType,
      updatedAt: updatedAt ?? this.updatedAt,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
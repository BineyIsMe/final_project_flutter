import 'package:myapp/model/RentalService.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/room.dart';

class AppDatabase {
  List<Room> rooms;
  List<Tenant> tenants;
  List<RentalService> rentals;
  List<RoomHistory> historyLogs;

  AppDatabase({
    required this.rooms,
    required this.tenants,
    required this.rentals,
    required this.historyLogs,
  });


  factory AppDatabase.empty() {
    return AppDatabase(
      rooms: [],
      tenants: [],
      rentals: [],
      historyLogs: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': rooms.map((x) => x.toMap()).toList(),
      'tenants': tenants.map((x) => x.toMap()).toList(),
      'rentals': rentals.map((x) => x.toMap()).toList(),
      'historyLogs': historyLogs.map((x) => x.toMap()).toList(),
    };
  }

  factory AppDatabase.fromJson(Map<String, dynamic> map) {
    return AppDatabase(
      rooms: map['rooms'] != null
          ? List<Room>.from((map['rooms'] as List).map((x) => Room.fromMap(x)))
          : [],
      tenants: map['tenants'] != null
          ? List<Tenant>.from((map['tenants'] as List).map((x) => Tenant.fromMap(x)))
          : [],
      rentals: map['rentals'] != null
          ? List<RentalService>.from((map['rentals'] as List).map((x) => RentalService.fromMap(x)))
          : [],
      historyLogs: map['historyLogs'] != null
          ? List<RoomHistory>.from((map['historyLogs'] as List).map((x) => RoomHistory.fromMap(x)))
          : [],
    );
  }
}
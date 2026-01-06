import 'package:myapp/data/mockData.dart';
import 'package:myapp/model/enum.dart';
import 'package:uuid/uuid.dart';

class RoomHistory {
  static final uuid = Uuid();

  final String historyId;
  final String roomId;
  final HistoryActionType actionType;
  final String description;
  final DateTime timestamp;

  RoomHistory({
    String? historyId,
    required this.roomId,
    required this.actionType,
    required this.description,
    required this.timestamp,
  }) : historyId = historyId ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'historyId': historyId,
      'roomId': roomId,
      'actionType': actionType.name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
String get roomNum {
    try {
      final room = MockData.rooms.firstWhere((r) => r.roomId == roomId);
      return room.roomNumber;
    } catch (e) {
      return 'Unknown'; 
    }
  }

  factory RoomHistory.fromMap(Map<String, dynamic> map) {
    return RoomHistory(
      historyId: map['historyId'],
      roomId: map['roomId'],
      actionType: HistoryActionType.values.firstWhere(
        (e) => e.name == map['actionType'],
        orElse: () => HistoryActionType.serviceUpdated,
      ),
      description: map['description'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  RoomHistory copyWith({
    String? historyId,
    String? roomId,
    HistoryActionType? actionType,
    String? description,
    DateTime? timestamp,
  }) {
    return RoomHistory(
      historyId: historyId ?? this.historyId,
      roomId: roomId ?? this.roomId,
      actionType: actionType ?? this.actionType,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

static void createHistory(
    String roomId,
    HistoryActionType actionType,
    String description,
  ) {
    final newHistory = RoomHistory(
      roomId: roomId,
      actionType: actionType,
      description: description,
      timestamp: DateTime.now(),
    );
    
    MockData.historyLogs.add(newHistory);
    MockData().sync(); 
  }

  static List<RoomHistory> getRoomHistory(String roomId) {
    return MockData.historyLogs
        .where((history) => history.roomId == roomId)
        .toList();
  }
}
import 'package:myapp/model/RoomHistory.dart';
import 'package:uuid/uuid.dart';
import 'enum.dart';

class Tenant {
  static final uuid = Uuid();

  final String tenantId;
  String? roomId;
  String name;
  String phone;
  String? imageUrl;
  String? contactInfo;
  final ContractPlan contractPlan;
  final PaymentPlan paymentPlan;
  final DateTime leaseStartDate;
  final DateTime leaseEndDate;
  final DateTime createdAt;

  Tenant({
    String? tenantId,
    required this.roomId,
    required this.name,
    required this.phone,
    this.imageUrl,
    this.contactInfo,
    required this.contractPlan,
    required this.paymentPlan,
    DateTime? leaseStartDate,
    DateTime? createdAt,
  }) : tenantId = tenantId ?? uuid.v4(),
       leaseStartDate = leaseStartDate ?? DateTime.now(),
       leaseEndDate = (leaseStartDate ?? DateTime.now()).add(
         Duration(days: (contractPlan.durationInMonths * 30)),
       ),
       createdAt = createdAt ?? DateTime.now();

  void updateContact(String newPhone, String? newContactInfo) {
    phone = newPhone;
    if (newContactInfo != null) {
      contactInfo = newContactInfo;
    }
  }

  void updateImage(String newImageUrl) {
    imageUrl = newImageUrl;
  }

  void assignRoom(String newRoomId, RoomHistory historyService) {
    roomId = newRoomId;
    historyService.createHistory(
      newRoomId,
      HistoryActionType.newTenantAdded,
      "Tenant $name moved in / assigned to room.",
    );
  }

  void removeFromRoom(RoomHistory historyService) {
    if (roomId != null) {
      historyService.createHistory(
        roomId!,
        HistoryActionType.roomDeadlineChanged,
        "Tenant $name removed/moved out.",
      );
      roomId = null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'tenantId': tenantId,
      'roomId': roomId,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'contactInfo': contactInfo,
      'contractPlan': contractPlan.name,
      'paymentPlan': paymentPlan.name,
      'leaseStartDate': leaseStartDate.toIso8601String(),
      'leaseEndDate': leaseEndDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    final startDate = DateTime.parse(map['leaseStartDate']);
    final plan = ContractPlan.values.firstWhere(
      (e) => e.name == map['contractPlan'],
      orElse: () => ContractPlan.sixMonths,
    );
    final pPlan = PaymentPlan.values.firstWhere(
      (e) => e.name == map['paymentPlan'],
      orElse: () => PaymentPlan.oneMonth,
    );

    return Tenant(
      tenantId: map['tenantId'],
      roomId: map['roomId'],
      name: map['name'],
      phone: map['phone'],
      imageUrl: map['imageUrl'],
      contactInfo: map['contactInfo'],
      contractPlan: plan,
      paymentPlan: pPlan,
      leaseStartDate: startDate,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Tenant copyWith({
    String? tenantId,
    String? roomId,
    String? name,
    String? phone,
    String? imageUrl,
    String? contactInfo,
    ContractPlan? contractPlan,
    PaymentPlan? paymentPlan,
    DateTime? leaseStartDate,
    DateTime? leaseEndDate,
    DateTime? createdAt,
  }) {
    return Tenant(
      tenantId: tenantId ?? this.tenantId,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      contactInfo: contactInfo ?? this.contactInfo,
      contractPlan: contractPlan ?? this.contractPlan,
      paymentPlan: paymentPlan ?? this.paymentPlan,
      leaseStartDate: leaseStartDate ?? this.leaseStartDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

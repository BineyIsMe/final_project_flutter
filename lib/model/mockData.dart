import 'package:myapp/model/enum.dart';
import 'package:myapp/model/room.dart';
import 'package:myapp/model/Tenant.dart';
import 'package:myapp/model/Services.dart';
import 'package:myapp/model/RoomHistory.dart';
import 'package:myapp/model/RentalService.dart';

class MockData {
  static final List<Room> rooms = [
    Room(
      roomId: 'room-001',
      roomNumber: '101',
      status: Status.active,
      rentFee: 250.0,
      notes: 'Near the elevator, quiet side.',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Room(
      roomId: 'room-002',
      roomNumber: '102',
      status: Status.active,
      rentFee: 300.0,
      notes: 'Deluxe room with balcony.',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      updatedAt: DateTime.now(),
    ),
    Room(
      roomId: 'room-003',
      roomNumber: '103',
      status: Status.availble,
      rentFee: 250.0,
      notes: 'Currently under minor maintenance.',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Room(
      roomId: 'room-004',
      roomNumber: '201',
      status: Status.expired,
      rentFee: 280.0,
      notes: 'Tenant moved out yesterday.',
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  static final List<Tenant> tenants = [
    Tenant(
      tenantId: 'tenant-001',
      roomId: 'room-001',
      name: 'Sok Dara',
      phone: '012-345-678',
      contactInfo: 'Telegram: @sokdara',
      contractPlan: ContractPlan.sixMonths,
      paymentPlan: PaymentPlan.oneMonth,
      leaseStartDate: DateTime.now().subtract(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
    ),
    Tenant(
      tenantId: 'tenant-002',
      roomId: 'room-002',
      name: 'Pov Piseth',
      phone: '098-765-432',
      imageUrl: 'https://i.pravatar.cc/150?u=tenant2',
      contractPlan: ContractPlan.oneYear,
      paymentPlan: PaymentPlan.threeMonths,
      leaseStartDate: DateTime.now().subtract(const Duration(days: 120)),
      createdAt: DateTime.now().subtract(const Duration(days: 125)),
    ),
    Tenant(
      tenantId: 'tenant-003',
      roomId: 'room-004',
      name: 'Chan Vanna',
      phone: '011-222-333',
      contractPlan: ContractPlan.threeMonths,
      paymentPlan: PaymentPlan.oneMonth,
      leaseStartDate: DateTime.now().subtract(const Duration(days: 100)),
      createdAt: DateTime.now().subtract(const Duration(days: 105)),
    ),
  ];
  static final List<RoomService> roomServices = [
    RoomService(
      roomId: 'room-001',
      serviceType: ServiceType.electricity,
      updatedAt: DateTime.now(),
    ),
    RoomService(
      roomId: 'room-001',
      serviceType: ServiceType.water,
      updatedAt: DateTime.now(),
    ),
    RoomService(
      roomId: 'room-001',
      serviceType: ServiceType.wifi,
      updatedAt: DateTime.now(),
    ),
    RoomService(
      roomId: 'room-002',
      serviceType: ServiceType.electricity,
      updatedAt: DateTime.now(),
    ),
    RoomService(
      roomId: 'room-002',
      serviceType: ServiceType.rubbish,
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<RentalService> rentalServices = [
    RentalService(
      rentalId: 'rental-001',
      room: rooms[0], 
      tenant: tenants[0], 
      services: roomServices.where((s) => s.roomId == 'room-001').toList(),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    RentalService(
      rentalId: 'rental-002',
      room: rooms[1],
      tenant: tenants[1], 
      services: roomServices.where((s) => s.roomId == 'room-002').toList(),
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
  ];
  static final List<RoomHistory> historyLogs = [
    RoomHistory(
      roomId: 'room-001',
      actionType: HistoryActionType.newTenantAdded,
      description: 'Sok Dara moved in.',
      timestamp: DateTime.now().subtract(const Duration(days: 30)),
    ),
    RoomHistory(
      roomId: 'room-001',
      actionType: HistoryActionType.paymentAdded,
      description: 'Monthly rent paid.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RoomHistory(
      roomId: 'room-002',
      actionType: HistoryActionType.serviceUpdated,
      description: 'Fixed water pipe leak.',
      timestamp: DateTime.now().subtract(const Duration(days: 15)),
    ),
    RoomHistory(
      roomId: 'room-004',
      actionType: HistoryActionType.roomDeadlineChanged,
      description: 'Tenant requested extension.',
      timestamp: DateTime.now().subtract(const Duration(days: 50)),
    ),
  ];
}
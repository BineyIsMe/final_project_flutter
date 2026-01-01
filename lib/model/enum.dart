enum Status { active, expired,available,other }


enum ServiceStatus { on,off}

enum HistoryActionType {
  paymentAdded,
  serviceUpdated,
  roomDeadlineChanged,
  newTenantAdded,
  roomCardUpdated,
}

enum ContractPlan {
  threeMonths(durationInMonths: 3),
  sixMonths(durationInMonths: 6),
  oneYear(durationInMonths: 12),
  oneAndHalfYears(durationInMonths: 18),
  twoYears(durationInMonths: 24);

  final int durationInMonths;

  const ContractPlan({required this.durationInMonths});

  DateTime getLeaseEndDate({required DateTime startDate}) {
    return DateTime(startDate.year, startDate.month + durationInMonths, startDate.day);
  }
}


enum PaymentPlan {
  oneWeek,
  twoWeeks,
  oneMonth,
  threeMonths,
}

enum ServiceType {

  
  electricity(fee: 50.0, status: ServiceStatus.off),
  water(fee: 30.0, status: ServiceStatus.off),
  rubbish(fee: 10.0, status: ServiceStatus.off),
  laundry(fee: 20.0, status: ServiceStatus.off),
  wifi(fee: 15.0, status: ServiceStatus.off);
  final double fee;
  final ServiceStatus status;


  const ServiceType({required this.fee, required this.status});
}

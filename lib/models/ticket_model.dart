class TicketModel {
  final String id;
  final String transportType;
  final String operatorName;
  final String from;
  final String to;
  final String date;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String ticketClass;
  final int price;
  final int availableSeats;

  TicketModel({
    required this.id,
    required this.transportType,
    required this.operatorName,
    required this.from,
    required this.to,
    required this.date,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.ticketClass,
    required this.price,
    required this.availableSeats,
  });
}

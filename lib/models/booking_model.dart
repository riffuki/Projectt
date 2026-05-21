import 'ticket_model.dart';

class BookingModel {
  final String bookingCode;
  final TicketModel ticket;
  final String passengerName;
  final String identityNumber;
  final String phone;
  final String email;
  final String gender;
  final String paymentMethod;
  final String seatNumber;
  final String status;
  final DateTime createdAt;

  BookingModel({
    required this.bookingCode,
    required this.ticket,
    required this.passengerName,
    required this.identityNumber,
    required this.phone,
    required this.email,
    required this.gender,
    required this.paymentMethod,
    required this.seatNumber,
    required this.status,
    required this.createdAt,
  });
}

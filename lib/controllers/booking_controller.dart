import '../models/booking_model.dart';
import '../models/ticket_model.dart';

class BookingController {
  static final List<BookingModel> _bookings = [];

  static List<BookingModel> get bookings => _bookings;

  static BookingModel createBooking({
    required TicketModel ticket,
    required String passengerName,
    required String identityNumber,
    required String phone,
    required String email,
    required String gender,
    required String paymentMethod,
  }) {
    final now = DateTime.now();
    final code = 'GT${now.millisecondsSinceEpoch.toString().substring(7)}';

    final booking = BookingModel(
      bookingCode: code,
      ticket: ticket,
      passengerName: passengerName,
      identityNumber: identityNumber,
      phone: phone,
      email: email,
      gender: gender,
      paymentMethod: paymentMethod,
      seatNumber: 'A${(_bookings.length + 1).toString().padLeft(2, '0')}',
      status: 'Lunas',
      createdAt: now,
    );

    _bookings.add(booking);
    return booking;
  }
}

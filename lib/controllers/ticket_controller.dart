import '../data/dummy_data.dart';
import '../models/ticket_model.dart';

class TicketController {
  List<TicketModel> searchTickets({
    required String transportType,
    required String from,
    required String to,
    required String date,
    required String ticketClass,
  }) {
    return DummyData.tickets.where((ticket) {
      final sameTransport = ticket.transportType == transportType;

      final sameFrom = from.isEmpty
          ? true
          : ticket.from.toLowerCase().contains(from.toLowerCase());

      final sameTo = to.isEmpty
          ? true
          : ticket.to.toLowerCase().contains(to.toLowerCase());

      final sameDate = date.isEmpty ? true : ticket.date == date;

      final sameClass = ticketClass == 'Semua'
          ? true
          : ticket.ticketClass == ticketClass;

      return sameTransport && sameFrom && sameTo && sameDate && sameClass;
    }).toList();
  }

  List<TicketModel> getTicketsByTransport(String transportType) {
    return DummyData.tickets
        .where((ticket) => ticket.transportType == transportType)
        .toList();
  }
}

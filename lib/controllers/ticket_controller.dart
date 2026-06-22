import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_api_service.dart';

class TicketController {
  final TicketApiService _apiService;

  TicketController({TicketApiService? apiService})
    : _apiService = apiService ?? TicketApiService();

  Future<List<TicketModel>> searchTickets({
    required String transportType,
    required String from,
    required String to,
    required String date,
    required String ticketClass,
  }) async {
    if (_apiService.isConfigured) {
      final apiTickets = await _apiService.fetchTickets();

      return _filterTickets(
        tickets: apiTickets,
        transportType: transportType,
        from: from,
        to: to,
        date: date,
        ticketClass: ticketClass,
      );
    }

    return _filterTickets(
      tickets: DummyData.tickets,
      transportType: transportType,
      from: from,
      to: to,
      date: date,
      ticketClass: ticketClass,
    );
  }

  Future<List<TicketModel>> getAllTickets() async {
    if (_apiService.isConfigured) {
      return _apiService.fetchTickets();
    }

    return DummyData.tickets;
  }

  Future<TicketModel> getTicketById(String id) {
    return _apiService.fetchTicketById(id);
  }

  Future<TicketModel> createTicket(TicketModel ticket) {
    return _apiService.createTicket(ticket);
  }

  Future<TicketModel> updateTicket(String id, TicketModel ticket) {
    return _apiService.updateTicket(id, ticket);
  }

  Future<TicketModel> patchTicket(String id, Map<String, dynamic> data) {
    return _apiService.patchTicket(id, data);
  }

  Future<void> deleteTicket(String id) {
    return _apiService.deleteTicket(id);
  }

  List<TicketModel> _filterTickets({
    required List<TicketModel> tickets,
    required String transportType,
    required String from,
    required String to,
    required String date,
    required String ticketClass,
  }) {
    return tickets.where((ticket) {
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

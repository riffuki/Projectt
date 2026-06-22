import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../models/ticket_model.dart';

class TicketApiService extends GetConnect {
  static const String _dartDefineApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _dartDefineTicketsEndpoint = String.fromEnvironment(
    'TICKETS_ENDPOINT',
    defaultValue: '/tickets',
  );

  String get apiBaseUrl {
    if (!dotenv.isInitialized) return _dartDefineApiBaseUrl;

    final envValue = dotenv.maybeGet('API_BASE_URL', fallback: '') ?? '';
    return envValue.isNotEmpty ? envValue : _dartDefineApiBaseUrl;
  }

  String get ticketsEndpoint {
    if (!dotenv.isInitialized) return _dartDefineTicketsEndpoint;

    final envValue = dotenv.maybeGet('TICKETS_ENDPOINT', fallback: '') ?? '';
    return envValue.isNotEmpty ? envValue : _dartDefineTicketsEndpoint;
  }

  bool get isConfigured => apiBaseUrl.isNotEmpty;

  TicketApiService() {
    _configureClient();
  }

  @override
  void onInit() {
    _configureClient();
    super.onInit();
  }

  void _configureClient() {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultContentType = 'application/json';
  }

  Future<List<TicketModel>> fetchTickets() async {
    _ensureConfigured();
    if (!isConfigured) return [];

    final response = await get<dynamic>(ticketsEndpoint);

    _ensureSuccess(response, 'mengambil data tiket');
    return _parseTickets(response.body);
  }

  Future<TicketModel> fetchTicketById(String id) async {
    _ensureConfigured();

    final response = await get<dynamic>(_ticketPath(id));

    _ensureSuccess(response, 'mengambil detail tiket');
    return _parseTicket(response.body);
  }

  Future<TicketModel> createTicket(TicketModel ticket) async {
    _ensureConfigured();

    final response = await post<dynamic>(
      ticketsEndpoint,
      ticket.toJson(),
    );

    _ensureSuccess(response, 'menambah tiket');
    return _parseTicket(response.body);
  }

  Future<TicketModel> updateTicket(String id, TicketModel ticket) async {
    _ensureConfigured();

    final response = await put<dynamic>(
      _ticketPath(id),
      ticket.toJson(),
    );

    _ensureSuccess(response, 'mengubah tiket');
    return _parseTicket(response.body);
  }

  Future<TicketModel> patchTicket(String id, Map<String, dynamic> data) async {
    _ensureConfigured();

    final response = await patch<dynamic>(
      _ticketPath(id),
      data,
    );

    _ensureSuccess(response, 'mengubah sebagian data tiket');
    return _parseTicket(response.body);
  }

  Future<void> deleteTicket(String id) async {
    _ensureConfigured();

    final response = await delete<dynamic>(_ticketPath(id));

    _ensureSuccess(response, 'menghapus tiket');
  }

  String _ticketPath(String id) {
    final endpoint = ticketsEndpoint.endsWith('/')
        ? ticketsEndpoint.substring(0, ticketsEndpoint.length - 1)
        : ticketsEndpoint;

    return '$endpoint/${Uri.encodeComponent(id)}';
  }

  void _ensureConfigured() {
    _configureClient();

    if (!isConfigured) {
      throw Exception('API_BASE_URL belum diatur');
    }
  }

  void _ensureSuccess(Response<dynamic> response, String action) {
    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Gagal $action');
    }
  }

  List<TicketModel> _parseTickets(dynamic body) {
    final rawTickets = switch (body) {
      List<dynamic> data => data,
      {'data': List<dynamic> data} => data,
      {'tickets': List<dynamic> data} => data,
      _ => <dynamic>[],
    };

    return rawTickets
        .whereType<Map>()
        .map((json) => TicketModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  TicketModel _parseTicket(dynamic body) {
    final rawTicket = switch (body) {
      Map<String, dynamic> data when data['data'] is Map => data['data'],
      Map<String, dynamic> data when data['ticket'] is Map => data['ticket'],
      Map<String, dynamic> data => data,
      _ => null,
    };

    if (rawTicket is! Map) {
      throw Exception('Format data tiket dari API tidak sesuai');
    }

    return TicketModel.fromJson(Map<String, dynamic>.from(rawTicket));
  }
}

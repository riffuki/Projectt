import 'package:flutter/material.dart';
import '../controllers/ticket_controller.dart';
import '../models/ticket_model.dart';
import '../utils/format_currency.dart';
import 'ticket_detail_view.dart';

class TicketListView extends StatelessWidget {
  final String transportType;
  final String from;
  final String to;
  final String date;
  final String passengerCount;
  final String ticketClass;

  const TicketListView({
    super.key,
    required this.transportType,
    required this.from,
    required this.to,
    required this.date,
    required this.passengerCount,
    required this.ticketClass,
  });

  @override
  Widget build(BuildContext context) {
    final ticketController = TicketController();
    final tickets = ticketController.searchTickets(
      transportType: transportType,
      from: from,
      to: to,
      date: date,
      ticketClass: ticketClass,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tiket'),
        centerTitle: true,
      ),
      body: tickets.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tiket tidak ditemukan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coba kosongkan asal, tujuan, atau tanggal agar data dummy muncul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  '$transportType tersedia',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jumlah penumpang: $passengerCount',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                ...tickets.map(
                  (ticket) => _ticketCard(
                    ticket: ticket,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketDetailView(ticket: ticket),
                        ),
                      );
                    },
                  ),
                ),
              ],
      ),
    );
  }

  Widget _ticketCard({
    required TicketModel ticket,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Icon(_ticketIcon(ticket), color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ticket.operatorName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    formatCurrency(ticket.price),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _timeInfo(
                      title: ticket.from,
                      time: ticket.departTime,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        ticket.duration,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.arrow_forward, size: 22),
                    ],
                  ),
                  Expanded(
                    child: _timeInfo(
                      title: ticket.to,
                      time: ticket.arriveTime,
                      alignRight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Chip(
                    label: Text(ticket.ticketClass),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('Sisa ${ticket.availableSeats} kursi'),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  const Text(
                    'Pilih',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _ticketIcon(TicketModel ticket) {
    if (ticket.transportType == 'Pesawat') return Icons.flight;
    if (ticket.transportType == 'Kereta') return Icons.train;
    return Icons.directions_bus;
  }

  Widget _timeInfo({
    required String title,
    required String time,
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

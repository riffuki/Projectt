import 'package:flutter/material.dart';
import '../controllers/ticket_controller.dart';
import '../widgets/ticket_card.dart';
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
                  (ticket) => TicketCard(
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
}

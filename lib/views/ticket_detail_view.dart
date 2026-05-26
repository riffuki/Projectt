import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../utils/format_currency.dart';
import 'passenger_form_view.dart';

class TicketDetailView extends StatelessWidget {
  final TicketModel ticket;

  const TicketDetailView({
    super.key,
    required this.ticket,
  });

  IconData getIcon() {
    if (ticket.transportType == 'Pesawat') return Icons.flight_takeoff;
    if (ticket.transportType == 'Kereta') return Icons.train;
    return Icons.directions_bus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tiket'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Icon(getIcon(), color: Colors.white, size: 70),
                  const SizedBox(height: 14),
                  Text(
                    ticket.operatorName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.transportType,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _detailCard(
              children: [
                _item('Rute', '${ticket.from} → ${ticket.to}'),
                _item('Tanggal', ticket.date),
                _item('Berangkat', ticket.departTime),
                _item('Tiba', ticket.arriveTime),
                _item('Durasi', ticket.duration),
                _item('Kelas', ticket.ticketClass),
                _item('Sisa Kursi', '${ticket.availableSeats} kursi'),
                _item('Harga', formatCurrency(ticket.price)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PassengerFormView(ticket: ticket),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text(
                  'Lanjut Isi Data Penumpang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

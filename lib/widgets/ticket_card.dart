import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../utils/format_currency.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  IconData getIcon() {
    if (ticket.transportType == 'Pesawat') return Icons.flight;
    if (ticket.transportType == 'Kereta') return Icons.train;
    return Icons.directions_bus;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Icon(getIcon(), color: Colors.blue),
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

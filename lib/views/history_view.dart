import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../utils/format_currency.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = BookingController.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan'),
        centerTitle: true,
      ),
      body: bookings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada pemesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tiket yang sudah dibayar akan tampil di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final ticket = booking.ticket;

                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.confirmation_number,
                                color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking.bookingCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              booking.status,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${ticket.transportType} - ${ticket.operatorName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${ticket.from} → ${ticket.to}'),
                        const SizedBox(height: 6),
                        Text('${ticket.date}, ${ticket.departTime}'),
                        const SizedBox(height: 6),
                        Text('Penumpang: ${booking.passengerName}'),
                        const SizedBox(height: 6),
                        Text(
                          formatCurrency(ticket.price),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

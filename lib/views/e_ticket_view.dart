import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/app_colors.dart';
import '../utils/format_currency.dart';
import '../widgets/custom_button.dart';
import 'dashboard_view.dart';
import 'history_view.dart';

class ETicketView extends StatelessWidget {
  final BookingModel booking;

  const ETicketView({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final ticket = booking.ticket;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ticket'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 74,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pembayaran Berhasil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kode Booking: ${booking.bookingCode}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      size: 90,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _item('Nama', booking.passengerName),
                  _item('Transportasi', ticket.transportType),
                  _item('Operator', ticket.operatorName),
                  _item('Rute', '${ticket.from} → ${ticket.to}'),
                  _item('Tanggal', ticket.date),
                  _item('Jam', '${ticket.departTime} - ${ticket.arriveTime}'),
                  _item('Kelas', ticket.ticketClass),
                  _item('Nomor Kursi', booking.seatNumber),
                  _item('Metode Bayar', booking.paymentMethod),
                  _item('Harga', formatCurrency(ticket.price)),
                  _item('Status', booking.status),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CustomButton(
              text: 'Lihat Riwayat',
              icon: Icons.history,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryView()),
                );
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Kembali ke Dashboard',
              icon: Icons.home,
              color: Colors.grey.shade800,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardView(email: 'pengguna'),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/ticket_model.dart';
import '../utils/format_currency.dart';
import '../widgets/custom_button.dart';
import 'e_ticket_view.dart';

class PaymentView extends StatefulWidget {
  final TicketModel ticket;
  final String passengerName;
  final String identityNumber;
  final String phone;
  final String email;
  final String gender;

  const PaymentView({
    super.key,
    required this.ticket,
    required this.passengerName,
    required this.identityNumber,
    required this.phone,
    required this.email,
    required this.gender,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String selectedMethod = 'Transfer Bank';

  final methods = const [
    'Transfer Bank',
    'E-Wallet',
    'QRIS',
    'Virtual Account',
  ];

  void payNow() {
    final booking = BookingController.createBooking(
      ticket: widget.ticket,
      passengerName: widget.passengerName,
      identityNumber: widget.identityNumber,
      phone: widget.phone,
      email: widget.email,
      gender: widget.gender,
      paymentMethod: selectedMethod,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ETicketView(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pemesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _item('Transportasi', ticket.transportType),
                  _item('Operator', ticket.operatorName),
                  _item('Rute', '${ticket.from} → ${ticket.to}'),
                  _item('Tanggal', ticket.date),
                  _item('Jam', '${ticket.departTime} - ${ticket.arriveTime}'),
                  _item('Penumpang', widget.passengerName),
                  const Divider(height: 28),
                  _item(
                    'Total',
                    formatCurrency(ticket.price),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ...methods.map(
              (method) => Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RadioListTile<String>(
                  value: method,
                  groupValue: selectedMethod,
                  title: Text(method),
                  secondary: const Icon(Icons.account_balance_wallet),
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value ?? 'Transfer Bank';
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Bayar Sekarang',
              icon: Icons.check_circle,
              onPressed: payNow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value, {bool isBold = false}) {
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
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              fontSize: isBold ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

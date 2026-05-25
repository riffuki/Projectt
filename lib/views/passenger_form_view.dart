import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import 'payment_view.dart';

class PassengerFormView extends StatefulWidget {
  final TicketModel ticket;

  const PassengerFormView({
    super.key,
    required this.ticket,
  });

  @override
  State<PassengerFormView> createState() => _PassengerFormViewState();
}

class _PassengerFormViewState extends State<PassengerFormView> {
  final nameController = TextEditingController();
  final identityController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String gender = 'Laki-laki';

  void nextToPayment() {
    if (nameController.text.isEmpty ||
        identityController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data penumpang wajib diisi')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentView(
          ticket: widget.ticket,
          passengerName: nameController.text,
          identityNumber: identityController.text,
          phone: phoneController.text,
          email: emailController.text,
          gender: gender,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    identityController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Penumpang'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: _inputDecoration(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama penumpang',
                icon: Icons.person,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: identityController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                label: 'Nomor Identitas',
                hint: 'KTP / NIK / Kartu Pelajar',
                icon: Icons.badge,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(
                label: 'Nomor HP',
                hint: 'Masukkan nomor HP',
                icon: Icons.phone,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                label: 'Email',
                hint: 'Masukkan email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: const Icon(Icons.wc),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value ?? 'Laki-laki';
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: nextToPayment,
                icon: const Icon(Icons.payment),
                label: const Text(
                  'Lanjut Pembayaran',
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

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

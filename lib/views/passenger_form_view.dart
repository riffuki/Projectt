import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
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
            CustomTextField(
              label: 'Nama Lengkap',
              hint: 'Masukkan nama penumpang',
              controller: nameController,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nomor Identitas',
              hint: 'KTP / NIK / Kartu Pelajar',
              controller: identityController,
              icon: Icons.badge,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nomor HP',
              hint: 'Masukkan nomor HP',
              controller: phoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hint: 'Masukkan email',
              controller: emailController,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
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
            CustomButton(
              text: 'Lanjut Pembayaran',
              icon: Icons.payment,
              onPressed: nextToPayment,
            ),
          ],
        ),
      ),
    );
  }
}

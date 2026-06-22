import 'package:flutter/material.dart';

import '../controllers/ticket_controller.dart';
import '../models/ticket_model.dart';

class TicketFormView extends StatefulWidget {
  final TicketModel? ticket;

  const TicketFormView({
    super.key,
    this.ticket,
  });

  @override
  State<TicketFormView> createState() => _TicketFormViewState();
}

class _TicketFormViewState extends State<TicketFormView> {
  final formKey = GlobalKey<FormState>();
  final ticketController = TicketController();

  late final TextEditingController operatorController;
  late final TextEditingController noKtpController;
  late final TextEditingController fromController;
  late final TextEditingController toController;
  late final TextEditingController dateController;
  late final TextEditingController departTimeController;
  late final TextEditingController arriveTimeController;
  late final TextEditingController durationController;
  late final TextEditingController priceController;
  late final TextEditingController seatsController;
  late final TextEditingController imageController;

  String selectedTransport = 'Pesawat';
  String selectedClass = 'Ekonomi';
  bool isSaving = false;

  bool get isEditing => widget.ticket != null;

  @override
  void initState() {
    super.initState();
    final ticket = widget.ticket;

    selectedTransport = ticket?.transportType ?? 'Pesawat';
    selectedClass = ticket?.ticketClass ?? 'Ekonomi';

    operatorController = TextEditingController(text: ticket?.operatorName);
    noKtpController = TextEditingController(
      text: ticket == null || ticket.noKtp == 0 ? '' : ticket.noKtp.toString(),
    );
    fromController = TextEditingController(text: ticket?.from);
    toController = TextEditingController(text: ticket?.to);
    dateController = TextEditingController(text: ticket?.date);
    departTimeController = TextEditingController(text: ticket?.departTime);
    arriveTimeController = TextEditingController(text: ticket?.arriveTime);
    durationController = TextEditingController(text: ticket?.duration);
    priceController = TextEditingController(
      text: ticket == null ? '' : ticket.price.toString(),
    );
    seatsController = TextEditingController(
      text: ticket == null ? '' : ticket.availableSeats.toString(),
    );
    imageController = TextEditingController(text: ticket?.imageUrl);
  }

  @override
  void dispose() {
    operatorController.dispose();
    noKtpController.dispose();
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    departTimeController.dispose();
    arriveTimeController.dispose();
    durationController.dispose();
    priceController.dispose();
    seatsController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> _saveTicket() async {
    if (formKey.currentState?.validate() != true) return;

    setState(() {
      isSaving = true;
    });

    final ticket = TicketModel(
      id: widget.ticket?.id ?? '',
      transportType: selectedTransport,
      operatorName: operatorController.text.trim(),
      from: fromController.text.trim(),
      to: toController.text.trim(),
      date: dateController.text.trim(),
      departTime: departTimeController.text.trim(),
      arriveTime: arriveTimeController.text.trim(),
      duration: durationController.text.trim(),
      ticketClass: selectedClass,
      price: int.tryParse(priceController.text.trim()) ?? 0,
      availableSeats: int.tryParse(seatsController.text.trim()) ?? 0,
      imageUrl: imageController.text.trim(),
      noKtp: int.tryParse(noKtpController.text.trim()) ?? 0,
    );

    try {
      if (isEditing) {
        await ticketController.updateTicket(ticket.id, ticket);
      } else {
        await ticketController.createTicket(ticket);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Tiket berhasil diubah' : 'Tiket berhasil ditambah',
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tiket' : 'Tambah Tiket'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            DropdownButtonFormField<String>(
              value: selectedTransport,
              decoration: _inputDecoration(
                label: 'Jenis Transportasi',
                icon: Icons.directions_transit,
              ),
              items: _dropdownItems(
                selectedTransport,
                const ['Pesawat', 'Kereta', 'Bus'],
              ),
              onChanged: (value) {
                setState(() {
                  selectedTransport = value ?? 'Pesawat';
                });
              },
            ),
            const SizedBox(height: 14),
            _textField(
              controller: operatorController,
              label: 'Nama Armada',
              icon: Icons.badge,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: noKtpController,
              label: 'No KTP',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
              required: false,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: fromController,
              label: 'Rute Asal',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: toController,
              label: 'Rute Tujuan',
              icon: Icons.flag,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: dateController,
              label: 'Tanggal',
              hint: '2026-06-11',
              icon: Icons.calendar_month,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: departTimeController,
                    label: 'Waktu Pergi',
                    hint: '08.00',
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: arriveTimeController,
                    label: 'Waktu Tiba',
                    hint: '10.30',
                    icon: Icons.schedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _textField(
              controller: durationController,
              label: 'Durasi Perjalanan',
              hint: '2j 30m',
              icon: Icons.timelapse,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: _inputDecoration(
                label: 'Kelas',
                icon: Icons.event_seat,
              ),
              items: _dropdownItems(
                selectedClass,
                const ['Ekonomi', 'Bisnis', 'Eksekutif'],
              ),
              onChanged: (value) {
                setState(() {
                  selectedClass = value ?? 'Ekonomi';
                });
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: priceController,
                    label: 'Harga',
                    icon: Icons.payments,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: seatsController,
                    label: 'Sisa Kursi',
                    icon: Icons.airline_seat_recline_normal,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _textField(
              controller: imageController,
              label: 'Gambar Kendaraan',
              icon: Icons.image,
              keyboardType: TextInputType.url,
              required: false,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _saveTicket,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isSaving ? 'Menyimpan...' : 'Simpan',
                  style: const TextStyle(
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

  List<DropdownMenuItem<String>> _dropdownItems(
    String selectedValue,
    List<String> defaultValues,
  ) {
    final values = [
      if (selectedValue.isNotEmpty && !defaultValues.contains(selectedValue))
        selectedValue,
      ...defaultValues,
    ];

    return values
        .map(
          (value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ),
        )
        .toList();
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label: label, icon: icon, hint: hint),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
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

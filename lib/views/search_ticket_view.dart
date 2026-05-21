import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'ticket_list_view.dart';

class SearchTicketView extends StatefulWidget {
  final String transportType;

  const SearchTicketView({
    super.key,
    required this.transportType,
  });

  @override
  State<SearchTicketView> createState() => _SearchTicketViewState();
}

class _SearchTicketViewState extends State<SearchTicketView> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final passengerController = TextEditingController(text: '1');

  String selectedClass = 'Semua';

  Future<void> pickDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: now,
    );

    if (selectedDate != null) {
      final month = selectedDate.month.toString().padLeft(2, '0');
      final day = selectedDate.day.toString().padLeft(2, '0');

      setState(() {
        dateController.text = '${selectedDate.year}-$month-$day';
      });
    }
  }

  void searchTicket() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketListView(
          transportType: widget.transportType,
          from: fromController.text,
          to: toController.text,
          date: dateController.text,
          passengerCount: passengerController.text,
          ticketClass: selectedClass,
        ),
      ),
    );
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    passengerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.flight_takeoff;
    if (widget.transportType == 'Kereta') icon = Icons.train;
    if (widget.transportType == 'Bus') icon = Icons.directions_bus;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cari ${widget.transportType}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Kota Asal',
              hint: 'Contoh: Makassar',
              controller: fromController,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Kota Tujuan',
              hint: 'Contoh: Jakarta',
              controller: toController,
              icon: Icons.flag,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tanggal Berangkat',
              hint: 'Pilih tanggal',
              controller: dateController,
              icon: Icons.calendar_month,
              readOnly: true,
              onTap: pickDate,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Jumlah Penumpang',
              hint: 'Contoh: 1',
              controller: passengerController,
              icon: Icons.group,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(
                labelText: 'Kelas Tiket',
                prefixIcon: const Icon(Icons.event_seat),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                DropdownMenuItem(value: 'Ekonomi', child: Text('Ekonomi')),
                DropdownMenuItem(value: 'Bisnis', child: Text('Bisnis')),
                DropdownMenuItem(value: 'Eksekutif', child: Text('Eksekutif')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedClass = value ?? 'Semua';
                });
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Cari Tiket',
              icon: Icons.search,
              onPressed: searchTicket,
            ),
            const SizedBox(height: 14),
            Text(
              'Tips: kosongkan asal, tujuan, atau tanggal jika ingin menampilkan semua data dummy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

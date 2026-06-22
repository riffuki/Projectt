import 'package:flutter/material.dart';

import '../controllers/ticket_controller.dart';
import '../models/ticket_model.dart';
import '../utils/format_currency.dart';
import 'ticket_form_view.dart';

class ManageTicketView extends StatefulWidget {
  const ManageTicketView({super.key});

  @override
  State<ManageTicketView> createState() => _ManageTicketViewState();
}

class _ManageTicketViewState extends State<ManageTicketView> {
  final ticketController = TicketController();
  late Future<List<TicketModel>> ticketsFuture;

  @override
  void initState() {
    super.initState();
    ticketsFuture = ticketController.getAllTickets();
  }

  void _reloadTickets() {
    setState(() {
      ticketsFuture = ticketController.getAllTickets();
    });
  }

  Future<void> _openForm([TicketModel? ticket]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TicketFormView(ticket: ticket)),
    );

    if (changed == true) {
      _reloadTickets();
    }
  }

  Future<void> _deleteTicket(TicketModel ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus tiket?'),
          content: Text('Data ${ticket.operatorName} akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ticketController.deleteTicket(ticket.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiket berhasil dihapus')),
      );
      _reloadTickets();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tiket'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: FutureBuilder<List<TicketModel>>(
        future: ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _emptyState(
              icon: Icons.cloud_off,
              title: 'Gagal memuat tiket',
              message: snapshot.error.toString(),
            );
          }

          final tickets = snapshot.data ?? [];
          if (tickets.isEmpty) {
            return _emptyState(
              icon: Icons.confirmation_number_outlined,
              title: 'Belum ada tiket',
              message: 'Tambahkan data tiket pertama dari tombol Tambah.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reloadTickets(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return _ticketCard(tickets[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(TicketModel ticket) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Icon(_ticketIcon(ticket), color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.operatorName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        ticket.transportType,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') _openForm(ticket);
                    if (value == 'delete') _deleteTicket(ticket);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 10),
                          Text('Hapus'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${ticket.from} -> ${ticket.to}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  formatCurrency(ticket.price),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _ticketIcon(TicketModel ticket) {
    if (ticket.transportType == 'Pesawat') return Icons.flight;
    if (ticket.transportType == 'Kereta') return Icons.train;
    return Icons.directions_bus;
  }
}

import 'package:flutter/material.dart';
import '../widgets/transport_card.dart';
import 'history_view.dart';
import 'login_view.dart';
import 'search_ticket_view.dart';

class DashboardView extends StatelessWidget {
  final String email;

  const DashboardView({
    super.key,
    required this.email,
  });

  void openSearch(BuildContext context, String transportType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchTicketView(transportType: transportType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = email.isEmpty ? 'pengguna' : email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Riwayat',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryView()),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $displayEmail',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mau pergi ke mana hari ini?',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF60A5FA),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.travel_explore, color: Colors.white, size: 42),
                  SizedBox(height: 14),
                  Text(
                    'Pesan Tiket Transportasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pesawat, kereta, dan bus dalam satu aplikasi.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pilih Transportasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            TransportCard(
              title: 'Pesawat',
              subtitle: 'Cari tiket penerbangan',
              icon: Icons.flight_takeoff,
              color: Colors.blue,
              onTap: () => openSearch(context, 'Pesawat'),
            ),
            TransportCard(
              title: 'Kereta',
              subtitle: 'Cari tiket perjalanan kereta',
              icon: Icons.train,
              color: Colors.green,
              onTap: () => openSearch(context, 'Kereta'),
            ),
            TransportCard(
              title: 'Bus',
              subtitle: 'Cari tiket perjalanan bus',
              icon: Icons.directions_bus,
              color: Colors.orange,
              onTap: () => openSearch(context, 'Bus'),
            ),
          ],
        ),
      ),
    );
  }
}

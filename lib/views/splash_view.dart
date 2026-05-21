import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.confirmation_number,
                size: 54,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'GoTiket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pesan tiket lebih mudah',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = AuthController();

  void register() {
    final success = authController.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil, silakan login')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data wajib diisi')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Icon(
              Icons.person_add_alt_1,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Nama Lengkap',
              hint: 'Masukkan nama',
              controller: nameController,
              icon: Icons.person,
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
            CustomTextField(
              label: 'Password',
              hint: 'Masukkan password',
              controller: passwordController,
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Daftar',
              icon: Icons.check_circle,
              onPressed: register,
            ),
          ],
        ),
      ),
    );
  }
}

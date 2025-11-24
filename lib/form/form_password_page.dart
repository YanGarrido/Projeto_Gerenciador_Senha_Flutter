import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/widget/password_form.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class FormPasswordPage extends StatelessWidget {
  final String? initialCategory;

  const FormPasswordPage({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Password',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.darkblue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Navbar removida daqui se você já removeu da home, ou mantenha se quiser consistência visual
      // mas geralmente formulário modal ocupa a tela toda. Vou manter para não quebrar seu layout atual.
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10.0),
              // CORREÇÃO: Adicionei a sombra aqui
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PasswordForm(initialCategory: initialCategory),
            ),
          ),
        ),
      ),
    );
  }
}
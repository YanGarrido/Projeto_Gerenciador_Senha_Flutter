import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRegisterScreen extends StatefulWidget {
  const ProfileRegisterScreen({super.key});

  @override
  State<ProfileRegisterScreen> createState() => _ProfileRegisterScreenState();
}

class _ProfileRegisterScreenState extends State<ProfileRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  // -------- VALIDAR SENHA --------
  String? validatePassword(String password) {
    if (password.length < 8) {
      return "A senha deve ter no mínimo 8 caracteres";
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "A senha deve conter pelo menos 1 letra maiúscula";
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "A senha deve conter pelo menos 1 letra minúscula";
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "A senha deve conter pelo menos 1 número";
    }

    return null;
  }

  // ---------- SALVAR REGISTRO ----------
  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("user_name", nameController.text);
      await prefs.setString("user_email", emailController.text);
      await prefs.setString("user_password", passwordController.text);

      // Salvar data de registro
      final now = DateTime.now();
      await prefs.setString(
        "member_since",
        "${now.year}-${now.month}-${now.day}",
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta criada com sucesso!")),
      );

      if (!mounted) return;
      Navigator.pop(context); // volta para login
    }
  }

  // COR PADRÃO DO FIGMA
  static const Color darkBlue = Color(0xFF364973);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // ----------------- TÍTULO -----------------
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to start managing your passwords securely.",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ----------- NAME FIELD -----------
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(color: darkBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue, width: 2),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Informe seu nome" : null,
                    ),
                    const SizedBox(height: 18),

                    // ----------- EMAIL FIELD -----------
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(color: darkBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue, width: 2),
                        ),
                      ),
                      validator: (value) =>
                          value!.contains("@") ? null : "Email inválido",
                    ),
                    const SizedBox(height: 18),

                    // ----------- PASSWORD FIELD -----------
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(color: darkBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: darkBlue, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: darkBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) => validatePassword(value!),
                    ),

                    const SizedBox(height: 30),

                    // ----------- BOTÃO REGISTRAR -----------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ----------- LINK PARA LOGIN -----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

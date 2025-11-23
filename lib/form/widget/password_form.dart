import 'dart:convert';
<<<<<<< HEAD
=======
import 'dart:math';

>>>>>>> d2a57d63858c055e585967ba8dd02f567353b11c
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordForm extends StatefulWidget {
  final String? initialCategory;

  const PasswordForm({super.key, this.initialCategory});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _selectedCategory;
  
  final List<String> _categories = [
    'Websites',
    'Banking',
    'Personal',
    'Work'
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();
  final TextEditingController _notesController = TextEditingController(); 

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Websites';
  }

  void _generatePassword() {
<<<<<<< HEAD
    setState(() {
      _passwordController.text = 'NewStrongPass#2025!'; // Exemplo
=======
    const int passwordLength = 16;
    const String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    final random = Random.secure();
    
    // Garantir pelo menos um de cada tipo
    final password = StringBuffer();
    password.write(uppercaseLetters[random.nextInt(uppercaseLetters.length)]);
    password.write(lowercaseLetters[random.nextInt(lowercaseLetters.length)]);
    password.write(numbers[random.nextInt(numbers.length)]);
    password.write(specialCharacters[random.nextInt(specialCharacters.length)]);
    
    // Preencher o resto da senha
    const allCharacters = uppercaseLetters + lowercaseLetters + numbers + specialCharacters;
    for (int i = 4; i < passwordLength; i++) {
      password.write(allCharacters[random.nextInt(allCharacters.length)]);
    }
    
    // Embaralhar a senha para randomizar a posição dos caracteres garantidos
    final passwordList = password.toString().split('')..shuffle(random);
    final generatedPassword = passwordList.join();
    
    setState(() {
      _passwordController.text = generatedPassword;
>>>>>>> d2a57d63858c055e585967ba8dd02f567353b11c
    });
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    if (password.length < 6) return 0.2; // Muito fraca
    if (password.length < 10) return 0.5; // Média
    // CORREÇÃO: Se for forte, retorna 1.0 para encher a barra
    return 1.0; 
  }

  String _getPasswordStrengthText(double strength) {
    if (strength < 0.3) return 'Very Weak';
    if (strength < 0.6) return 'Weak';
    if (strength < 1.0) return 'Medium';
    return 'Strong';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (_formKey.currentState!.validate()) {
      final passwordData = {
        'title': _titleController.text,
        'category': _selectedCategory,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'website': _websiteUrlController.text,
        'notes': _notesController.text,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final jsonData = jsonEncode(passwordData);
      final key = 'password_${DateTime.now().millisecondsSinceEpoch}';

      try {
        await _storage.write(key: key, value: jsonData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password saved successfully!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving password: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double passwordStrength = _calculatePasswordStrength(_passwordController.text);
    String passwordStrengthText = _getPasswordStrengthText(passwordStrength);
    
    // Verifica se a categoria veio fixa
    final bool isCategoryPredefined = widget.initialCategory != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CORREÇÃO: Título redundante "Add New Password" removido daqui.
          
          _buildLabel('Title'),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hintText: 'e.g. Google, Facebook, Bank',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
          ),
          const SizedBox(height: 16),
          
          // CORREÇÃO: Se a categoria já foi escolhida na tela anterior, nem mostra o campo.
          if (!isCategoryPredefined) ...[
            _buildLabel('Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) => (value == null || value.isEmpty) ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),
          ],

          _buildLabel('Username / Email'),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hintText: 'Enter your username or email',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter username' : null,
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    tooltip: 'Generate Password',
                    onPressed: _generatePassword,
                  ),
                ],
              ),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter your password' : null,
            onChanged: (value) => setState(() {}),
          ),
          
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Password Strength'),
              Text(
                passwordStrengthText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: passwordStrength,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
               passwordStrength < 0.3 ? Colors.red :
               passwordStrength < 0.6 ? Colors.orange :
               passwordStrength < 1.0 ? Colors.yellow.shade700 : Colors.green, // Ajuste nas cores
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('Website URL (optional)'),
          TextFormField(
            controller: _websiteUrlController,
            decoration: const InputDecoration(
              hintText: 'https://example.com',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          _buildLabel('Notes (optional)'),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'Additional information',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.darkblue),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _savePassword, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 51, 95),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Password'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel'),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }
}
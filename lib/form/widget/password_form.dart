import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:uuid/uuid.dart';

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
  
  final List<String> _categories = ['Websites', 'Banking', 'Personal', 'Work'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();
  final TextEditingController _notesController = TextEditingController(); 

  final PasswordService _passwordService = PasswordService();
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Websites';
  }

  void _generatePassword() {
    const int passwordLength = 16;
    const String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final random = Random.secure();
    final passwordBuffer = StringBuffer();
    
    // Garante um de cada tipo
    passwordBuffer.write(uppercaseLetters[random.nextInt(uppercaseLetters.length)]);
    passwordBuffer.write(lowercaseLetters[random.nextInt(lowercaseLetters.length)]);
    passwordBuffer.write(numbers[random.nextInt(numbers.length)]);
    passwordBuffer.write(specialCharacters[random.nextInt(specialCharacters.length)]);

    // Preenche o resto
    const allCharacters = uppercaseLetters + lowercaseLetters + numbers + specialCharacters;
    for (int i = 4; i < passwordLength; i++) {
      passwordBuffer.write(allCharacters[random.nextInt(allCharacters.length)]);
    }

    final passwordList = passwordBuffer.toString().split('')..shuffle(random);
    setState(() {
      _passwordController.text = passwordList.join();
    });
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    if (password.length < 6) return 0.2;
    if (password.length < 10) return 0.5;
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
      try {
        final passwordModel = PasswordModel(
          id: 'password_${_uuid.v4()}',
          title: _titleController.text.trim(),
          category: _selectedCategory ?? 'Websites',
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          website: _websiteUrlController.text.trim(),
          notes: _notesController.text.trim(),
          createdAt: DateTime.now(),
        );

        await _passwordService.savePassword(passwordModel);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password saved successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving password: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  InputDecoration _inputStyle(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textFieldStroke),
      filled: true,
      fillColor: Colors.white,
      hoverColor: Colors.transparent,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.textFieldStroke),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.darkblue),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    double passwordStrength = _calculatePasswordStrength(_passwordController.text);
    String passwordStrengthText = _getPasswordStrengthText(passwordStrength);
    final bool isCategoryPredefined = widget.initialCategory != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Title'),
          TextFormField(
            controller: _titleController,
            decoration: _inputStyle('e.g. Google, Facebook, Bank'),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title' : null,
          ),
          const SizedBox(height: 16),
          
          if (!isCategoryPredefined) ...[
            _buildLabel('Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputStyle(''),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) => setState(() => _selectedCategory = newValue),
              validator: (value) => (value == null || value.isEmpty) ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),
          ],

          _buildLabel('Username / Email'),
          TextFormField(
            controller: _usernameController,
            decoration: _inputStyle('Enter your username or email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter username' : null,
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: _inputStyle(
              'Enter your password',
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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
               passwordStrength < 1.0 ? Colors.yellow.shade700 : Colors.green,
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('Website URL (optional)'),
          TextFormField(
            controller: _websiteUrlController,
            decoration: _inputStyle('https://example.com'),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          _buildLabel('Notes (optional)'),
          TextFormField(
            controller: _notesController,
            decoration: _inputStyle('Additional information'),
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          
          const SizedBox(height: 40),
          
          // --- BOTÕES LADO A LADO (ROW) ---
          Row(
            children: [
              // Botão Cancelar
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300), // Borda suave
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 16), 
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _savePassword, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkblue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
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
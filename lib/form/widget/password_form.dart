import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _selectedCategory = 'Websites';
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

  void _generatePassword() {
    //TODO: fazer a logica para geraçao de senha
    setState(() {
      _passwordController.text = 'NewGeneratedPassword123!';
    });
  }

  double _calculatePasswordStrength(String password) {
    // Provavelmente é melhor utilizar regex para uma melhor avaliação
    if (password.isEmpty) return 0.0;
    if (password.length < 6) return 0.2;
    if (password.length < 10) return 0.5;
    return 0.8;
  }

  String _getPasswordStrengthText(double strength) {
    if (strength < 0.3) return 'Very Weak';
    if (strength < 0.6) return 'Weak';
    if (strength < 0.8) return 'Medium';
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error saving password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving password: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double passwordStrength = _calculatePasswordStrength(_passwordController.text);
    String passwordStrengthText = _getPasswordStrengthText(passwordStrength);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add New Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          _buildLabel('Title'),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hintText: 'e.g. Google, Facebook, Bank',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildLabel('Category'),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildLabel('Username / Email'),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hintText: 'Enter your username or email',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username or email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                    color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh, color: Colors.grey,),
                      tooltip: 'Generate Password',
                      onPressed: _generatePassword,
                    ),
              ],
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Password Strength'),
              const SizedBox(width: 8),
              Text(
                passwordStrengthText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.shade700
                ),
              ),

          ],
          ),
          
          Row(
            children: [
              Expanded(child: LinearProgressIndicator(
                value: passwordStrength,
                         backgroundColor: Colors.grey.shade300,
                         valueColor: AlwaysStoppedAnimation<Color>(
                           passwordStrength < 0.3 ? Colors.red :
                           passwordStrength < 0.6 ? Colors.orange :
                           passwordStrength < 0.8 ? Colors.yellow.shade700 : Colors.green,
              ),
              ),
              ),
              const SizedBox(width: 8),
          ],
          ),
          const SizedBox(height: 16),

          _buildLabel('Website URL (optional)'),
          TextFormField(
            controller: _websiteUrlController,
            decoration: const InputDecoration(
              hintText: 'https://example.com',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
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
            decoration: InputDecoration(
              hintText: 'Additional information',
              hintStyle: TextStyle(color: AppColors.textFieldStroke),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFieldStroke,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.darkblue,
                ),
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
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save Password')),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
}

Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
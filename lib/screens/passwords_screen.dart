import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final PasswordService _passwordService = PasswordService();

  List<PasswordModel> _passwords = [];
  List<PasswordModel> _allPasswords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    setState(() => _isLoading = true);

    final data = await _passwordService.getAllPasswords();

    setState(() {
      _allPasswords = data;
      _passwords = data;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _passwords = _allPasswords);
      return;
    }

    final q = query.toLowerCase();

    setState(() {
      _passwords = _allPasswords.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.username.toLowerCase().contains(q) ||
            p.website.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Passwords',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.addPassword);
          if (result == true) _loadPasswords();
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.darkblue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  SearchBarWidget(onChanged: _onSearch),

                  const SizedBox(height: 10),

                  Expanded(
                    child: _passwords.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            itemCount: _passwords.length,
                            itemBuilder: (context, index) {
                              final password = _passwords[index];
                              return PasswordView(
                                password: password,
                                onDeleted: _loadPasswords,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "Nenhuma senha cadastrada",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

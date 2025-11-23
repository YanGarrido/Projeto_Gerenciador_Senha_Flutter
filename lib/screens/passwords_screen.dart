import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';

enum SortOption {
  nameAsc, nameDesc, dateNewest, dateOldest,
}

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final PasswordService _passwordService = PasswordService();
  List<PasswordModel> _passwords = [];
  List<PasswordModel> _allPasswords = []; 
  SortOption _currentSort = SortOption.dateNewest;
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
      _passwords = List.from(data);
      _isLoading = false;
    });
    _sortList(_currentSort);
  }

  void _sortList(SortOption option) {
    setState(() {
      _currentSort = option;
      switch (option) {
        case SortOption.nameAsc: _passwords.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())); break;
        case SortOption.nameDesc: _passwords.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase())); break;
        case SortOption.dateNewest: _passwords.sort((a, b) => b.createdAt.compareTo(a.createdAt)); break;
        case SortOption.dateOldest: _passwords.sort((a, b) => a.createdAt.compareTo(b.createdAt)); break;
      }
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _passwords = List.from(_allPasswords);
        _sortList(_currentSort);
      });
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _passwords = _allPasswords.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.username.toLowerCase().contains(q) ||
            p.website.toLowerCase().contains(q);
      }).toList();
      _sortList(_currentSort);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        elevation: 0,
        centerTitle: true, 
        title: const Text('All Passwords', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.addPassword);
          if (result == true) _loadPasswords();
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.darkblue,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (_allPasswords.isNotEmpty) ...[
                    SearchBarWidget(
                      onChanged: _onSearch,
                      filterAction: PopupMenuButton<SortOption>(
                        icon: const Icon(Icons.tune, color: AppColors.darkblue),
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        offset: const Offset(0, 10),
                        onSelected: _sortList,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: SortOption.nameAsc, child: Text('Name (A-Z)')),
                          const PopupMenuItem(value: SortOption.nameDesc, child: Text('Name (Z-A)')),
                          const PopupMenuDivider(),
                          const PopupMenuItem(value: SortOption.dateNewest, child: Text('Newest First')),
                          const PopupMenuItem(value: SortOption.dateOldest, child: Text('Oldest First')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Expanded(
                    child: _passwords.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            itemCount: _passwords.length,
                            itemBuilder: (context, index) {
                              final password = _passwords[index];
                              return PasswordView(password: password, onDeleted: _loadPasswords);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() {
    final bool isSearchEmpty = _allPasswords.isNotEmpty && _passwords.isEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AQUI: Cores balanceadas
          Icon(isSearchEmpty ? Icons.search_off : Icons.lock_outline, size: 72, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          Text(
            isSearchEmpty ? "No results found" : "No passwords saved yet",
            style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
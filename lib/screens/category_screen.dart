import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';
import 'package:flutter_application_1/shared/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

enum SortOption {
  nameAsc, nameDesc, dateNewest, dateOldest,
}

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final List<PasswordModel> passwords;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.passwords,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PasswordService _passwordService = PasswordService();
  
  List<PasswordModel> _allPasswords = []; 
  List<PasswordModel> _displayedPasswords = [];
  SortOption _currentSort = SortOption.dateNewest;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshPasswords();
  }

  Future<void> _refreshPasswords() async {
    setState(() => _isLoading = true);
    final data = await _passwordService.getPasswordsByCategory(widget.categoryName);
    setState(() {
      _allPasswords = data; 
      _displayedPasswords = List.from(data);
      _isLoading = false;
    });
    _sortPasswords(_currentSort);
  }

  void _sortPasswords(SortOption option) {
    setState(() {
      _currentSort = option;
      switch (option) {
        case SortOption.nameAsc:
          _displayedPasswords.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          break;
        case SortOption.nameDesc:
          _displayedPasswords.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
          break;
        case SortOption.dateNewest:
          _displayedPasswords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortOption.dateOldest:
          _displayedPasswords.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_allPasswords.isNotEmpty) ...[
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _displayedPasswords = List.from(_allPasswords);
                    } else {
                      _displayedPasswords = _allPasswords
                          .where((p) =>
                              p.title.toLowerCase().contains(value.toLowerCase()) ||
                              p.username.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    }
                    _sortPasswords(_currentSort);
                  });
                },
                filterAction: PopupMenuButton<SortOption>(
                  icon: const Icon(Icons.tune, color: AppColors.darkblue),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  offset: const Offset(0, 10),
                  onSelected: _sortPasswords,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
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
              child: _displayedPasswords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           if (_allPasswords.isNotEmpty) 
                              const Icon(Icons.search_off, size: 60, color: Color(0xFF9CA3AF)),
                           if (_allPasswords.isEmpty) 
                              const Icon(Icons.lock_outline, size: 60, color: Color(0xFF9CA3AF)),
                           
                           const SizedBox(height: 16),
                           
                           Text(
                            _allPasswords.isEmpty 
                              ? 'No passwords in ${widget.categoryName}'
                              : 'No results found',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _displayedPasswords.length,
                      itemBuilder: (context, index) {
                        final item = _displayedPasswords[index];
                        return PasswordView(
                          password: item,
                          onDeleted: _refreshPasswords,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkblue,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPasswordPage(
                initialCategory: widget.categoryName,
              ),
            ),
          );
          if (result == true) {
            _refreshPasswords();
          }
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
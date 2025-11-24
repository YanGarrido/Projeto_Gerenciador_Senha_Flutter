import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/home/widgets/categories.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

enum SortOption {
  nameAsc, nameDesc, dateNewest, dateOldest,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PasswordService _passwordService = PasswordService();
  List<PasswordModel> _allPasswords = [];
  List<PasswordModel> _filteredPasswords = [];
  List<PasswordModel> _searchResults = [];
  String? _selectedCategory;
  String _searchQuery = '';
  SortOption _currentSort = SortOption.dateNewest;
  int _weakPasswordsCount = 0;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    setState(() => _isLoading = true);
    final passwords = await _passwordService.getAllPasswords();
    final weakCount = passwords.where((p) => p.password.length < 8).length;
    setState(() {
      _allPasswords = passwords;
      _weakPasswordsCount = weakCount;
      _isLoading = false;
    });
    if (_searchQuery.isNotEmpty) {
      _onSearchChanged(_searchQuery);
    } else {
      _applyCategoryFilter();
    }
  }

  void _handleSort(SortOption option) {
    setState(() {
      _currentSort = option;
      _sortLists();
    });
  }

  void _sortLists() {
    int compare(PasswordModel a, PasswordModel b) {
      switch (_currentSort) {
        case SortOption.nameAsc: return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOption.nameDesc: return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case SortOption.dateNewest: return b.createdAt.compareTo(a.createdAt);
        case SortOption.dateOldest: return a.createdAt.compareTo(b.createdAt);
      }
    }
    _filteredPasswords.sort(compare);
    _searchResults.sort(compare);
  }

  void _applyCategoryFilter() {
    setState(() {
      if (_selectedCategory == null) {
        List<PasswordModel> sortedAll = List.from(_allPasswords);
        sortedAll.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _filteredPasswords = sortedAll.take(3).toList();
      } else {
        _filteredPasswords = _allPasswords.where((p) => p.category == _selectedCategory).toList();
        _sortLists();
      }
    });
  }

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
    _applyCategoryFilter();
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
        _applyCategoryFilter();
      }
    });

    if (query.isNotEmpty) {
      final results = _allPasswords.where((p) =>
        p.title.toLowerCase().contains(query.toLowerCase()) ||
        p.username.toLowerCase().contains(query.toLowerCase()) ||
        p.website.toLowerCase().contains(query.toLowerCase())
      ).toList();
      setState(() {
        _searchResults = results;
        _sortLists();
      });
    }
  }

  Future<void> _navigateToAddPassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPasswordPage()),
    );
    if (result == true) _loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _searchQuery.isNotEmpty ? _searchResults : _filteredPasswords;
    final isSearchActive = _searchQuery.isNotEmpty;
    final shouldShowList = isSearchActive ? _searchResults.isNotEmpty : true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'PassMan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkblue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPassword,
        shape: const CircleBorder(),
        backgroundColor: AppColors.darkblue,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SearchBarWidget(
                          onChanged: _onSearchChanged,
                          filterAction: PopupMenuButton<SortOption>(
                            icon: const Icon(Icons.tune, color: AppColors.darkblue),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            offset: const Offset(0, 10),
                            onSelected: _handleSort,
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: SortOption.nameAsc, child: Text('Name (A-Z)')),
                              const PopupMenuItem(value: SortOption.nameDesc, child: Text('Name (Z-A)')),
                              const PopupMenuItem(value: SortOption.dateNewest, child: Text('Newest First')),
                              const PopupMenuItem(value: SortOption.dateOldest, child: Text('Oldest First')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isSearchActive) ...[
                          const Text(
                            'Categories',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Categories(
                            passwords: _allPasswords,
                            selectedCategory: _selectedCategory,
                            onUpdate: _loadPasswords, 
                          ),
                          const SizedBox(height: 24),
                          if (_weakPasswordsCount > 0) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                                border: const Border(left: BorderSide(color: Colors.red, width: 4)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'You have $_weakPasswordsCount weak passwords.',
                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ],

                        if (shouldShowList && (_allPasswords.isNotEmpty || isSearchActive))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (isSearchActive && _searchResults.isEmpty)
                                  const SizedBox.shrink()
                                else
                                  Text(
                                    isSearchActive
                                        ? 'Results(${_searchResults.length})'
                                        : (_selectedCategory == null ? 'Recent passwords' : 'Passwords - $_selectedCategory'),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                if (!isSearchActive && _selectedCategory == null)
                                  TextButton(
                                    onPressed: () {}, 
                                    child: const Text('View all'),
                                  ),
                                if (!isSearchActive && _selectedCategory != null)
                                  TextButton(
                                    onPressed: () => _onCategorySelected(null),
                                    child: const Text('Clear Filter'),
                                  ),
                              ],
                            ),
                          ),

                        if (_isSearching && isSearchActive)
                          const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
                        else if (displayList.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  // AQUI: Cores balanceadas
                                  Icon(isSearchActive ? Icons.search_off : Icons.lock_outline, size: 64, color: const Color(0xFF9CA3AF)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No results found',
                                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)), // Cinza médio
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...displayList.map((p) => PasswordView(password: p, onDeleted: _loadPasswords)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
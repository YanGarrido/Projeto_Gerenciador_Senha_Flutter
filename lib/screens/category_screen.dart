import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/shared/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

// Enum para facilitar a lógica de ordenação
enum SortOption {
  nameAsc,      // A-Z
  nameDesc,     // Z-A
  dateNewest,   // Mais recentes primeiro
  dateOldest,   // Mais antigos primeiro
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
  final Map<int, bool> _showPasswordMap = {};
  final PasswordService _passwordService = PasswordService();
  
  List<PasswordModel> _allPasswords = []; 
  List<PasswordModel> _displayedPasswords = [];
  
  // Estado atual da ordenação (Padrão: Mais recentes)
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
    // Aplica a ordenação atual logo após carregar
    _sortPasswords(_currentSort);
  }

  // Função centralizada de ordenação
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

  Future<void> _deletePassword(String id) async {
    await _passwordService.deletePassword(id);
    _refreshPasswords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha excluída!')),
      );
    }
  }

  void _showDeleteConfirmation(String title, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir senha'),
        content: Text('Deseja excluir a senha de "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePassword(id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
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
                    // Reaplica a ordenação após filtrar
                    _sortPasswords(_currentSort);
                  });
                },
                // AQUI: Menu Suspenso (Popup)
                filterAction: PopupMenuButton<SortOption>(
                  icon: const Icon(Icons.tune, color: AppColors.darkblue),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  offset: const Offset(0, 10), // Pequeno espaço para baixo
                  onSelected: _sortPasswords,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                    const PopupMenuItem<SortOption>(
                      value: SortOption.nameAsc,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Name (A-Z)'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.nameDesc,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_downward, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Name (Z-A)'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.dateNewest,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: AppColors.darkblue),
                          SizedBox(width: 8),
                          Text('Newest First'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.dateOldest,
                      child: Row(
                        children: [
                          Icon(Icons.history, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Oldest First'),
                        ],
                      ),
                    ),
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
                              const Icon(Icons.search_off, size: 60, color: Colors.grey),
                           if (_allPasswords.isEmpty) 
                              const Icon(Icons.lock_outline, size: 60, color: Colors.grey),
                           
                           const SizedBox(height: 16),
                           
                           Text(
                            _allPasswords.isEmpty 
                              ? 'No passwords in ${widget.categoryName}'
                              : 'No results found',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _displayedPasswords.length,
                      itemBuilder: (context, index) {
                        final item = _displayedPasswords[index];
                        final showPassword = _showPasswordMap[item.hashCode] ?? false;

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9EDF5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.title.isNotEmpty ? item.title[0].toUpperCase() : '?',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF233862),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            item.username,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteConfirmation(
                                      item.title,
                                      item.id,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Password",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      showPassword
                                          ? item.password
                                          : "•••••••••",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_outlined),
                                    onPressed: () {
                                      setState(() {
                                        _showPasswordMap[item.hashCode] = !showPassword;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: item.password));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Password copied"),
                                        duration: Duration(seconds: 1),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.darkblue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_outline),
            label: "Passwords",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
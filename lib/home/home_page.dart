import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/home/widgets/categories.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/shared/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

// Enum para ordenação (Igual ao da tela de categorias)
enum SortOption {
  nameAsc,      // A-Z
  nameDesc,     // Z-A
  dateNewest,   // Mais recentes
  dateOldest,   // Mais antigos
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
  
  // Estado da ordenação (Padrão: Mais recentes)
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
    setState(() {
      _isLoading = true;
    });

    final passwords = await _passwordService.getAllPasswords();
    final weakCount = passwords.where((p) => p.password.length < 8).length;

    setState(() {
      _allPasswords = passwords;
      _weakPasswordsCount = weakCount;
      _isLoading = false;
    });

    // Reaplica filtros e ordenação
    if (_searchQuery.isNotEmpty) {
      _onSearchChanged(_searchQuery);
    } else {
      _applyCategoryFilter();
    }
  }

  // Função central para aplicar a ordenação na lista visível
  void _handleSort(SortOption option) {
    setState(() {
      _currentSort = option;
      _sortLists(); // Ordena as listas existentes
    });
  }

  // Ordena tanto a lista filtrada quanto a de busca
  void _sortLists() {
    // Função auxiliar de comparação
    int compare(PasswordModel a, PasswordModel b) {
      switch (_currentSort) {
        case SortOption.nameAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOption.nameDesc:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case SortOption.dateNewest:
          return b.createdAt.compareTo(a.createdAt);
        case SortOption.dateOldest:
          return a.createdAt.compareTo(b.createdAt);
      }
    }

    _filteredPasswords.sort(compare);
    _searchResults.sort(compare);
  }

  void _applyCategoryFilter() {
    setState(() {
      if (_selectedCategory == null) {
        // Se não tem categoria, pega as 3 primeiras (baseado na ordem atual)
        // Primeiro ordenamos a lista completa para garantir
        List<PasswordModel> sortedAll = List.from(_allPasswords);
        
        // Função de sort local para a lista temporária
        sortedAll.sort((a, b) {
           switch (_currentSort) {
            case SortOption.nameAsc: return a.title.toLowerCase().compareTo(b.title.toLowerCase());
            case SortOption.nameDesc: return b.title.toLowerCase().compareTo(a.title.toLowerCase());
            case SortOption.dateNewest: return b.createdAt.compareTo(a.createdAt);
            case SortOption.dateOldest: return a.createdAt.compareTo(b.createdAt);
          }
        });

        _filteredPasswords = sortedAll.take(3).toList();
      } else {
        _filteredPasswords = _allPasswords.where((p) => p.category == _selectedCategory).toList();
        _sortLists(); // Ordena a lista da categoria filtrada
      }
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyCategoryFilter();
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _isSearching = false;
        _searchResults = [];
        _applyCategoryFilter();
      } else {
        _isSearching = true;
      }
    });

    if (query.isNotEmpty) {
      // Filtra na memória para ser mais rápido e consistente com a lista atual
      final results = _allPasswords.where((p) =>
        p.title.toLowerCase().contains(query.toLowerCase()) ||
        p.username.toLowerCase().contains(query.toLowerCase()) ||
        p.website.toLowerCase().contains(query.toLowerCase())
      ).toList();

      setState(() {
        _searchResults = results;
        _sortLists(); // Aplica a ordenação nos resultados da busca
        _isSearching = false;
      });
    }
  }

  Future<void> _navigateToAddPassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPasswordPage()),
    );

    if (result == true) {
      _loadPasswords();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
        _searchQuery.isNotEmpty ? _searchResults : _filteredPasswords;

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
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configurações')),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkblue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Passwords'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SearchBarWidget(
                          onChanged: _onSearchChanged,
                          // AQUI: Adicionado o Menu de Filtros na Home
                          filterAction: PopupMenuButton<SortOption>(
                            icon: const Icon(Icons.tune, color: AppColors.darkblue),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            offset: const Offset(0, 10),
                            onSelected: _handleSort,
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
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isSearchActive) ...[
                          const Text(
                            'Categorias',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                border: const Border(
                                  left: BorderSide(
                                      color: Colors.red, width: 4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.red),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'You have $_weakPasswordsCount weak password${_weakPasswordsCount > 1 ? 's' : ''} that need attention',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],

                        if (shouldShowList && (_allPasswords.isNotEmpty || isSearchActive))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isSearchActive && _searchResults.isEmpty)
                                const SizedBox.shrink()
                              else
                                Text(
                                  isSearchActive
                                      ? 'Resultados (${_searchResults.length})'
                                      : (_selectedCategory == null
                                          ? 'Recent passwords' // Se ordenar A-Z, mostra as 3 primeiras A-Z
                                          : 'Senhas - $_selectedCategory'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (!isSearchActive)
                                if (_selectedCategory != null)
                                  TextButton(
                                    onPressed: () => _onCategorySelected(null),
                                    child: const Text('Limpar filtro'),
                                  )
                                else
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('View all'),
                                  ),
                            ],
                          ),

                        if (_isSearching && isSearchActive)
                          const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (displayList.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    isSearchActive
                                        ? Icons.search_off
                                        : Icons.lock_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isSearchActive
                                        ? 'Nenhum resultado encontrado'
                                        : (_selectedCategory == null
                                            ? 'Nenhuma senha salva ainda'
                                            : 'Nenhuma senha nesta categoria'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...displayList.map(
                            (password) => PasswordView(
                              password: password,
                              onDeleted: _loadPasswords,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
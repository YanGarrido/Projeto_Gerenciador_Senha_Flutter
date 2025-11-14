import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/home/widgets/categories.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/shared/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PasswordService _passwordService = PasswordService();
  List<PasswordModel> _allPasswords = [];
  List<PasswordModel> _filteredPasswords = [];
  String? _selectedCategory;
  bool _isLoading = true;

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

    setState(() {
      _allPasswords = passwords;
      _filteredPasswords = passwords;
      _isLoading = false;
    });
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedCategory == null) {
        _filteredPasswords = _allPasswords.take(3).toList(); // Últimas 3 senhas
      } else {
        _filteredPasswords = _allPasswords
            .where((p) => p.category == _selectedCategory)
            .toList();
      }
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilter();
  }

  Future<void> _navigateToAddPassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPasswordPage()),
    );

    // Recarregar senhas se algo foi salvo
    if (result == true) {
      _loadPasswords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'PassMan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkblue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkblue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPassword,
        shape: CircleBorder(),
        backgroundColor: AppColors.darkblue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SearchBarWidget(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categorias',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Categories(
                          passwords: _allPasswords,
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _onCategorySelected,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory == null
                                  ? 'Recent passwords'
                                  : 'Senhas - $_selectedCategory',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_selectedCategory != null)
                              TextButton(
                                onPressed: () {
                                  _onCategorySelected(null);
                                },
                                child: const Text('Limpar filtro'),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  // TODO: Navegar para página de todas as senhas
                                },
                                child: const Text('View all'),
                              ),
                          ],
                        ),
                        if (_filteredPasswords.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _selectedCategory == null
                                        ? 'Nenhuma senha salva ainda'
                                        : 'Nenhuma senha nesta categoria',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _selectedCategory == null
                                        ? 'Clique no botão + para adicionar uma senha'
                                        : 'Clique em outra categoria ou limpe o filtro',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ..._filteredPasswords.map((password) => PasswordView(
                                password: password,
                                onDeleted: _loadPasswords,
                              )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

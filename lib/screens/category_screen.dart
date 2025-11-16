import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';

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
  late List<PasswordModel> _categoryPasswords;

  @override
  void initState() {
    super.initState();
    _categoryPasswords = widget.passwords
        .where((p) => p.category == widget.categoryName)
        .toList();
  }

  Future<void> _deletePassword(String id, int index) async {
    await _passwordService.deletePassword(id);
    setState(() {
      _categoryPasswords.removeAt(index);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha excluída!')),
      );
    }
  }

  void _showDeleteConfirmation(String title, String id, int index) {
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
              _deletePassword(id, index);
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
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF233862),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Pesquisa e Filtro
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search passwords...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.filter_list),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.categoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${_categoryPasswords.length} password${_categoryPasswords.length != 1 ? 's' : ''}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            // Lista de senhas
            Expanded(
              child: _categoryPasswords.isEmpty
                  ? Center(
                      child: Text(
                        'No ${widget.categoryName.toLowerCase()} passwords found',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _categoryPasswords.length,
                      itemBuilder: (context, index) {
                        final item = _categoryPasswords[index];
                        final showPassword = _showPasswordMap[index] ?? false;

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
                                      // Ícone
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9EDF5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.title[0].toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF233862),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Título e Subtítulo
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
                                  // Botão de deletar
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteConfirmation(
                                      item.title,
                                      item.id,
                                      index,
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
                                        _showPasswordMap[index] = !showPassword;
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
        backgroundColor: const Color(0xFF233862),
        onPressed: () {},
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF233862),
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

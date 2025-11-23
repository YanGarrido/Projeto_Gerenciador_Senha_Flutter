import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  
  // AQUI ESTÁ O SEGREDO: 
  // Recebemos um Widget opcional. Se passar o botão de filtro, ele aparece.
  // Se não passar nada (null), o ícone da direita simplesmente não é renderizado.
  final Widget? filterAction;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.filterAction,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Altura padrão para ficar fácil de clicar
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Sombra suave idêntica em todas as telas
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Search passwords...',
          hintStyle: const TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9CA3AF),
            size: 24,
          ),
          // Se filterAction for null, o suffixIcon fica null e nada aparece.
          // Se passarmos o PopupMenuButton, ele aparece aqui.
          suffixIcon: widget.filterAction,
          
          filled: true,
          fillColor: Colors.transparent,
          hoverColor: Colors.transparent,
          
          // Sem borda quando não focado (apenas a sombra do container)
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          
          // Borda azul quando focado
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: AppColors.darkblue),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
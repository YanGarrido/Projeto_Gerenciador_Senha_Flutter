import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
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
      margin: const EdgeInsets.only(top: 12.0, bottom: 24.0),
      width: double.infinity,
      height: 50,
      // A decoração (sombra e fundo) fica no Container pai
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2), // Sombra suave
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
          filled: true,
          // O fundo é transparente porque a cor branca já está no Container pai
          fillColor: Colors.transparent,
          
          hoverColor: Colors.transparent,

          // --- ESTADO OCIOSO: Sem borda visível, apenas a sombra do Container ---
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none, // Remove a linha
            borderRadius: BorderRadius.circular(12),
          ),

          // --- ESTADO FOCADO: A borda azul aparece ---
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
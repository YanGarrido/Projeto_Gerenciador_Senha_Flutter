import 'package:flutter/material.dart';

class CategoriesButton extends StatelessWidget {
  final IconData icon;
  final String categoryName;
  final String value;
  final Color backgroundColor;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoriesButton({
    super.key,
    required this.icon,
    required this.categoryName,
    required this.value,
    required this.backgroundColor,
    required this.iconColor,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white, // Fundo branco base
        // A Sombra fica aqui fora
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      // Material Transparente para o InkWell funcionar em cima do branco
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          
          // Cores do Hover/Splash
          hoverColor: iconColor.withValues(alpha: 0.15), // Cor suave ao passar mouse
          splashColor: iconColor.withValues(alpha: 0.25), // Cor ao clicar
          highlightColor: iconColor.withValues(alpha: 0.1),

          // Container INTERNO que segura a Borda e o Conteúdo
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              // A borda agora é desenhada AQUI, por cima do hover
              border: Border.all(
                color: isSelected ? iconColor.withValues(alpha: 0.5) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: backgroundColor,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '($value) passwords',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
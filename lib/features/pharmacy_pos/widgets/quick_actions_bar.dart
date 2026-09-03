import 'package:flutter/material.dart';
import '../../../core/theme/theme_extensions.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'title': 'Customer', 'subtitle': 'Add Customer', 'icon': Icons.person_add_alt_1_rounded, 'color': Colors.purple},
      {'title': 'Doctor', 'subtitle': 'Add Doctor', 'icon': Icons.medical_services_outlined, 'color': Colors.blue},
      {'title': 'Discount', 'subtitle': 'Apply Discount', 'icon': Icons.local_offer_outlined, 'color': const Color(0xFF009688)},
      {'title': 'Coupon', 'subtitle': 'Apply Coupon', 'icon': Icons.confirmation_number_outlined, 'color': Colors.orange},
      {'title': 'Loyalty', 'subtitle': 'Add Points', 'icon': Icons.favorite_border_rounded, 'color': Colors.pink},
      {'title': 'Note', 'subtitle': 'Add Note', 'icon': Icons.note_add_outlined, 'color': Colors.blue.shade700},
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: action == actions.last ? 0 : 12.0),
            child: _QuickActionButton(
              title: action['title'] as String,
              subtitle: action['subtitle'] as String,
              icon: action['icon'] as IconData,
              color: action['color'] as Color,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _QuickActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Placeholder action
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped $title')));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: context.isDark ? context.cardBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.isDark ? context.dividerColor : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
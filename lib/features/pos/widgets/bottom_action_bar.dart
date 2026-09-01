import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final actions = [
      {'label': 'Coupon', 'icon': Icons.local_offer_outlined},
      {'label': 'Discount', 'icon': Icons.percent},
      {'label': 'Promo', 'icon': Icons.card_giftcard_outlined},
      {'label': 'Note', 'icon': Icons.note_alt_outlined},
      {'label': 'Kitchen Note', 'icon': Icons.kitchen_outlined},
      {'label': 'Bill Print', 'icon': Icons.print_outlined},
    ];

    return Container(
      height: isMobile ? 52 : 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: _BottomActionBtn(
              icon: action['icon'] as IconData,
              label: isMobile ? '' : (action['label'] as String),
              iconLabel: isMobile ? (action['label'] as String) : null,
              isMobile: isMobile,
              onTap: () => _handleAction(context, action['label'] as String),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action tapped'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _BottomActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? iconLabel;
  final bool isMobile;
  final VoidCallback onTap;

  const _BottomActionBtn({
    required this.icon,
    required this.label,
    this.iconLabel,
    this.isMobile = false,
    required this.onTap,
  });

  @override
  State<_BottomActionBtn> createState() => _BottomActionBtnState();
}

class _BottomActionBtnState extends State<_BottomActionBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primaryLight : Colors.transparent,
            border: Border(
              right: BorderSide(color: AppColors.borderLight),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: widget.isMobile ? 18 : 20,
                color: _isHovered ? AppColors.primary : AppColors.textSecondary,
              ),
              if (!widget.isMobile && widget.label.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: _isHovered ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else if (widget.isMobile && widget.iconLabel != null) ...[
                const SizedBox(height: 1),
                Text(
                  widget.iconLabel!,
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

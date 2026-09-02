import 'package:flutter/material.dart';
import 'dialogs/pos_dialogs.dart';

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
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 8,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;
          if (isNarrow) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  final isLast = index == actions.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 10),
                    child: SizedBox(
                      width: isMobile ? 60 : 120,
                      child: _BottomActionBtn(
                        icon: action['icon'] as IconData,
                        label: action['label'] as String,
                        isMobile: isMobile,
                        onTap: () => _handleAction(context, action['label'] as String),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return Row(
            children: actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              final isLast = index == actions.length - 1;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 12),
                  child: _BottomActionBtn(
                    icon: action['icon'] as IconData,
                    label: action['label'] as String,
                    isMobile: isMobile,
                    onTap: () => _handleAction(context, action['label'] as String),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    Widget dialog;
    switch (action) {
      case 'Coupon':
        dialog = const CouponDialog();
        break;
      case 'Discount':
        dialog = const DiscountDialog();
        break;
      case 'Promo':
        dialog = const PromoDialog();
        break;
      case 'Note':
        dialog = const NoteDialog(isKitchenNote: false);
        break;
      case 'Kitchen Note':
        dialog = const NoteDialog(isKitchenNote: true);
        break;
      case 'Bill Print':
        dialog = const BillPrintDialog();
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }
}

class _BottomActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isMobile;
  final VoidCallback onTap;

  const _BottomActionBtn({
    required this.icon,
    required this.label,
    this.isMobile = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: isMobile ? 40 : 48,
        decoration: BoxDecoration(
          color: primaryOrange.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryOrange.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isMobile ? 16 : 18,
              color: primaryOrange,
            ),
            if (!isMobile) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryOrange,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

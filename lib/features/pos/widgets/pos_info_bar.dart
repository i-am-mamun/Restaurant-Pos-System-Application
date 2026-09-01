import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/pos_provider.dart';

class POSInfoBar extends StatelessWidget {
  const POSInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 768 && screenWidth < 1100;

    return Padding(
      // The entire info bar is transparent, elements are individual white cards
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 12,
      ),
      child: Row(
        children: [
          // ── Left Side Info (Table, Guests, Waiter) ──
          _InfoCard(
            icon: Icons.groups_outlined,
            label: 'Table',
            value: 'T-05',
            hasDropdown: true,
            isMobile: isMobile,
          ),
          
          SizedBox(width: isMobile ? 8 : 16),
          
          _GuestsCard(isMobile: isMobile),
          
          SizedBox(width: isMobile ? 8 : 16),
          
          if (!isMobile) ...[
            _InfoCard(
              icon: Icons.person_outline,
              label: 'Waiter',
              value: 'John Doe',
              hasDropdown: true,
              isMobile: isMobile,
            ),
          ],

          const Spacer(),

          // ── Right Side Actions ──
          _ActionButtons(isMobile: isMobile, isTablet: isTablet),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// INFO CARD (White rounded rectangle for Table, Waiter)
// ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool hasDropdown;
  final bool isMobile;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.hasDropdown = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final darkBrown = const Color(0xFF5D4037); // Icon and Dropdown arrow color

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: isMobile ? 22 : 26, 
            color: darkBrown,
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 20),
            Icon(Icons.keyboard_arrow_down, size: 18, color: darkBrown),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// GUESTS CARD
// ─────────────────────────────────────────────────────────────────
class _GuestsCard extends StatelessWidget {
  final bool isMobile;
  const _GuestsCard({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final darkBrown = const Color(0xFF5D4037);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline, 
                size: isMobile ? 22 : 26, 
                color: darkBrown,
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guests',
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${provider.guests}',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Plus Button (Square with rounded corners)
              GestureDetector(
                onTap: provider.incrementGuests,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.add, size: 18, color: darkBrown),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// ACTION BUTTONS (Hold, Recall, Split, Transfer, Clear Order)
// ─────────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _ActionButtons({this.isMobile = false, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'Hold', 'icon': Icons.pause, 'color': const Color(0xFFFF7043)},
      {'label': 'Recall', 'icon': Icons.restore, 'color': const Color(0xFF7E57C2)},
      {'label': 'Split', 'icon': Icons.data_array, 'color': const Color(0xFF42A5F5)},
      {'label': 'Transfer', 'icon': Icons.sync_alt, 'color': const Color(0xFF66BB6A)},
      {'label': 'Clear Order', 'icon': Icons.delete_outline, 'color': const Color(0xFFEF5350)},
    ];

    final visibleButtons = isMobile
        ? buttons.sublist(0, 2)
        : isTablet
            ? buttons.sublist(0, 3)
            : buttons;

    return Row(
      children: visibleButtons.map((btn) {
        return _ActionButton(
          label: btn['label'] as String,
          icon: btn['icon'] as IconData,
          color: btn['color'] as Color,
          isMobile: isMobile,
          isTablet: isTablet,
        );
      }).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isMobile;
  final bool isTablet;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isMobile ? 8 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile || isTablet ? 12 : 16,
              vertical: isMobile || isTablet ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.04), // Very faint background
              border: Border.all(color: color.withOpacity(0.2), width: 1.5), // Crisp border
              borderRadius: BorderRadius.circular(8), // Rounded rectangles, NOT pills
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: isMobile || isTablet ? 16 : 18,
                  color: color,
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 14,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/pos_provider.dart';
import 'dialogs/pos_dialogs.dart';


class POSHeader extends StatelessWidget {
  const POSHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SizedBox(
      height: isMobile ? 64 : 74,
      child: CustomPaint(
        painter: _SimpleWavePainter(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 24,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── LOGO ──
              _LogoWidget(isMobile: isMobile),
              SizedBox(width: isMobile ? 10 : 32),

              // ── ORDER TYPE BUTTONS (Single White Pill) ──
              if (!isMobile) ...[
                const _OrderTypeSegmentedControl(),
                const Spacer(),
                // ── SEARCH BAR (White Pill) ──
                const _SearchBar(),
                const SizedBox(width: 24),
              ] else ...[
                const Spacer(),
              ],

              // ── RIGHT ICONS (No borders) ──
              _RightIcons(isMobile: isMobile),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BACKGROUND PAINTER (Exact match to image: one clean wave)
// ─────────────────────────────────────────────────────────────────
class _SimpleWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    // 1. Base gradient (Lighter orange to Mid orange)
    final basePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF7A45),
          Color(0xFFFF5722),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);
    canvas.drawRect(rect, basePaint);

    // 2. Single clean wave on the right side
    final wavePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF5722),
          Color(0xFFE64A19), // Darker orange at the bottom right
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final wavePath = Path();
    // Start the wave a bit after the logo
    wavePath.moveTo(w * 0.25, 0);
    // Smooth curve down and to the right
    wavePath.cubicTo(
      w * 0.35, 0,       // control point 1
      w * 0.30, h * 0.8, // control point 2
      w * 0.50, h,       // end point
    );
    // Complete the path along the bottom and right edges
    wavePath.lineTo(w, h);
    wavePath.lineTo(w, 0);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────
// LOGO (No borders, pure white icons/text)
// ─────────────────────────────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  final bool isMobile;
  const _LogoWidget({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Chef hat / food icon
        Icon(
          Icons.soup_kitchen, // Closest to chef hat with steam/bowl
          color: Colors.white,
          size: isMobile ? 32 : 40,
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ZestBite',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                height: 1.1,
              ),
            ),
            Text(
              'POS SYSTEM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// ORDER TYPE BUTTONS (Single white pill container)
// ─────────────────────────────────────────────────────────────────
class _OrderTypeSegmentedControl extends StatelessWidget {
  const _OrderTypeSegmentedControl();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Consumer<POSProvider>(
        builder: (context, provider, _) {
          final selected = provider.selectedOrderType;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SegmentButton(
                label: 'Dine In',
                icon: Icons.dining,
                isSelected: selected == 'dine_in',
                onTap: () => provider.selectOrderType('dine_in'),
              ),
              _VerticalDivider(),
              _SegmentButton(
                label: 'Take Away',
                icon: Icons.shopping_bag_outlined,
                isSelected: selected == 'take_away',
                onTap: () => provider.selectOrderType('take_away'),
              ),
              _VerticalDivider(),
              _SegmentButton(
                label: 'Delivery',
                icon: Icons.delivery_dining,
                isSelected: selected == 'delivery',
                onTap: () => provider.selectOrderType('delivery'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Exact colors from the image
    final color = isSelected ? const Color(0xFFFF5722) : Colors.black87;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      color: Colors.grey.shade300,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// SEARCH BAR (White pill)
// ─────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final barWidth = w >= 1100 ? 300.0 : 240.0;

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          width: barWidth,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: provider.setSearchQuery,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Icon(Icons.search, color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// RIGHT ICONS (Pure white icons, no borders/backgrounds)
// ─────────────────────────────────────────────────────────────────
class _RightIcons extends StatelessWidget {
  final bool isMobile;
  const _RightIcons({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile) ...[
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const BarcodeScannerDialog(),
              );
            },
            splashRadius: 24,
          ),
          const SizedBox(width: 4),
        ],
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const NotificationListDialog(),
                );
              },
              splashRadius: 24,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (val) {
            final provider = Provider.of<POSProvider>(context, listen: false);
            if (val == 'held') {
              showDialog(context: context, builder: (_) => const HeldOrdersDialog());
            } else if (val == 'clear') {
              provider.clearCart();
            } else if (val == 'shift') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daily Shift Sales Total: \$${248.50} | Cash Drawer: \$500.00'), backgroundColor: Color(0xFFFF6D00)),
              );
            } else if (val == 'help') {
              showAboutDialog(
                context: context,
                applicationName: 'ZestBite POS System',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 ZestBite Technologies Inc.',
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'held', child: Row(children: [Icon(Icons.pause_circle_outline, size: 18), SizedBox(width: 8), Text('Held Orders')])),
            const PopupMenuItem(value: 'shift', child: Row(children: [Icon(Icons.point_of_sale, size: 18), SizedBox(width: 8), Text('Shift Report')])),
            const PopupMenuItem(value: 'clear', child: Row(children: [Icon(Icons.cleaning_services, size: 18), SizedBox(width: 8), Text('Clear Cart')])),
            const PopupMenuItem(value: 'help', child: Row(children: [Icon(Icons.info_outline, size: 18), SizedBox(width: 8), Text('System Info')])),
          ],
        ),
      ],
    );
  }
}


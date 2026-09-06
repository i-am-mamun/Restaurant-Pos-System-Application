import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../providers/wholesaler_provider.dart';
import '../theme/wholesaler_colors.dart';
import 'wholesaler_dialogs.dart';

// ─────────────────────────────────────────────────────────────────
// BOTTOM FOOTER: Quick Actions + Order Meta Info
// ─────────────────────────────────────────────────────────────────
class WholesalerFooterBar extends StatelessWidget {
  const WholesalerFooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final w = context.watch<WholesalerProvider>();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark
            ? WholesalerColors.inputBg(true).withOpacity(0.8)
            : Colors.white,
        border: Border(top: BorderSide(color: WholesalerColors.border(isDark))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick actions row
          _QuickActionsRow(isDark: isDark, w: w, isMobile: isMobile),
          // Order meta row
          if (!isMobile) _OrderMetaRow(isDark: isDark, w: w),
        ],
      ),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────
class _QuickActionsRow extends StatelessWidget {
  final bool isDark;
  final WholesalerProvider w;
  final bool isMobile;
  const _QuickActionsRow({required this.isDark, required this.w, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _FooterAction(
        icon: Icons.person_add_rounded,
        label: 'Customer',
        sublabel: 'Add / Search',
        color: WholesalerColors.primary,
        onTap: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<WholesalerProvider>(),
            child: const WCustomerDialog(),
          ),
        ),
      ),
      _FooterAction(
        icon: Icons.pause_circle_rounded,
        label: 'Hold Order',
        sublabel: 'Park Current Order',
        color: WholesalerColors.accentOrange,
        onTap: () {
          if (context.read<WholesalerProvider>().items.isEmpty) {
            _snack(context, 'Add items first');
            return;
          }
          showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<WholesalerProvider>(),
              child: const WHoldOrderDialog(),
            ),
          );
        },
      ),
      _FooterAction(
        icon: Icons.history_rounded,
        label: 'Recent Orders',
        sublabel: 'View All',
        color: WholesalerColors.accentBlue,
        onTap: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<WholesalerProvider>(),
            child: const WRecentOrdersDialog(),
          ),
        ),
      ),
      _FooterAction(
        icon: Icons.request_quote_rounded,
        label: 'Quotations',
        sublabel: 'Create / View',
        color: WholesalerColors.accentPurple,
        onTap: () => _snack(context, '📋 Quotation module opening...'),
      ),
      _FooterAction(
        icon: Icons.swap_horiz_rounded,
        label: 'Stock Transfer',
        sublabel: 'Between Warehouses',
        color: WholesalerColors.accentGreen,
        onTap: () => _snack(context, '🔄 Stock Transfer module opening...'),
      ),
      _FooterAction(
        icon: Icons.receipt_rounded,
        label: 'Sales History',
        sublabel: 'View Transactions',
        color: const Color(0xFF0EA5E9),
        onTap: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<WholesalerProvider>(),
            child: const WRecentOrdersDialog(),
          ),
        ),
      ),
      _FooterAction(
        icon: Icons.undo_rounded,
        label: 'Returns',
        sublabel: 'Manage Returns',
        color: WholesalerColors.accentRed,
        onTap: () => _snack(context, '↩️ Returns module opening...'),
      ),
      _FooterAction(
        icon: Icons.add_card_rounded,
        label: 'Expense',
        sublabel: 'Add Expense',
        color: const Color(0xFFD946EF),
        onTap: () => _snack(context, '💳 Expense module opening...'),
      ),
      _FooterAction(
        icon: Icons.more_horiz_rounded,
        label: 'More',
        sublabel: '',
        color: WholesalerColors.textSecondary(isDark),
        onTap: () => _snack(context, 'More options...'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              _FooterBtn(action: actions[i], isDark: isDark, isMobile: isMobile),
            ],
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: WholesalerColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

class _FooterAction {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });
}

class _FooterBtn extends StatefulWidget {
  final _FooterAction action;
  final bool isDark;
  final bool isMobile;
  const _FooterBtn({required this.action, required this.isDark, required this.isMobile});

  @override
  State<_FooterBtn> createState() => _FooterBtnState();
}

class _FooterBtnState extends State<_FooterBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.action;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: a.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: a.color.withOpacity(widget.isDark ? 0.12 : 0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: a.color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(a.icon, size: 14, color: a.color),
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(a.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: WholesalerColors.textPrimary(widget.isDark),
                      )),
                  if (a.sublabel.isNotEmpty)
                    Text(a.sublabel,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: WholesalerColors.textSecondary(widget.isDark),
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

// ── Order Meta Info Row ───────────────────────────────────────────
class _OrderMetaRow extends StatelessWidget {
  final bool isDark;
  final WholesalerProvider w;
  const _OrderMetaRow({required this.isDark, required this.w});

  @override
  Widget build(BuildContext context) {
    final metaItems = [
      _MetaItem(Icons.warehouse_rounded, 'Warehouse', w.selectedWarehouse, WholesalerColors.primary),
      _MetaItem(Icons.person_rounded, 'Sales Rep', w.salesRep, WholesalerColors.accentBlue),
      _MetaItem(Icons.calendar_today_rounded, 'Delivery Date',
          '20 May, 2025\nTue, 10:00 AM', WholesalerColors.accentOrange),
      _MetaItem(Icons.local_shipping_rounded, 'Delivery Method', w.deliveryMethod, WholesalerColors.accentGreen),
      _MetaItem(Icons.credit_card_rounded, 'Payment Term', w.paymentTerm, WholesalerColors.accentPurple),
      _MetaItem(Icons.percent_rounded, 'Commission',
          '${w.commission}%\nEst. ৳${w.commissionAmount.toStringAsFixed(2)}',
          const Color(0xFF0EA5E9)),
      _MetaItem(Icons.note_alt_rounded, 'Note', w.note.isEmpty ? 'Add Note' : w.note,
          WholesalerColors.textSecondary(isDark)),
      _MetaItem(Icons.attach_file_rounded, 'Attachments', '0 Files', WholesalerColors.textSecondary(isDark)),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: metaItems.map((m) => _MetaChip(item: m, isDark: isDark)).toList(),
        ),
      ),
    );
  }
}

class _MetaItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _MetaItem(this.icon, this.label, this.value, this.color);
}

class _MetaChip extends StatelessWidget {
  final _MetaItem item;
  final bool isDark;
  const _MetaChip({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? WholesalerColors.inputBg(true) : WholesalerColors.panelBg(false),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WholesalerColors.border(isDark)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(item.icon, size: 11, color: item.color),
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.label,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: WholesalerColors.textSecondary(isDark),
                  )),
              Text(
                item.value,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: WholesalerColors.textPrimary(isDark),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

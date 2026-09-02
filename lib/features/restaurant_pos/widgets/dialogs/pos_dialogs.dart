import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/menu_item.dart';
import '../../../../core/providers/pos_provider.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/number_utils.dart';

// ─────────────────────────────────────────────────────────────────
// TABLE SELECTION DIALOG
// ─────────────────────────────────────────────────────────────────
class TableSelectionDialog extends StatelessWidget {
  const TableSelectionDialog({super.key});

  static const List<Map<String, dynamic>> tables = [
    {'name': 'T-01', 'capacity': 2, 'isOccupied': false},
    {'name': 'T-02', 'capacity': 4, 'isOccupied': true},
    {'name': 'T-03', 'capacity': 4, 'isOccupied': false},
    {'name': 'T-04', 'capacity': 6, 'isOccupied': false},
    {'name': 'T-05', 'capacity': 4, 'isOccupied': true}, // Current
    {'name': 'T-06', 'capacity': 2, 'isOccupied': false},
    {'name': 'T-07', 'capacity': 8, 'isOccupied': true},
    {'name': 'T-08', 'capacity': 4, 'isOccupied': false},
    {'name': 'VIP-01', 'capacity': 10, 'isOccupied': false},
    {'name': 'VIP-02', 'capacity': 12, 'isOccupied': true},
    {'name': 'Outdoor-01', 'capacity': 4, 'isOccupied': false},
    {'name': 'Outdoor-02', 'capacity': 4, 'isOccupied': false},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.table_restaurant_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('select_table', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Legend
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(Colors.green.shade600, AppStrings.get('available', locale)),
                  const SizedBox(width: 16),
                  _buildLegend(Colors.orange.shade800, AppStrings.get('occupied', locale)),
                  const SizedBox(width: 16),
                  _buildLegend(primaryOrange, AppStrings.get('selected_label', locale)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: tables.map<Widget>((t) {
                    final tableName = t['name'] as String;
                    final isCurrent = provider.tableNumber == tableName;
                    final isOccupied = t['isOccupied'] as bool;

                    Color cardColor = isCurrent
                        ? primaryOrange
                        : (isOccupied ? Colors.orange.shade50 : Colors.green.shade50);
                    Color borderColor = isCurrent
                        ? primaryOrange
                        : (isOccupied ? Colors.orange.shade300 : Colors.green.shade300);
                    Color textColor = isCurrent
                        ? Colors.white
                        : (isOccupied ? Colors.orange.shade900 : Colors.green.shade900);

                    return GestureDetector(
                      onTap: () {
                        provider.selectTable(tableName);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 105,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: primaryOrange.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Text(
                              NumberUtils.toLocalized(tableName, locale),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, size: 12, color: textColor.withOpacity(0.8)),
                                const SizedBox(width: 2),
                                Text(
                                  '${NumberUtils.toLocalized(t['capacity'], locale)} ${AppStrings.get('seats', locale)}',
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('close', locale)),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WAITER SELECTION DIALOG
// ─────────────────────────────────────────────────────────────────
class WaiterSelectionDialog extends StatelessWidget {
  const WaiterSelectionDialog({super.key});

  static const List<Map<String, String>> waiters = [
    {'name': 'John Doe', 'role': 'Head Server', 'avatar': '👨‍🍳'},
    {'name': 'Sarah Smith', 'role': 'Senior Waiter', 'avatar': '👩‍🍳'},
    {'name': 'Alex Johnson', 'role': 'Waiter', 'avatar': '🧑‍🍳'},
    {'name': 'Maria Garcia', 'role': 'Waitress', 'avatar': '👩‍🍳'},
    {'name': 'David Miller', 'role': 'Junior Waiter', 'avatar': '🧑‍🍳'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.person_outline_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('select_server', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 360,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: waiters.map<Widget>((w) {
            final isSelected = provider.waiter == w['name'];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryOrange.withOpacity(0.08) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryOrange : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: ListTile(
                leading: Text(w['avatar']!, style: const TextStyle(fontSize: 24)),
                title: Text(
                  w['name']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? primaryOrange : Colors.black87,
                  ),
                ),
                subtitle: Text(w['role']!),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded, color: primaryOrange)
                    : null,
                onTap: () {
                  provider.selectWaiter(w['name']!);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('cancel', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// HELD ORDERS DIALOG
// ─────────────────────────────────────────────────────────────────
class HeldOrdersDialog extends StatelessWidget {
  const HeldOrdersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);
    final isBn = locale == 'bn';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.pause_circle_outline_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('held_orders', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${provider.heldOrders.length} ${isBn ? 'হোল্ড' : 'Held'}',
              style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 360,
        child: provider.heldOrders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.get('no_held_orders', locale),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: provider.heldOrders.length,
                itemBuilder: (context, index) {
                  final held = provider.heldOrders[index];
                  final timeStr =
                      '${held.timestamp.hour.toString().padLeft(2, '0')}:${held.timestamp.minute.toString().padLeft(2, '0')}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              held.id,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: primaryOrange,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              timeStr,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.table_restaurant, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(held.tableNumber, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(width: 10),
                            Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                held.waiter,
                                style: const TextStyle(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '৳${NumberUtils.toLocalized(held.total.toStringAsFixed(2), locale)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${NumberUtils.toLocalized(held.items.length, locale)} ${isBn ? 'আইটেম' : 'items'}: ${held.items.map((i) => "${NumberUtils.toLocalized(i.quantity, locale)}x ${i.menuItem.localizedName(locale)}").join(', ')}',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  provider.deleteHeldOrder(held.id);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: BorderSide(color: Colors.red.shade200),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                ),
                                icon: const Icon(Icons.delete_outline, size: 14),
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(AppStrings.get('delete', locale), style: const TextStyle(fontSize: 12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  provider.recallOrder(held);
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryOrange,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                ),
                                icon: const Icon(Icons.restore, size: 14),
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(AppStrings.get('recall_order', locale), style: const TextStyle(fontSize: 12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('close', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// SPLIT BILL DIALOG
// ─────────────────────────────────────────────────────────────────
class SplitBillDialog extends StatefulWidget {
  const SplitBillDialog({super.key});

  @override
  State<SplitBillDialog> createState() => _SplitBillDialogState();
}

class _SplitBillDialogState extends State<SplitBillDialog> {
  int _splitCount = 2;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final total = provider.totalPayable;
    final perPerson = total / _splitCount;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.call_split_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Text(
            AppStrings.get('split_bill', locale),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryOrange.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${AppStrings.get('total_bill', locale)}:', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(
                    '৳${NumberUtils.toLocalized(total.toStringAsFixed(2), locale)}',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: primaryOrange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.get('split_equally', locale),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _splitCount > 2 ? () => setState(() => _splitCount--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    '${NumberUtils.toLocalized(_splitCount, locale)} ${AppStrings.get('people', locale)}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _splitCount < 10 ? () => setState(() => _splitCount++) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppStrings.get('each_pays', locale)}:', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                      Text(
                        '৳${NumberUtils.toLocalized(perPerson.toStringAsFixed(2), locale)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('cancel', locale)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            final msg = locale == 'bn' 
              ? 'বিলটি $_splitCount জনের মধ্যে ভাগ করা হয়েছে (৳${perPerson.toStringAsFixed(2)} করে)'
              : 'Bill split into $_splitCount receipts (৳${perPerson.toStringAsFixed(2)} each)';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: primaryOrange,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(AppStrings.get('confirm_split', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// TRANSFER ORDER DIALOG
// ─────────────────────────────────────────────────────────────────
class TransferOrderDialog extends StatelessWidget {
  const TransferOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.sync_alt_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('transfer_order', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.get('current_table', locale)}: ${NumberUtils.toLocalized(provider.tableNumber, locale)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 14),
            Text(
              AppStrings.get('destination_table', locale),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['T-01', 'T-02', 'T-03', 'T-04', 'T-06', 'T-07', 'T-08', 'VIP-01']
                  .where((t) => t != provider.tableNumber)
                  .map<Widget>((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: false,
                  onSelected: (selected) {
                    provider.transferTable(t);
                    Navigator.of(context).pop();
                    final msg = locale == 'bn' ? 'অর্ডারটি $t এ স্থানান্তর করা হয়েছে' : 'Order transferred to $t';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg), backgroundColor: primaryOrange),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('cancel', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// CUSTOM ITEM DIALOG
// ─────────────────────────────────────────────────────────────────
class CustomItemDialog extends StatefulWidget {
  const CustomItemDialog({super.key});

  @override
  State<CustomItemDialog> createState() => _CustomItemDialogState();
}

class _CustomItemDialogState extends State<CustomItemDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'starters';
  bool _isVeg = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context, listen: false);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.soup_kitchen_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('add_custom_item', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppStrings.get('item_name', locale),
                hintText: locale == 'bn' ? 'যেমন: স্পেশাল শেফ সালাদ' : 'e.g. Special Chef Salad',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppStrings.get('price', locale),
                hintText: 'e.g. 12.50',
                prefixText: '৳ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: AppStrings.get('category', locale),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: AppData.categories
                  .where((c) => c.id != 'all' && c.id != 'popular')
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.localizedName(locale))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(AppStrings.get('veg_item', locale), style: const TextStyle(fontWeight: FontWeight.w600)),
              value: _isVeg,
              activeThumbColor: Colors.green,
              onChanged: (val) => setState(() => _isVeg = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('cancel', locale)),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
            if (name.isNotEmpty && price > 0) {
              final newItem = MenuItem(
                id: DateTime.now().millisecondsSinceEpoch,
                name: name,
                price: price,
                category: _selectedCategory,
                imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop',
                isVeg: _isVeg,
              );
              provider.addCustomItem(newItem);
              Navigator.of(context).pop();
              final msg = locale == 'bn' ? '\"$name\" অর্ডারে যোগ করা হয়েছে!' : '\"$name\" added to order!';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: primaryOrange),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(AppStrings.get('add_to_cart', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// COUPON DIALOG
// ─────────────────────────────────────────────────────────────────
class CouponDialog extends StatefulWidget {
  const CouponDialog({super.key});

  @override
  State<CouponDialog> createState() => _CouponDialogState();
}

class _CouponDialogState extends State<CouponDialog> {
  final _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.local_offer_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('coupon', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: locale == 'bn' ? 'কুপন কোড লিখুন' : 'Enter coupon code',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final success = provider.applyCoupon(_couponController.text);
                    if (success) {
                      Navigator.of(context).pop();
                      final msg = locale == 'bn' 
                        ? 'কুপন \"${_couponController.text.toUpperCase()}\" প্রয়োগ করা হয়েছে!' 
                        : 'Coupon \"${_couponController.text.toUpperCase()}\" applied!';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg), backgroundColor: primaryOrange),
                      );
                    } else {
                      final error = locale == 'bn' ? 'অবৈধ কুপন কোড' : 'Invalid coupon code';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(locale == 'bn' ? 'প্রয়োগ' : 'Apply'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              locale == 'bn' ? 'উপলব্ধ কুপনসমূহ:' : 'Available Coupons:',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 10),
            ...POSProvider.availableCoupons.map<Widget>((c) {
              final isApplied = provider.appliedCoupon == c.code;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isApplied ? primaryOrange.withOpacity(0.08) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isApplied ? primaryOrange : Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.code,
                            style: TextStyle(fontWeight: FontWeight.w900, color: primaryOrange, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(c.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        provider.applyCoupon(c.code);
                        Navigator.of(context).pop();
                        final msg = locale == 'bn' ? 'কুপন ${c.code} প্রয়োগ করা হয়েছে!' : 'Coupon ${c.code} applied!';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg), backgroundColor: primaryOrange),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApplied ? Colors.green : primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isApplied ? (locale == 'bn' ? 'প্রযুক্ত' : 'Applied') : (locale == 'bn' ? 'ব্যবহার' : 'Use')),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        if (provider.appliedCoupon != null)
          TextButton(
            onPressed: () {
              provider.removeCoupon();
              Navigator.of(context).pop();
            },
            child: Text(locale == 'bn' ? 'কুপন মুছুন' : 'Remove Coupon', style: const TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('close', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// DISCOUNT DIALOG
// ─────────────────────────────────────────────────────────────────
class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  final _amountController = TextEditingController();
  bool _isPercentage = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.percent_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('discount', locale),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle % vs $
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(locale == 'bn' ? 'শতাংশ (%)' : 'Percentage (%)')),
                ButtonSegment(value: false, label: Text(locale == 'bn' ? 'নির্ধারিত পরিমাণ (৳)' : 'Fixed Amount (৳)')),
              ],
              selected: {_isPercentage},
              onSelectionChanged: (val) => setState(() => _isPercentage = val.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _isPercentage 
                  ? (locale == 'bn' ? 'ছাড়ের শতাংশ' : 'Discount Percentage') 
                  : (locale == 'bn' ? 'ছাড়ের পরিমাণ' : 'Discount Amount'),
                suffixText: _isPercentage ? '%' : '৳',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Text(locale == 'bn' ? 'প্রিসেটসমূহ:' : 'Presets:', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _isPercentage
                  ? [5, 10, 15, 20, 25].map((p) {
                      return ActionChip(
                        label: Text('$p%'),
                        onPressed: () {
                          provider.applyDiscount(percent: p.toDouble());
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList()
                  : [2, 5, 10, 15, 20].map((a) {
                      return ActionChip(
                        label: Text('৳$a'),
                        onPressed: () {
                          provider.applyDiscount(amount: a.toDouble());
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.get('cancel', locale)),
        ),
        ElevatedButton(
          onPressed: () {
            final val = double.tryParse(_amountController.text) ?? 0.0;
            if (val > 0) {
              if (_isPercentage) {
                provider.applyDiscount(percent: val);
              } else {
                provider.applyDiscount(amount: val);
              }
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(locale == 'bn' ? 'ছাড় প্রয়োগ করুন' : 'Apply Discount'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PROMO DIALOG
// ─────────────────────────────────────────────────────────────────
class PromoDialog extends StatelessWidget {
  const PromoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);

    final promos = [
      {
        'title': locale == 'bn' ? 'হ্যাপি আওয়ার ১৫% ছাড়' : 'Happy Hour 15% OFF', 
        'desc': locale == 'bn' ? 'দুপুর ২:০০ - বিকাল ৫:০০ পর্যন্ত বৈধ' : 'Valid 2:00 PM - 5:00 PM', 
        'action': () => provider.applyDiscount(percent: 15)
      },
      {
        'title': locale == 'bn' ? 'শেফ স্পেশাল ডিল' : 'Chef Special Deal', 
        'desc': locale == 'bn' ? '৳৩০+ অর্ডারে ৳৫ ছাড়' : '৳5 Off on orders ৳30+', 
        'action': () => provider.applyDiscount(amount: 5)
      },
      {
        'title': locale == 'bn' ? 'উইকেন্ড কম্বো ১০%' : 'Weekend Combo 10%', 
        'desc': locale == 'bn' ? 'প্রধান খাবারের উপর প্রযোজ্য' : 'Applicable on main course', 
        'action': () => provider.applyDiscount(percent: 10)
      },
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.card_giftcard_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('promo', locale), 
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: promos.map<Widget>((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryOrange.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['title'] as String, style: TextStyle(fontWeight: FontWeight.w800, color: primaryOrange, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(p['desc'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      (p['action'] as Function)();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(locale == 'bn' ? 'প্রয়োগ' : 'Apply'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppStrings.get('close', locale))),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// NOTE DIALOG (Order Note & Kitchen Note)
// ─────────────────────────────────────────────────────────────────
class NoteDialog extends StatefulWidget {
  final bool isKitchenNote;
  const NoteDialog({super.key, this.isKitchenNote = false});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState() ;
    final provider = Provider.of<POSProvider>(context, listen: false);
    _noteController = TextEditingController(
      text: widget.isKitchenNote ? provider.kitchenNote : provider.orderNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final primaryOrange = const Color(0xFFFF6D00);
    final title = widget.isKitchenNote ? AppStrings.get('kitchen_note', locale) : AppStrings.get('note', locale);

    final presetChips = widget.isKitchenNote
        ? (locale == 'bn' 
            ? ['কম ঝাল', 'অতিরিক্ত ঝাল', 'পেঁয়াজ ছাড়া', 'অ্যালার্জি সতর্কবার্তা', 'আলাদা প্যাকিং']
            : ['Less Spicy', 'Extra Hot', 'No Onion', 'Allergy Alert', 'Separate Packing'])
        : (locale == 'bn'
            ? ['দ্রুত সার্ভ করুন', 'ভিআইপি গেস্ট', 'আলাদা রসিদ প্রয়োজন', 'জন্মদিন স্পেশাল']
            : ['Server Table Fast', 'VIP Guest', 'Split Receipt Required', 'Birthday Special']);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.isKitchenNote ? Icons.kitchen_rounded : Icons.note_alt_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: locale == 'bn' ? 'এখানে নির্দেশাবলী লিখুন...' : 'Enter instructions here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            Text(locale == 'bn' ? 'দ্রুত চিপস:' : 'Quick Chips:', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: presetChips.map<Widget>((chip) {
                return ActionChip(
                  label: Text(chip, style: const TextStyle(fontSize: 11)),
                  onPressed: () {
                    if (_noteController.text.isEmpty) {
                      _noteController.text = chip;
                    } else {
                      _noteController.text += ', $chip';
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppStrings.get('cancel', locale))),
        ElevatedButton(
          onPressed: () {
            if (widget.isKitchenNote) {
              provider.setKitchenNote(_noteController.text);
            } else {
              provider.setOrderNote(_noteController.text);
            }
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(AppStrings.get('save', locale)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BILL PRINT DIALOG
// ─────────────────────────────────────────────────────────────────
// BILL PRINT / RECEIPT DIALOG
// ─────────────────────────────────────────────────────────────────
class BillPrintDialog extends StatelessWidget {
  const BillPrintDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    const primaryOrange = Color(0xFFFF6D00);
    final isBn = locale == 'bn';
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}'
        '  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Hardcoded colors for the receipt area to ensure perfect visibility regardless of theme
    const receiptBg = Colors.white;
    const receiptTextPrimary = Color(0xFF1A1A1A);
    const receiptTextSecondary = Color(0xFF666666);
    const receiptDivider = Color(0xFFE0E0E0);
    const receiptLightBg = Color(0xFFF8F9FA);

    return AlertDialog(
      backgroundColor: context.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryOrange.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.print_rounded, color: primaryOrange, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isBn ? 'বিল / রসিদ প্রিভিউ' : 'Bill / Receipt Preview',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: context.textPrimary),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          maxWidth: 420,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: receiptBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(context.isDark ? 0.5 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Restaurant Header ─────────────────────────
                Text(
                  isBn ? 'জেস্টবাইট রেস্তোরাঁ' : 'ZESTBITE RESTAURANT',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: receiptTextPrimary, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  isBn ? '১২৩ কুলিনারি এভিনিউ, ফুডভিল' : '123 Culinary Ave, Foodville',
                  style: const TextStyle(fontSize: 12, color: receiptTextSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  isBn ? 'ফোন: ০১৭০০-০০০০০০' : 'Tel: (555) 123-4567',
                  style: const TextStyle(fontSize: 12, color: receiptTextSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: receiptDivider,
                ),
                const SizedBox(height: 16),

                // ── Order Metadata ────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: receiptLightBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _receiptInfoRow(isBn ? 'টেবিল' : 'Table', provider.tableNumber, isBn ? 'সার্ভার' : 'Server', provider.waiter, receiptTextPrimary, receiptTextSecondary),
                      const SizedBox(height: 8),
                      _receiptInfoRow(isBn ? 'ধরন' : 'Type', isBn ? _translateOrderType(provider.selectedOrderType) : provider.selectedOrderType.toUpperCase().replaceAll('_', ' '), isBn ? 'অতিথি' : 'Guests', '${provider.guests}', receiptTextPrimary, receiptTextSecondary),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isBn ? 'তারিখ ও সময়' : 'Date & Time', style: const TextStyle(fontSize: 11, color: receiptTextSecondary, fontWeight: FontWeight.w600)),
                          Text(dateStr, style: const TextStyle(fontSize: 11, color: receiptTextPrimary, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Items Table Header ────────────────────────
                Row(
                  children: [
                    Expanded(child: Text(isBn ? 'আইটেম' : 'Item', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: receiptTextPrimary))),
                    Text(isBn ? 'পরিমাণ' : 'Qty', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: receiptTextSecondary)),
                    const SizedBox(width: 16),
                    SizedBox(width: 70, child: Text(isBn ? 'মূল্য' : 'Price', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: receiptTextSecondary))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(height: 1, width: double.infinity, color: receiptDivider),
                const SizedBox(height: 12),

                // ── Items List ────────────────────────────────
                ...provider.cartItems.map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.menuItem.localizedName(locale),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: receiptTextPrimary),
                          ),
                        ),
                        Text('x${item.quantity}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: receiptTextSecondary)),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 70,
                          child: Text('৳${NumberUtils.toLocalized(item.totalPrice.toStringAsFixed(2), locale)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: receiptTextPrimary)),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Container(height: 1, width: double.infinity, color: receiptDivider),
                const SizedBox(height: 16),

                // ── Totals ────────────────────────────────────
                _receiptPriceRow(isBn ? 'সাবটোটাল' : 'Subtotal', '৳${NumberUtils.toLocalized(provider.subtotal.toStringAsFixed(2), locale)}', receiptTextSecondary, receiptTextPrimary),
                if (provider.discountValue > 0)
                  _receiptPriceRow(isBn ? 'ছাড়' : 'Discount', '-৳${NumberUtils.toLocalized(provider.discountValue.toStringAsFixed(2), locale)}', receiptTextSecondary, Colors.green.shade700),
                _receiptPriceRow(isBn ? 'ট্যাক্স (৮%)' : 'Tax (8%)', '৳${NumberUtils.toLocalized(provider.tax.toStringAsFixed(2), locale)}', receiptTextSecondary, receiptTextPrimary),
                _receiptPriceRow(isBn ? 'সার্ভিস চার্জ (৪%)' : 'Service (4%)', '৳${NumberUtils.toLocalized(provider.serviceCharge.toStringAsFixed(2), locale)}', receiptTextSecondary, receiptTextPrimary),
                const SizedBox(height: 12),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: receiptDivider, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'মোট পরিশোধযোগ্য' : 'TOTAL PAYABLE',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: receiptTextPrimary),
                      ),
                      Text(
                        '৳${NumberUtils.toLocalized(provider.totalPayable.toStringAsFixed(2), locale)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: primaryOrange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Footer ────────────────────────────────────
                Text(
                  isBn ? 'আমাদের সাথে খাওয়ার জন্য ধন্যবাদ!' : 'Thank you for dining with us!',
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: receiptTextSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  isBn ? 'অনুগ্রহ করে আবার আসুন 🙏' : 'Please visit us again 🙏',
                  style: const TextStyle(fontSize: 12, color: receiptTextSecondary, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(isBn ? 'বন্ধ করুন' : 'Close', style: TextStyle(color: context.textSecondary, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isBn ? 'থার্মাল প্রিন্টারে রসিদ পাঠানো হচ্ছে...' : 'Sending receipt to thermal printer...'),
                backgroundColor: primaryOrange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.print_rounded, size: 20),
          label: Text(isBn ? 'প্রিন্ট করুন' : 'Print Now', style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _receiptInfoRow(String l1, String v1, String l2, String v2, Color primary, Color secondary) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text('$l1: ', style: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w600)),
              Text(v1, style: TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Row(
          children: [
            Text('$l2: ', style: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w600)),
            Text(v2, style: TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _receiptPriceRow(String label, String val, Color labelColor, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w500)),
          Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  String _translateOrderType(String type) {
    switch (type) {
      case 'dine_in': return 'ডাইন-ইন';
      case 'take_away': return 'টেকঅ্যাওয়ে';
      case 'delivery': return 'ডেলিভারি';
      default: return type.toUpperCase();
    }
  }
}



// ─────────────────────────────────────────────────────────────────
// CHECKOUT PAYMENT DIALOG
// ─────────────────────────────────────────────────────────────────
class CheckoutPaymentDialog extends StatefulWidget {
  const CheckoutPaymentDialog({super.key});

  @override
  State<CheckoutPaymentDialog> createState() => _CheckoutPaymentDialogState();
}

class _CheckoutPaymentDialogState extends State<CheckoutPaymentDialog> {
  String _selectedMethod = 'Cash';
  double _cashTendered = 0.0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
    final locale = context.watch<AppProvider>().locale;
    final isBn = locale == 'bn';
    final total = provider.totalPayable;
    final change = _cashTendered > total ? _cashTendered - total : 0.0;
    const primaryOrange = Color(0xFFFF6D00);

    return AlertDialog(
      backgroundColor: context.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.payments_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isBn ? 'চেকআউট ও পেমেন্ট' : 'Checkout & Payment',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: context.textPrimary),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          maxWidth: 420,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Total Amount Box ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryOrange.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        isBn ? 'মোট পরিমাণ:' : 'Total Amount Due:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: context.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('৳${NumberUtils.toLocalized(total.toStringAsFixed(2), locale)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: primaryOrange)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Payment Method ──
              Text(
                isBn ? 'পেমেন্ট পদ্ধতি বেছে নিন:' : 'Select Payment Method:',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _methodTile(context, isBn ? 'নগদ' : 'Cash', 'Cash', Icons.money, isBn),
                  const SizedBox(width: 8),
                  _methodTile(context, isBn ? 'কার্ড' : 'Card', 'Card', Icons.credit_card, isBn),
                  const SizedBox(width: 8),
                  _methodTile(context, isBn ? 'QR পে' : 'QR Pay', 'QR Pay', Icons.qr_code, isBn),
                ],
              ),
              const SizedBox(height: 16),

              // ── Cash Tendered ──
              if (_selectedMethod == 'Cash') ...[
                Text(
                  isBn ? 'প্রদত্ত নগদ:' : 'Cash Tendered:',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textPrimary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [20, 50, 100, 200, 500].map<Widget>((amt) {
                    final selected = _cashTendered == amt.toDouble();
                    return GestureDetector(
                      onTap: () => setState(() => _cashTendered = amt.toDouble()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: selected ? primaryOrange : context.inputBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: selected ? primaryOrange : context.borderColor),
                        ),
                        child: Text('৳${NumberUtils.toLocalized(amt, locale)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : context.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: change > 0
                        ? Colors.green.withOpacity(context.isDark ? 0.15 : 0.08)
                        : context.inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: change > 0 ? Colors.green.withOpacity(0.4) : context.borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'ফেরত দেওয়ার পরিমাণ:' : 'Change to Return:',
                        style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '৳${NumberUtils.toLocalized(change.toStringAsFixed(2), locale)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: change > 0 ? Colors.green : context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(isBn ? 'বাতিল' : 'Cancel', style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final completedOrder = provider.placeOrder(paymentMethod: _selectedMethod);
            Navigator.of(context).pop();
            _showSuccessDialog(context, completedOrder, locale);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(isBn ? 'অর্ডার সম্পন্ন করুন' : 'Complete Order', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _methodTile(BuildContext context, String displayLabel, String key, IconData icon, bool isBn) {
    final isSel = _selectedMethod == key;
    const primaryOrange = Color(0xFFFF6D00);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSel ? primaryOrange : context.inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSel ? primaryOrange : context.borderColor),
            boxShadow: isSel ? [BoxShadow(color: primaryOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSel ? Colors.white : context.textSecondary, size: 24),
              const SizedBox(height: 6),
              Text(
                displayLabel,
                style: TextStyle(
                  color: isSel ? Colors.white : context.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, CompletedOrder order, String locale) {
    final isBn = locale == 'bn';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              isBn ? 'অর্ডার সফলভাবে সম্পন্ন!' : 'Order Placed Successfully!',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ctx.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text('${isBn ? 'অর্ডার ID' : 'Order ID'}: ${order.id}',
              style: TextStyle(color: ctx.textSecondary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              '${isBn ? 'পেমেন্ট' : 'Total Paid'}: ৳${NumberUtils.toLocalized(order.total.toStringAsFixed(2), locale)} ${isBn ? 'via' : 'via'} ${order.paymentMethod}',
              style: TextStyle(fontWeight: FontWeight.w600, color: ctx.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isBn ? 'নতুন অর্ডার শুরু করুন' : 'Start New Order'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// NOTIFICATIONS & SCANNER DIALOGS
// ─────────────────────────────────────────────────────────────────
class NotificationListDialog extends StatelessWidget {
  const NotificationListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppProvider>().locale;
    final isBn = locale == 'bn';
    final primaryOrange = const Color(0xFFFF6D00);
    
    final notifications = [
      {
        'title': isBn ? 'রান্নাঘরের অর্ডার তৈরি' : 'Kitchen Order Ready', 
        'subtitle': isBn ? 'টেবিল T-02 এর অর্ডার পরিবেশনের জন্য তৈরি' : 'Table T-02 order is ready to serve', 
        'time': isBn ? '২ মিনিট আগে' : '2 mins ago'
      },
      {
        'title': isBn ? 'বিল অনুরোধ' : 'Bill Requested', 
        'subtitle': isBn ? 'টেবিল T-05 বিল প্রিন্টের অনুরোধ করেছে' : 'Table T-05 requested bill print', 
        'time': isBn ? '৫ মিনিট আগে' : '5 mins ago'
      },
      {
        'title': isBn ? 'নতুন ডেলিভারি অর্ডার' : 'New Delivery Order', 
        'subtitle': isBn ? 'অর্ডার #ORD-9812 ডেলিভারির মাধ্যমে' : 'Order #ORD-9812 via Delivery', 
        'time': isBn ? '১২ মিনিট আগে' : '12 mins ago'
      },
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.notifications_rounded, color: primaryOrange),
          const SizedBox(width: 12),
          Expanded(child: Text(isBn ? 'বিজ্ঞপ্তি' : 'Notifications', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: notifications.map<Widget>((n) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: primaryOrange.withOpacity(0.1),
                child: Icon(Icons.notifications_active, color: primaryOrange, size: 18),
              ),
              title: Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(n['subtitle']!, style: const TextStyle(fontSize: 11)),
              trailing: Text(n['time']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppStrings.get('close', locale))),
      ],
    );
  }
}

class BarcodeScannerDialog extends StatelessWidget {
  const BarcodeScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppProvider>().locale;
    final isBn = locale == 'bn';
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(isBn ? 'স্ক্যানার সক্রিয়' : 'Scanner Active', style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 300,
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: primaryOrange, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.qr_code_scanner, size: 80, color: primaryOrange),
            ),
            const SizedBox(height: 16),
            Text(isBn ? 'ক্যামেরাটি QR / বারকোডের দিকে ধরুন' : 'Point camera at QR / Barcode', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppStrings.get('close', locale))),
      ],
    );
  }
}

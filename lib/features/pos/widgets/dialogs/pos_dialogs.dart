import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/menu_item.dart';
import '../../../../core/providers/pos_provider.dart';

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
          const Expanded(
            child: Text(
              'Select Table',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                  _buildLegend(Colors.green.shade600, 'Available'),
                  const SizedBox(width: 16),
                  _buildLegend(Colors.orange.shade800, 'Occupied'),
                  const SizedBox(width: 16),
                  _buildLegend(primaryOrange, 'Selected'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: tables.map((t) {
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
                              tableName,
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
                                  '${t['capacity']} seats',
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
          child: const Text('Close'),
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
          const Expanded(
            child: Text(
              'Select Server / Waiter',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
          children: waiters.map((w) {
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
          child: const Text('Cancel'),
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
            child: Icon(Icons.pause_circle_outline_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Held Orders',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${provider.heldOrders.length} Held',
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
                      'No held orders found',
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
                              '\$${held.total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${held.items.length} items: ${held.items.map((i) => "${i.quantity}x ${i.menuItem.name}").join(', ')}',
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
                                label: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('Delete', style: TextStyle(fontSize: 12)),
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
                                label: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('Recall Order', style: TextStyle(fontSize: 12)),
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
          child: const Text('Close'),
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
          const Text(
            'Split Bill',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                  const Text('Total Bill:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: primaryOrange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Split Equally Among People',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
                    '$_splitCount People',
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
                      Text('Each Person Pays:', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                      Text(
                        '\$${perPerson.toStringAsFixed(2)}',
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bill split into $_splitCount receipts (\$${perPerson.toStringAsFixed(2)} each)'),
                backgroundColor: primaryOrange,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm Split'),
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
          const Text(
            'Transfer Order',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
              'Current Table: ${provider.tableNumber}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 14),
            const Text(
              'Select Destination Table:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['T-01', 'T-02', 'T-03', 'T-04', 'T-06', 'T-07', 'T-08', 'VIP-01']
                  .where((t) => t != provider.tableNumber)
                  .map((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: false,
                  onSelected: (_) {
                    provider.transferTable(t);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order transferred to $t'), backgroundColor: primaryOrange),
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
          child: const Text('Cancel'),
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
          const Text(
            'Add Custom Item',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                labelText: 'Item Name',
                hintText: 'e.g. Special Chef Salad',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price (\$)',
                hintText: 'e.g. 12.50',
                prefixText: '\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: AppData.categories
                  .where((c) => c.id != 'all' && c.id != 'popular')
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Vegetarian Item', style: TextStyle(fontWeight: FontWeight.w600)),
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
          child: const Text('Cancel'),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"$name" added to order!'), backgroundColor: primaryOrange),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Add to Cart'),
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
          const Text(
            'Apply Coupon',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                      hintText: 'Enter coupon code',
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Coupon "${_couponController.text.toUpperCase()}" applied!'), backgroundColor: primaryOrange),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid coupon code'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Coupons:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 10),
            ...POSProvider.availableCoupons.map((c) {
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Coupon ${c.code} applied!'), backgroundColor: primaryOrange),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApplied ? Colors.green : primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isApplied ? 'Applied' : 'Use'),
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
            child: const Text('Remove Coupon', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
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
          const Text(
            'Apply Custom Discount',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
              segments: const [
                ButtonSegment(value: true, label: Text('Percentage (%)')),
                ButtonSegment(value: false, label: Text('Fixed Amount (\$)')),
              ],
              selected: {_isPercentage},
              onSelectionChanged: (val) => setState(() => _isPercentage = val.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _isPercentage ? 'Discount Percentage' : 'Discount Amount',
                suffixText: _isPercentage ? '%' : '\$',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Presets:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
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
                        label: Text('\$$a'),
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
          child: const Text('Cancel'),
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
          child: const Text('Apply Discount'),
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
    final primaryOrange = const Color(0xFFFF6D00);

    final promos = [
      {'title': 'Happy Hour 15% OFF', 'desc': 'Valid 2:00 PM - 5:00 PM', 'action': () => provider.applyDiscount(percent: 15)},
      {'title': 'Chef Special Deal', 'desc': '\$5 Off on orders \$30+', 'action': () => provider.applyDiscount(amount: 5)},
      {'title': 'Weekend Combo 10%', 'desc': 'Applicable on main course', 'action': () => provider.applyDiscount(percent: 10)},
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
          const Text('Promotions & Deals', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: promos.map((p) {
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
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
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
    final primaryOrange = const Color(0xFFFF6D00);
    final title = widget.isKitchenNote ? 'Kitchen Note' : 'Order Note';

    final presetChips = widget.isKitchenNote
        ? ['Less Spicy', 'Extra Hot', 'No Onion', 'Allergy Alert', 'Separate Packing']
        : ['Server Table Fast', 'VIP Guest', 'Split Receipt Required', 'Birthday Special'];

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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
                hintText: 'Enter instructions here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Quick Chips:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: presetChips.map((chip) {
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
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
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
          child: const Text('Save Note'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BILL PRINT DIALOG
// ─────────────────────────────────────────────────────────────────
class BillPrintDialog extends StatelessWidget {
  const BillPrintDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);
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
            child: Icon(Icons.print_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Bill / Receipt Preview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          maxWidth: 380,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('ZESTBITE RESTAURANT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const Text('123 Culinary Ave, Foodville', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const Text('Tel: (555) 123-4567', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Table: ${provider.tableNumber}', style: const TextStyle(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Flexible(child: Text('Server: ${provider.waiter}', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Type: ${provider.selectedOrderType.toUpperCase()}', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Flexible(child: Text('Guests: ${provider.guests}', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right)),
                  ],
                ),
                const Divider(height: 24),
                ...provider.cartItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.menuItem.name}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),
                _priceRow('Subtotal', '\$${provider.subtotal.toStringAsFixed(2)}'),
                if (provider.discountValue > 0)
                  _priceRow('Discount', '-\$${provider.discountValue.toStringAsFixed(2)}'),
                _priceRow('Tax (8%)', '\$${provider.tax.toStringAsFixed(2)}'),
                _priceRow('Service (4%)', '\$${provider.serviceCharge.toStringAsFixed(2)}'),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL PAYABLE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    Text('\$${provider.totalPayable.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: primaryOrange)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Thank you for dining with us!', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Sending receipt to thermal printer...'), backgroundColor: primaryOrange),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.print, size: 18),
          label: const Text('Print Now'),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
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
    final total = provider.totalPayable;
    final change = _cashTendered > total ? _cashTendered - total : 0.0;
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
            child: Icon(Icons.payments_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Checkout & Payment', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryOrange.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text('Total Amount Due:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: primaryOrange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _methodTile('Cash', Icons.money),
                  const SizedBox(width: 8),
                  _methodTile('Card', Icons.credit_card),
                  const SizedBox(width: 8),
                  _methodTile('QR Pay', Icons.qr_code),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedMethod == 'Cash') ...[
                const Text('Cash Tendered:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [20, 50, 100].map((amt) {
                    return ChoiceChip(
                      label: Text('\$$amt'),
                      selected: _cashTendered == amt.toDouble(),
                      onSelected: (_) => setState(() => _cashTendered = amt.toDouble()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Change to Return:'),
                      Text(
                        '\$${change.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: change > 0 ? Colors.green : Colors.black87),
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
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final completedOrder = provider.placeOrder(paymentMethod: _selectedMethod);
            Navigator.of(context).pop();
            _showSuccessDialog(context, completedOrder);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Complete Order', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _methodTile(String label, IconData icon) {
    final isSel = _selectedMethod == label;
    final primaryOrange = const Color(0xFFFF6D00);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSel ? primaryOrange : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSel ? Colors.white : Colors.black87),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSel ? Colors.white : Colors.black87,
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

  void _showSuccessDialog(BuildContext context, CompletedOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Order Placed Successfully!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            Text('Order ID: ${order.id}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Total Paid: \$${order.total.toStringAsFixed(2)} via ${order.paymentMethod}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start New Order'),
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
    final primaryOrange = const Color(0xFFFF6D00);
    final notifications = [
      {'title': 'Kitchen Order Ready', 'subtitle': 'Table T-02 order is ready to serve', 'time': '2 mins ago'},
      {'title': 'Bill Requested', 'subtitle': 'Table T-05 requested bill print', 'time': '5 mins ago'},
      {'title': 'New Delivery Order', 'subtitle': 'Order #ORD-9812 via Delivery', 'time': '12 mins ago'},
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.notifications_rounded, color: primaryOrange),
          const SizedBox(width: 12),
          const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: notifications.map((n) {
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
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

class BarcodeScannerDialog extends StatelessWidget {
  const BarcodeScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Scanner Active', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text('Point camera at QR / Barcode', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/pos_provider.dart';
import '../../../core/models/menu_item.dart';

class OrderSummaryPanel extends StatelessWidget {
  final bool isBottomSheet;
  const OrderSummaryPanel({super.key, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = isBottomSheet ? double.infinity : 320.0;
    
    return Container(
      width: isBottomSheet ? double.infinity : (screenWidth >= 1024 ? 360.0 : panelWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isBottomSheet ? const BorderRadius.vertical(top: Radius.circular(20)) : null,
        boxShadow: isBottomSheet ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          )
        ],
      ),
      child: Column(
        children: [
          // Header
          _OrderSummaryHeader(),

          // Divider
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

          // Item List
          Expanded(
            child: _OrderItemsList(),
          ),

          // Note field
          _OrderNoteField(),

          // Price Breakdown
          _PriceBreakdown(),

          // Place Order Button
          _PlaceOrderButton(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────
class _OrderSummaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              // Items Count Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${provider.cartItems.length} Items',
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              // Clear All
              GestureDetector(
                onTap: provider.clearCart,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: Colors.red.shade500),
                    const SizedBox(width: 4),
                    Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
// ITEMS LIST
// ─────────────────────────────────────────────────────────────────
class _OrderItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        if (provider.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Cart is empty',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.cartItems.length,
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.grey.shade100, height: 24, thickness: 1),
          ),
          itemBuilder: (context, index) {
            return _OrderItemRow(
              item: provider.cartItems[index],
              index: index + 1,
            );
          },
        );
      },
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final CartItem item;
  final int index;

  const _OrderItemRow({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Index Badge
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: primaryOrange.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Item Name & Modifiers
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuItem.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        if (item.modifiers.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          ...item.modifiers.map(
                            (mod) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.only(right: 6, top: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      mod,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Price
                  const SizedBox(width: 8),
                  Text(
                    '\$${item.menuItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Trash Icon
                  GestureDetector(
                    onTap: () => provider.removeFromCart(item.menuItem.id),
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red.shade500,
                    ),
                  ),
                ],
              ),

              // Quantity Controls
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 36), // Align with text
                  _QuantityControl(
                    quantity: item.quantity,
                    onDecrement: () => provider.decrementQuantity(item.menuItem.id),
                    onIncrement: () => provider.incrementQuantity(item.menuItem.id),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final darkBrown = const Color(0xFF5D4037);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Icon(Icons.remove, size: 14, color: darkBrown),
            ),
          ),
          Container(
            width: 24,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Icon(Icons.add, size: 14, color: darkBrown),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// ORDER NOTE
// ─────────────────────────────────────────────────────────────────
class _OrderNoteField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFF6D00).withOpacity(0.15), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Add Order Note...',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.edit_note, size: 20, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PRICE BREAKDOWN
// ─────────────────────────────────────────────────────────────────
class _PriceBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _PriceRow(
                label: 'Subtotal',
                value: '\$${provider.subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              _PriceRow(
                label: 'Tax (8%)',
                value: '\$${provider.tax.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              _PriceRow(
                label: 'Service Charge (4%)',
                value: '\$${provider.serviceCharge.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payable',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: primaryOrange,
                    ),
                  ),
                  Text(
                    '\$${provider.totalPayable.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: primaryOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87, // Solid black like image
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PLACE ORDER BUTTON
// ─────────────────────────────────────────────────────────────────
class _PlaceOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);
    final darkOrange = const Color(0xFFE65100);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
          child: GestureDetector(
            onTap: provider.cartItems.isEmpty ? null : () {},
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: provider.cartItems.isEmpty ? Colors.grey.shade300 : primaryOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Left side (Text + Arrow)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Place an Order',
                              style: TextStyle(
                                color: provider.cartItems.isEmpty ? Colors.grey.shade500 : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: provider.cartItems.isEmpty ? Colors.grey.shade500 : Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side (Darker Price Box)
                  if (provider.cartItems.isNotEmpty)
                    Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: darkOrange,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          '\$${provider.totalPayable.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

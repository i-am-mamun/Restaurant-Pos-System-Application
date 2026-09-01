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
    final panelWidth = isBottomSheet ? double.infinity : 280.0;
    if (screenWidth >= 1024) {
      return _buildPanel(context, 300.0);
    }
    return _buildPanel(context, panelWidth);
  }

  Widget _buildPanel(BuildContext context, double width) {
    return Container(
      width: isBottomSheet ? double.infinity : width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isBottomSheet
            ? null
            : const Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          // Header
          _OrderSummaryHeader(),

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

class _OrderSummaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: Row(
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${provider.cartItems.length} Items',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: provider.clearCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline, size: 14, color: AppColors.danger),
                      SizedBox(width: 2),
                      Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        if (provider.cartItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.textLight),
                SizedBox(height: 8),
                Text(
                  'Cart is empty',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: provider.cartItems.length,
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
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Index
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Item Name & Modifiers
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuItem.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (item.modifiers.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          ...item.modifiers.map(
                            (mod) => Padding(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: Text(
                                '• $mod',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Price
                  Text(
                    '\$${item.menuItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete
                  GestureDetector(
                    onTap: () => provider.removeFromCart(item.menuItem.id),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),

              // Quantity Controls
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 28),
                  _QuantityControl(
                    quantity: item.quantity,
                    onDecrement: () => provider.decrementQuantity(item.menuItem.id),
                    onIncrement: () => provider.incrementQuantity(item.menuItem.id),
                  ),
                  const Spacer(),
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
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.remove, size: 12, color: AppColors.textPrimary),
          ),
        ),
        Container(
          width: 28,
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.add, size: 12, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _OrderNoteField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Add Order Note...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ),
          Icon(Icons.edit_note, size: 18, color: AppColors.textLight),
        ],
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          child: Column(
            children: [
              _PriceRow(
                label: 'Subtotal',
                value: '\$${provider.subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 6),
              _PriceRow(
                label: 'Tax (8%)',
                value: '\$${provider.tax.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 6),
              _PriceRow(
                label: 'Service Charge (4%)',
                value: '\$${provider.serviceCharge.toStringAsFixed(2)}',
              ),
              const Divider(height: 16, color: AppColors.borderLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Payable',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '\$${provider.totalPayable.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: provider.cartItems.isEmpty ? null : () => _showPaymentDialog(context, provider),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              decoration: BoxDecoration(
                gradient: provider.cartItems.isEmpty
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFE64A19)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: provider.cartItems.isEmpty ? AppColors.borderLight : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: provider.cartItems.isEmpty
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Place an Order',
                    style: TextStyle(
                      color: provider.cartItems.isEmpty
                          ? AppColors.textSecondary
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: provider.cartItems.isEmpty
                        ? AppColors.textSecondary
                        : Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  if (provider.cartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$${provider.totalPayable.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
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

  void _showPaymentDialog(BuildContext context, POSProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.payment, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Payment',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${provider.totalPayable.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _PaymentMethodBtn(icon: Icons.money, label: 'Cash'),
            const SizedBox(height: 8),
            _PaymentMethodBtn(icon: Icons.credit_card, label: 'Card'),
            const SizedBox(height: 8),
            _PaymentMethodBtn(icon: Icons.phone_android, label: 'Mobile Banking'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PaymentMethodBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: () {
            provider.clearCart();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order placed via $label!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}

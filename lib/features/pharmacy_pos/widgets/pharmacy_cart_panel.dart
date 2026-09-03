import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_extensions.dart';
import '../providers/pharmacy_provider.dart';

class PharmacyCartPanel extends StatelessWidget {
  const PharmacyCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? context.cardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!context.isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          _buildCustomerHeader(context),
          const Divider(height: 1),
          _buildCartTableHeader(context),
          Expanded(child: _buildCartItemList(context)),
          _buildCartFooterActions(context),
          const Divider(height: 1),
          _buildSummaryAndInputs(context),
          const Divider(height: 1),
          _buildPaymentMethods(context),
          _buildCheckoutButtons(context),
        ],
      ),
    );
  }

  Widget _buildCustomerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF009688), // Teal
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Walk-in Customer',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: context.textSecondary, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Loyalty
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: context.isDark ? Colors.purple.withOpacity(0.1) : Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.badge_rounded, color: Colors.purple.shade400, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loyalty', style: TextStyle(fontSize: 8, color: Colors.purple.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('120 Pts', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Balance
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: context.isDark ? Colors.green.withOpacity(0.1) : Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_rounded, color: Colors.green.shade600, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Balance', style: TextStyle(fontSize: 8, color: Colors.green.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('৳ 320.00', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('ITEM', style: _headerStyle(context))),
          Expanded(flex: 2, child: Text('QTY', style: _headerStyle(context), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('PRICE', style: _headerStyle(context), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('DISC.', style: _headerStyle(context), textAlign: TextAlign.right)), // Shortened from DISCOUNT to fit
          Expanded(flex: 2, child: Text('TOTAL', style: _headerStyle(context), textAlign: TextAlign.right)),
          const SizedBox(width: 24), // space for delete icon
        ],
      ),
    );
  }

  TextStyle _headerStyle(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: context.textSecondary,
      letterSpacing: 0.5,
    );
  }

  Widget _buildCartItemList(BuildContext context) {
    return Consumer<PharmacyProvider>(
      builder: (context, provider, _) {
        if (provider.cart.isEmpty) {
          return Center(
            child: Text(
              'Cart is empty',
              style: TextStyle(color: context.textSecondary),
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.cart.length,
          itemBuilder: (context, index) {
            final item = provider.cart[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Item Details
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Image.asset(
                            item.medicine.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.medication, color: Colors.blue.shade400, size: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.medicine.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: context.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.medicine.genericName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Qty
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _qtyBtn(context, Icons.remove, () => provider.updateQuantity(item.medicine.id, -1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        _qtyBtn(context, Icons.add, () => provider.updateQuantity(item.medicine.id, 1)),
                      ],
                    ),
                  ),
                  // Price
                  Expanded(
                    flex: 2,
                    child: Text(
                      '৳ ${item.medicine.price.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                    ),
                  ),
                  // Discount (Mock logic for Esomeprazole to match UI)
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.medicine.name == 'Esomeprazole' ? '5%' : '0%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        color: item.medicine.name == 'Esomeprazole' ? Colors.green : context.textPrimary,
                        fontWeight: item.medicine.name == 'Esomeprazole' ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  // Total
                  Expanded(
                    flex: 2,
                    child: Text(
                      '৳ ${item.total.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary),
                    ),
                  ),
                  // Remove
                  SizedBox(
                    width: 32,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded, size: 16, color: context.textSecondary),
                      onPressed: () => provider.removeItem(item.medicine.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _qtyBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.isDark ? context.scaffoldBg : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: context.textSecondary),
      ),
    );
  }

  Widget _buildCartFooterActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16, color: Color(0xFF009688)),
            label: const Text('Add Item (F2)', style: TextStyle(color: Color(0xFF009688))),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Consumer<PharmacyProvider>(
            builder: (context, provider, _) {
              return Row(
                children: [
                  Text('Items: ${provider.totalItemCount}', style: TextStyle(color: context.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => provider.clearCart(),
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                    label: const Text('Clear Cart', style: TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryAndInputs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inputs Section
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompactInput(context, label: 'Apply Discount', hint: '0%', suffixAction: 'Apply'),
                    const SizedBox(height: 12),
                    _buildCompactInput(context, label: 'Apply Coupon', hint: 'Code', suffixAction: 'Apply'),
                    const SizedBox(height: 12),
                    Text('Sales Note', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: context.textSecondary)),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.isDark ? context.scaffoldBg : Colors.grey.shade50,
                        border: Border.all(color: context.isDark ? context.dividerColor : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        style: const TextStyle(fontSize: 11),
                        decoration: InputDecoration(
                          hintText: 'Add note...',
                          hintStyle: TextStyle(color: context.textHint, fontSize: 11),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Summary Section
              Expanded(
                flex: 1,
                child: Consumer<PharmacyProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      children: [
                        _summaryRow('Sub Total', '৳ ${provider.subTotal.toStringAsFixed(2)}', context),
                        const SizedBox(height: 8),
                        _summaryRow('Discount', '- ৳ ${provider.totalDiscount.toStringAsFixed(2)}', context, isNegative: true),
                        const SizedBox(height: 8),
                        _summaryRow('VAT (5%)', '৳ ${provider.vat.toStringAsFixed(2)}', context),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
                            Flexible(
                              child: Text(
                                '৳ ${provider.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF009688)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (provider.totalDiscount > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'You Save ৳ ${provider.totalDiscount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInput(BuildContext context, {required String label, required String hint, required String suffixAction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: context.textSecondary)),
        const SizedBox(height: 4),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: context.isDark ? context.scaffoldBg : Colors.white,
            border: Border.all(color: context.isDark ? context.dividerColor : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 11),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: context.textHint, fontSize: 11),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    isDense: true,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF009688).withOpacity(0.1),
                    border: Border(left: BorderSide(color: context.isDark ? context.dividerColor : Colors.grey.shade200)),
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
                  ),
                  child: Text(suffixAction, style: const TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.w700, fontSize: 10)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, BuildContext context, {bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: context.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: isNegative ? Colors.green : context.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    final methods = [
      {'name': 'Cash', 'icon': Icons.money, 'color': Colors.green},
      {'name': 'Card', 'icon': Icons.credit_card, 'color': Colors.blue},
      {'name': 'Mobile Pay', 'icon': Icons.phone_android, 'color': Colors.purple},
      {'name': 'Bank Transfer', 'icon': Icons.account_balance, 'color': Colors.orange},
      {'name': 'Credit', 'icon': Icons.credit_score, 'color': Colors.blue},
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: methods.map((m) {
          final isCash = m['name'] == 'Cash';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isCash ? Colors.green.withOpacity(0.1) : (context.isDark ? context.scaffoldBg : Colors.grey.withOpacity(0.05)),
              border: Border.all(color: isCash ? Colors.green.withOpacity(0.3) : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(m['icon'] as IconData, size: 14, color: m['color'] as Color),
                const SizedBox(width: 4),
                Text(
                  m['name'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCash ? FontWeight.w700 : FontWeight.w500,
                    color: isCash ? Colors.green.shade700 : context.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCheckoutButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: context.isDark ? context.scaffoldBg : Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pause, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text('Hold Bill', style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('(F6)', style: TextStyle(color: context.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Consumer<PharmacyProvider>(
              builder: (context, provider, _) {
                return InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF009688),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pay ৳ ${provider.total.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text('(F1)', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
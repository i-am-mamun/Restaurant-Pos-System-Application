import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class POSProvider extends ChangeNotifier {
  String _selectedCategory = 'all';
  String _selectedOrderType = 'dine_in';
  String _viewMode = 'grid'; // grid or list
  String _searchQuery = '';
  
  String _tableNumber = 'T-05';
  int _guests = 4;
  String _waiter = 'John Doe';
  
  List<CartItem> _cartItems = [];
  bool _isOrderSummaryVisible = true;

  // Notes & Discounts
  String _orderNote = '';
  String _kitchenNote = '';
  double _discountPercent = 0.0;
  double _discountAmount = 0.0;
  String? _appliedCoupon;

  // Held & Completed Orders
  final List<HeldOrder> _heldOrders = [];
  final List<CompletedOrder> _completedOrders = [];

  // Available coupons
  static final List<CouponModel> availableCoupons = [
    const CouponModel(
      code: 'SAVE10',
      description: 'Get 10% OFF on all menu items',
      discountPercentage: 10.0,
    ),
    const CouponModel(
      code: 'FEAST20',
      description: 'Get 20% OFF on orders over \$25',
      discountPercentage: 20.0,
    ),
    const CouponModel(
      code: 'WELCOME5',
      description: '\$5.00 Flat Discount',
      fixedDiscountAmount: 5.0,
    ),
  ];

  // Initial cart items matching demo design
  POSProvider() {
    _cartItems = [
      CartItem(
        menuItem: AppData.menuItems.firstWhere((m) => m.id == 1),
        quantity: 1,
        modifiers: ['Size: Regular', 'Extra Cheese', 'Extra Chicken', 'No onion, extra sauce please'],
      ),
      CartItem(
        menuItem: AppData.menuItems.firstWhere((m) => m.id == 2),
        quantity: 1,
      ),
      CartItem(
        menuItem: AppData.menuItems.firstWhere((m) => m.id == 5),
        quantity: 1,
      ),
      CartItem(
        menuItem: AppData.menuItems.firstWhere((m) => m.id == 11),
        quantity: 2,
      ),
      CartItem(
        menuItem: AppData.menuItems.firstWhere((m) => m.id == 10),
        quantity: 1,
      ),
    ];
  }

  // Getters
  String get selectedCategory => _selectedCategory;
  String get selectedOrderType => _selectedOrderType;
  String get viewMode => _viewMode;
  String get searchQuery => _searchQuery;
  
  String get tableNumber => _tableNumber;
  int get guests => _guests;
  String get waiter => _waiter;
  
  List<CartItem> get cartItems => _cartItems;
  bool get isOrderSummaryVisible => _isOrderSummaryVisible;

  String get orderNote => _orderNote;
  String get kitchenNote => _kitchenNote;
  double get discountPercent => _discountPercent;
  double get discountAmount => _discountAmount;
  String? get appliedCoupon => _appliedCoupon;

  List<HeldOrder> get heldOrders => List.unmodifiable(_heldOrders);
  List<CompletedOrder> get completedOrders => List.unmodifiable(_completedOrders);

  List<MenuItem> get filteredMenuItems {
    List<MenuItem> items = AppData.menuItems;
    if (_selectedCategory != 'all') {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return items;
  }

  // Calculations
  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountValue {
    double percentDiscount = (subtotal * _discountPercent) / 100.0;
    double totalDisc = percentDiscount + _discountAmount;
    return totalDisc > subtotal ? subtotal : totalDisc;
  }

  double get subtotalAfterDiscount => subtotal - discountValue;

  double get tax => subtotalAfterDiscount * 0.08;
  double get serviceCharge => subtotalAfterDiscount * 0.04;
  double get totalPayable => subtotalAfterDiscount + tax + serviceCharge;
  int get totalItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Setters & Actions
  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void selectOrderType(String orderType) {
    _selectedOrderType = orderType;
    notifyListeners();
  }

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectTable(String table) {
    _tableNumber = table;
    notifyListeners();
  }

  void selectWaiter(String waiterName) {
    _waiter = waiterName;
    notifyListeners();
  }

  void setGuests(int count) {
    if (count >= 1) {
      _guests = count;
      notifyListeners();
    }
  }

  void incrementGuests() {
    _guests++;
    notifyListeners();
  }

  void decrementGuests() {
    if (_guests > 1) {
      _guests--;
      notifyListeners();
    }
  }

  void addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere((c) => c.menuItem.id == item.id);
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(menuItem: item));
    }
    notifyListeners();
  }

  void removeFromCart(int itemId) {
    _cartItems.removeWhere((c) => c.menuItem.id == itemId);
    notifyListeners();
  }

  void incrementQuantity(int itemId) {
    final index = _cartItems.indexWhere((c) => c.menuItem.id == itemId);
    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int itemId) {
    final index = _cartItems.indexWhere((c) => c.menuItem.id == itemId);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _discountPercent = 0.0;
    _discountAmount = 0.0;
    _appliedCoupon = null;
    _orderNote = '';
    _kitchenNote = '';
    notifyListeners();
  }

  void toggleOrderSummary() {
    _isOrderSummaryVisible = !_isOrderSummaryVisible;
    notifyListeners();
  }

  bool isInCart(int itemId) {
    return _cartItems.any((c) => c.menuItem.id == itemId);
  }

  int getQuantity(int itemId) {
    final index = _cartItems.indexWhere((c) => c.menuItem.id == itemId);
    return index != -1 ? _cartItems[index].quantity : 0;
  }

  // Notes
  void setOrderNote(String note) {
    _orderNote = note;
    notifyListeners();
  }

  void setKitchenNote(String note) {
    _kitchenNote = note;
    notifyListeners();
  }

  // Coupons & Discounts
  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    final found = availableCoupons.firstWhere(
      (c) => c.code == cleanCode,
      orElse: () => const CouponModel(code: '', description: ''),
    );

    if (found.code.isNotEmpty) {
      _appliedCoupon = found.code;
      if (found.fixedDiscountAmount != null) {
        _discountAmount = found.fixedDiscountAmount!;
        _discountPercent = 0.0;
      } else {
        _discountPercent = found.discountPercentage;
        _discountAmount = 0.0;
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discountPercent = 0.0;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void applyDiscount({double? percent, double? amount}) {
    if (percent != null) {
      _discountPercent = percent;
      _discountAmount = 0.0;
      _appliedCoupon = 'Custom ${percent.toStringAsFixed(0)}%';
    } else if (amount != null) {
      _discountAmount = amount;
      _discountPercent = 0.0;
      _appliedCoupon = 'Custom \$${amount.toStringAsFixed(2)}';
    }
    notifyListeners();
  }

  // Custom Item
  void addCustomItem(MenuItem newItem) {
    AppData.menuItems.add(newItem);
    addToCart(newItem);
  }

  // Hold & Recall
  bool holdCurrentOrder() {
    if (_cartItems.isEmpty) return false;

    final id = 'HOLD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final heldOrder = HeldOrder(
      id: id,
      tableNumber: _tableNumber,
      waiter: _waiter,
      guests: _guests,
      orderType: _selectedOrderType,
      items: List.from(_cartItems),
      note: _orderNote,
      timestamp: DateTime.now(),
    );

    _heldOrders.insert(0, heldOrder);
    _cartItems.clear();
    _orderNote = '';
    _kitchenNote = '';
    _discountPercent = 0.0;
    _discountAmount = 0.0;
    _appliedCoupon = null;
    notifyListeners();
    return true;
  }

  void recallOrder(HeldOrder order) {
    _cartItems = List.from(order.items);
    _tableNumber = order.tableNumber;
    _waiter = order.waiter;
    _guests = order.guests;
    _selectedOrderType = order.orderType;
    _orderNote = order.note;
    _heldOrders.removeWhere((h) => h.id == order.id);
    notifyListeners();
  }

  void deleteHeldOrder(String id) {
    _heldOrders.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void transferTable(String newTable) {
    _tableNumber = newTable;
    notifyListeners();
  }

  // Complete / Place Order
  CompletedOrder placeOrder({required String paymentMethod}) {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    final completed = CompletedOrder(
      id: orderId,
      orderType: _selectedOrderType,
      tableNumber: _tableNumber,
      waiter: _waiter,
      items: List.from(_cartItems),
      subtotal: subtotal,
      discount: discountValue,
      tax: tax,
      serviceCharge: serviceCharge,
      total: totalPayable,
      paymentMethod: paymentMethod,
      timestamp: DateTime.now(),
    );

    _completedOrders.insert(0, completed);
    clearCart();
    return completed;
  }
}

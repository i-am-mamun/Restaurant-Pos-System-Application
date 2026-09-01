import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class POSProvider extends ChangeNotifier {
  String _selectedCategory = 'all';
  String _selectedOrderType = 'dine_in';
  String _viewMode = 'grid'; // grid or list
  String _searchQuery = '';
  int _tableNumber = 5;
  int _guests = 4;
  String _waiter = 'John Doe';
  List<CartItem> _cartItems = [];
  bool _isOrderSummaryVisible = true;

  // Initial cart items matching image
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

  String get selectedCategory => _selectedCategory;
  String get selectedOrderType => _selectedOrderType;
  String get viewMode => _viewMode;
  String get searchQuery => _searchQuery;
  int get tableNumber => _tableNumber;
  int get guests => _guests;
  String get waiter => _waiter;
  List<CartItem> get cartItems => _cartItems;
  bool get isOrderSummaryVisible => _isOrderSummaryVisible;

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

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.08;
  double get serviceCharge => subtotal * 0.04;
  double get totalPayable => subtotal + tax + serviceCharge;
  int get totalItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

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
    notifyListeners();
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

  void toggleOrderSummary() {
    _isOrderSummaryVisible = !_isOrderSummaryVisible;
    notifyListeners();
  }

  bool isInCart(int itemId) {
    return _cartItems.any((c) => c.menuItem.id == itemId);
  }
}

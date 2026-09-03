import 'package:flutter/foundation.dart';
import '../models/medicine_model.dart';
import '../models/pharmacy_cart_item.dart';

class PharmacyProvider extends ChangeNotifier {
  final List<MedicineModel> _allMedicines = [
    MedicineModel(id: '1', name: 'Paracetamol', genericName: 'Tablet • 500mg', price: 1.20, category: 'OTC', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '2', name: 'Napa Extra', genericName: 'Tablet • 100mg', price: 12.00, category: 'All', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '3', name: 'Esomeprazole', genericName: 'Capsule • 20mg', price: 8.50, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '4', name: 'Azithromycin', genericName: 'Tablet • 500mg', price: 18.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '5', name: 'Vitamin D3', genericName: 'Capsule • 1000 IU', price: 10.00, category: 'Supplements', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '6', name: 'ORS', genericName: 'Powder • 21.8gm', price: 5.00, category: 'OTC', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '7', name: 'Augmentin', genericName: 'Tablet • 625mg', price: 22.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '8', name: 'Salbutamol', genericName: 'Inhaler • 100mcg', price: 15.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '9', name: 'Amoxicillin', genericName: 'Capsule • 500mg', price: 6.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '10', name: 'Ibuprofen', genericName: 'Tablet • 400mg', price: 7.00, category: 'OTC', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '11', name: 'Vitamin C', genericName: 'Tablet • 500mg', price: 3.00, category: 'Supplements', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '12', name: 'Cetirizine', genericName: 'Tablet • 10mg', price: 6.00, category: 'OTC', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '13', name: 'Domstal', genericName: 'Tablet • 10mg', price: 7.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '14', name: 'Zincovit', genericName: 'Tablet • 20mg', price: 2.50, category: 'Supplements', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '15', name: 'Metformin', genericName: 'Tablet • 500mg', price: 4.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '16', name: 'Omeprazole', genericName: 'Capsule • 20mg', price: 8.00, category: 'Prescription', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
    MedicineModel(id: '17', name: 'Becom-Z', genericName: 'Capsule', price: 6.50, category: 'Supplements', imagePath: 'assets/images/medicine/placeholder.png', discountPercentage: null),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedFilter = 'A-Z'; // 'A-Z', 'Popular', 'Low Stock', 'Expiring Soon'
  
  final List<PharmacyCartItem> _cart = [];
  double _globalDiscount = 0.0;
  
  // Getters
  List<MedicineModel> get frequentlySold {
    final list = _allMedicines.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list.take(12).toList(); // Increased from 6 to 12 to fill empty space
  }
  
  List<MedicineModel> get filteredMedicines {
    List<MedicineModel> temp = _allMedicines;
    
    if (_selectedCategory != 'All') {
      temp = temp.where((m) => m.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      temp = temp.where((m) => m.name.toLowerCase().contains(q) || m.genericName.toLowerCase().contains(q)).toList();
    }

    if (_selectedFilter == 'A-Z') {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }
    
    return temp;
  }

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedFilter => _selectedFilter;
  List<PharmacyCartItem> get cart => _cart;
  double get globalDiscount => _globalDiscount;

  // Actions
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void addToCart(MedicineModel medicine) {
    final existingIndex = _cart.indexWhere((item) => item.medicine.id == medicine.id);
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(PharmacyCartItem(medicine: medicine));
    }
    notifyListeners();
  }

  void updateQuantity(String id, int change) {
    final index = _cart.indexWhere((item) => item.medicine.id == id);
    if (index >= 0) {
      _cart[index].quantity += change;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _cart.removeWhere((item) => item.medicine.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _globalDiscount = 0.0;
    notifyListeners();
  }

  // Totals calculations
  double get subTotal => _cart.fold(0, (sum, item) => sum + (item.medicine.price * item.quantity));
  
  // Image shows 5% discount on Esomeprazole in cart
  double get totalDiscount {
    double itemDiscounts = _cart.fold(0, (sum, item) {
       // Mock logic: Esomeprazole gets 5% discount
       if (item.medicine.name == 'Esomeprazole') {
           return sum + (item.medicine.price * item.quantity * 0.05);
       }
       return sum;
    });
    // Add 10% global discount if apply discount used (mock)
    double global = (subTotal - itemDiscounts) * (_globalDiscount / 100);
    return itemDiscounts + global;
  }

  double get vat => (subTotal - totalDiscount) * 0.05; // 5% VAT in image
  double get total => subTotal - totalDiscount + vat;
  int get totalItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
}

class MenuItem {
  final int id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final bool isPopular;
  final bool isVeg;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isPopular = false,
    this.isVeg = false,
  });
}

class CartItem {
  final MenuItem menuItem;
  int quantity;
  List<String> modifiers;
  String note;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.modifiers = const [],
    this.note = '',
  });

  double get totalPrice => menuItem.price * quantity;
}

class OrderType {
  final String id;
  final String name;
  final String icon;

  const OrderType({required this.id, required this.name, required this.icon});
}

class MenuCategory {
  final String id;
  final String name;
  final String icon;

  const MenuCategory({required this.id, required this.name, required this.icon});
}

class HeldOrder {
  final String id;
  final String tableNumber;
  final String waiter;
  final int guests;
  final String orderType;
  final List<CartItem> items;
  final String note;
  final DateTime timestamp;

  HeldOrder({
    required this.id,
    required this.tableNumber,
    required this.waiter,
    required this.guests,
    required this.orderType,
    required this.items,
    this.note = '',
    required this.timestamp,
  });

  double get total => items.fold(0, (sum, i) => sum + i.totalPrice);
}

class CompletedOrder {
  final String id;
  final String orderType;
  final String tableNumber;
  final String waiter;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double serviceCharge;
  final double total;
  final String paymentMethod;
  final DateTime timestamp;

  CompletedOrder({
    required this.id,
    required this.orderType,
    required this.tableNumber,
    required this.waiter,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceCharge,
    required this.total,
    required this.paymentMethod,
    required this.timestamp,
  });
}

class CouponModel {
  final String code;
  final String description;
  final double discountPercentage;
  final double? fixedDiscountAmount;

  const CouponModel({
    required this.code,
    required this.description,
    this.discountPercentage = 0.0,
    this.fixedDiscountAmount,
  });
}


// Sample Data
class AppData {
  static const List<MenuCategory> categories = [
    MenuCategory(id: 'all', name: 'All Items', icon: '🍽️'),
    MenuCategory(id: 'popular', name: 'Popular', icon: '⭐'),
    MenuCategory(id: 'starters', name: 'Starters', icon: '🥗'),
    MenuCategory(id: 'main_course', name: 'Main Course', icon: '🍖'),
    MenuCategory(id: 'pizza', name: 'Pizza', icon: '🍕'),
    MenuCategory(id: 'burgers', name: 'Burgers', icon: '🍔'),
    MenuCategory(id: 'pasta', name: 'Pasta', icon: '🍝'),
    MenuCategory(id: 'rice_noodles', name: 'Rice & Noodles', icon: '🍜'),
    MenuCategory(id: 'drinks', name: 'Drinks', icon: '🥤'),
    MenuCategory(id: 'desserts', name: 'Desserts', icon: '🍰'),
    MenuCategory(id: 'sides', name: 'Sides', icon: '🍟'),
    MenuCategory(id: 'addons', name: 'Add-ons', icon: '➕'),
  ];

  static const List<OrderType> orderTypes = [
    OrderType(id: 'dine_in', name: 'Dine In', icon: '🍽️'),
    OrderType(id: 'take_away', name: 'Take Away', icon: '🛍️'),
    OrderType(id: 'delivery', name: 'Delivery', icon: '🛵'),
  ];

  static final List<MenuItem> menuItems = [
    MenuItem(
      id: 1,
      name: 'Chicken Burger',
      price: 6.49,
      category: 'burgers',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
      isPopular: true,
    ),
    MenuItem(
      id: 2,
      name: 'Margherita Pizza',
      price: 9.99,
      category: 'pizza',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=300&fit=crop',
      isPopular: true,
    ),
    MenuItem(
      id: 3,
      name: 'Grilled Chicken',
      price: 8.99,
      category: 'main_course',
      imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400&h=300&fit=crop',
      isPopular: true,
    ),
    MenuItem(
      id: 4,
      name: 'Beef Steak',
      price: 16.99,
      category: 'main_course',
      imageUrl: 'https://images.unsplash.com/photo-1546964124-0cce460f38ef?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 5,
      name: 'Chicken Alfredo Pasta',
      price: 10.99,
      category: 'pasta',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
      isVeg: false,
    ),
    MenuItem(
      id: 6,
      name: 'Caesar Salad',
      price: 5.99,
      category: 'starters',
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop',
      isVeg: true,
    ),
    MenuItem(
      id: 7,
      name: 'BBQ Wings',
      price: 7.49,
      category: 'starters',
      imageUrl: 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=400&h=300&fit=crop',
      isPopular: true,
    ),
    MenuItem(
      id: 8,
      name: 'French Fries',
      price: 3.49,
      category: 'sides',
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 9,
      name: 'Veg Fried Rice',
      price: 7.99,
      category: 'rice_noodles',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=300&fit=crop',
      isVeg: true,
    ),
    MenuItem(
      id: 10,
      name: 'Chocolate Lava Cake',
      price: 4.99,
      category: 'desserts',
      imageUrl: 'https://images.unsplash.com/photo-1617305855058-336d24456869?w=400&h=300&fit=crop',
      isPopular: true,
    ),
    MenuItem(
      id: 11,
      name: 'Mojito',
      price: 2.99,
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=300&fit=crop',
      isVeg: true,
    ),
    MenuItem(
      id: 12,
      name: 'Coca Cola (Can)',
      price: 1.99,
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 13,
      name: 'Paneer Tikka',
      price: 8.49,
      category: 'starters',
      imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=400&h=300&fit=crop',
      isVeg: true,
      isPopular: true,
    ),
    MenuItem(
      id: 14,
      name: 'Mushroom Soup',
      price: 4.49,
      category: 'starters',
      imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=300&fit=crop',
      isVeg: true,
    ),
    MenuItem(
      id: 15,
      name: 'Pepperoni Pizza',
      price: 11.99,
      category: 'pizza',
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 16,
      name: 'Fish & Chips',
      price: 12.99,
      category: 'main_course',
      imageUrl: 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 17,
      name: 'Spaghetti Bolognese',
      price: 9.49,
      category: 'pasta',
      imageUrl: 'https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 18,
      name: 'Tiramisu',
      price: 5.49,
      category: 'desserts',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=300&fit=crop',
    ),
    MenuItem(
      id: 19,
      name: 'Garlic Bread',
      price: 2.99,
      category: 'sides',
      imageUrl: 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=400&h=300&fit=crop',
      isVeg: true,
    ),
    MenuItem(
      id: 20,
      name: 'Mango Lassi',
      price: 3.49,
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=400&h=300&fit=crop',
      isVeg: true,
    ),
  ];
}

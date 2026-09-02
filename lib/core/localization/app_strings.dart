/// Central place for all UI strings in English (en) and Bengali (bn).
/// Usage: AppStrings.get('table', locale)
class AppStrings {
  AppStrings._();

  /// BDT currency symbol used throughout the app.
  static const String currency = '৳';

  static String get(String key, String locale) {
    return _strings[key]?[locale] ?? _strings[key]?['en'] ?? key;
  }

  static const Map<String, Map<String, String>> _strings = {
    // ── App ──────────────────────────────────────────────
    'app_name': {
      'en': 'ZestBite Enterprise',
      'bn': 'জেস্টবাইট এন্টারপ্রাইজ',
    },
    'app_subtitle': {
      'en': 'Select a point of sale system',
      'bn': 'পয়েন্ট অব সেল সিস্টেম বেছে নিন',
    },

    // ── Home Screen – Module Names ────────────────────────
    'restaurant_pos': {'en': 'Restaurant POS', 'bn': 'রেস্তোরাঁ POS'},
    'restaurant_pos_desc': {
      'en': 'Dine-in, Takeaway, Tables, Kitchen',
      'bn': 'ডাইন-ইন, টেকঅ্যাওয়ে, টেবিল, রান্নাঘর',
    },
    'grocery_pos': {'en': 'Grocery POS', 'bn': 'মুদিখানা POS'},
    'grocery_pos_desc': {
      'en': 'Barcode scanning, Weight scaling, Inventory',
      'bn': 'বারকোড স্ক্যান, ওজন মাপা, ইনভেন্টরি',
    },
    'pharmacy_pos': {'en': 'Pharmacy POS', 'bn': 'ফার্মেসি POS'},
    'pharmacy_pos_desc': {
      'en': 'Prescriptions, Expiry tracking, Batch mgmt',
      'bn': 'প্রেসক্রিপশন, মেয়াদ ট্র্যাকিং, ব্যাচ',
    },
    'wholesaler_pos': {'en': 'Wholesaler POS', 'bn': 'পাইকারি POS'},
    'wholesaler_pos_desc': {
      'en': 'Bulk orders, Customer credit, B2B pricing',
      'bn': 'বাল্ক অর্ডার, ক্রেডিট, B2B মূল্য',
    },
    'fashion_retail': {'en': 'Fashion & Retail', 'bn': 'ফ্যাশন ও খুচরা'},
    'fashion_retail_desc': {
      'en': 'Variants, Sizes, Colors, Returns',
      'bn': 'ভ্যারিয়েন্ট, সাইজ, রঙ, রিটার্ন',
    },
    'dashboard': {'en': 'Dashboard & Reports', 'bn': 'ড্যাশবোর্ড ও রিপোর্ট'},
    'dashboard_desc': {
      'en': 'Analytics, Multi-store management',
      'bn': 'বিশ্লেষণ, মাল্টি-স্টোর ব্যবস্থাপনা',
    },
    'coming_soon': {'en': 'SOON', 'bn': 'শীঘ্রই'},
    'coming_soon_msg': {
      'en': 'is coming soon!',
      'bn': 'শীঘ্রই আসছে!',
    },

    // ── Settings ──────────────────────────────────────────
    'settings': {'en': 'Settings', 'bn': 'সেটিংস'},
    'appearance': {'en': 'Appearance', 'bn': 'চেহারা'},
    'dark_mode': {'en': 'Dark Mode', 'bn': 'ডার্ক মোড'},
    'language': {'en': 'Language', 'bn': 'ভাষা'},
    'currency': {'en': 'Currency', 'bn': 'মুদ্রা'},
    'currency_desc': {
      'en': 'Bangladeshi Taka (৳)',
      'bn': 'বাংলাদেশি টাকা (৳)',
    },
    'close': {'en': 'Close', 'bn': 'বন্ধ করুন'},
    'done': {'en': 'Done', 'bn': 'সম্পন্ন'},

    // ── POS Info Bar ─────────────────────────────────────
    'table': {'en': 'Table', 'bn': 'টেবিল'},
    'guests': {'en': 'Guests', 'bn': 'অতিথি'},
    'waiter': {'en': 'Waiter', 'bn': 'ওয়েটার'},

    // ── Action Buttons ────────────────────────────────────
    'hold': {'en': 'Hold', 'bn': 'হোল্ড'},
    'recall': {'en': 'Recall', 'bn': 'রিকল'},
    'split': {'en': 'Split', 'bn': 'বিভক্ত'},
    'transfer': {'en': 'Transfer', 'bn': 'স্থানান্তর'},
    'clear_order': {'en': 'Clear Order', 'bn': 'মুছুন'},

    // ── Order Summary ─────────────────────────────────────
    'total': {'en': 'Total', 'bn': 'মোট'},
    'pay_now': {'en': 'PAY NOW', 'bn': 'পেমেন্ট করুন'},

    // ── General ───────────────────────────────────────────
    'cancel': {'en': 'Cancel', 'bn': 'বাতিল'},
    'save': {'en': 'Save', 'bn': 'সংরক্ষণ'},
    // ── Order Summary / Payment ───────────────────────────────────
    'order_summary': {'en': 'Order Summary', 'bn': 'অর্ডার সারাংশ'},
    'items': {'en': 'Items', 'bn': 'আইটেম'},
    'clear_all': {'en': 'Clear All', 'bn': 'সব মুছুন'},
    'clear_cart': {'en': 'Clear Cart?', 'bn': 'কার্ট মুছবেন?'},
    'clear_cart_msg': {'en': 'Are you sure you want to clear all items in the cart?', 'bn': 'আপনি কি কার্টের সব আইটেম মুছতে চান?'},
    'subtotal': {'en': 'Subtotal', 'bn': 'সাবটোটাল'},
    'tax': {'en': 'Tax (8%)', 'bn': 'ট্যাক্স (৮%)'},
    'service_charge': {'en': 'Service Charge (4%)', 'bn': 'সার্ভিস চার্জ (৪%)'},
    'total_payable': {'en': 'Total Payable', 'bn': 'মোট পরিশোধযোগ্য'},
    'place_order': {'en': 'Place an Order', 'bn': 'অর্ডার দিন'},
    'cart_empty': {'en': 'Cart is empty', 'bn': 'কার্ট খালি'},
    'add_order_note': {'en': 'Add Order Note...', 'bn': 'অর্ডার নোট যোগ করুন...'},
    'discount_label': {'en': 'Discount', 'bn': 'ছাড়'},

    // ── Bottom Action Bar ────────────────────────────────────────
    'coupon': {'en': 'Coupon', 'bn': 'কুপন'},
    'discount': {'en': 'Discount', 'bn': 'ছাড়'},
    'promo': {'en': 'Promo', 'bn': 'প্রোমো'},
    'note': {'en': 'Note', 'bn': 'নোট'},
    'kitchen_note': {'en': 'Kitchen Note', 'bn': 'কিচেন নোট'},
    'bill_print': {'en': 'Bill Print', 'bn': 'বিল প্রিন্ট'},

    // ── POS Header ───────────────────────────────────────────────
    'dine_in': {'en': 'Dine In', 'bn': 'রেস্তোরাঁয়'},
    'take_away': {'en': 'Take Away', 'bn': 'নিয়ে যান'},
    'delivery': {'en': 'Delivery', 'bn': 'ডেলিভারি'},
    'search_hint': {'en': 'Search menu items...', 'bn': 'মেনু আইটেম খুঁজুন...'},
    'find_dish': {'en': 'Find your favourite dish...', 'bn': 'পছন্দের খাবার খুঁজুন...'},
    'all_items': {'en': 'All Items', 'bn': 'সব আইটেম'},
    'popular': {'en': 'Popular', 'bn': 'জনপ্রিয়'},

    // ── POS 3-dot Menu ───────────────────────────────────────────
    'waiter_menu': {'en': 'Waiter', 'bn': 'ওয়েটার'},
    'custom_item': {'en': 'Custom Item', 'bn': 'কাস্টম আইটেম'},
    'split_bill': {'en': 'Split Bill', 'bn': 'বিল ভাগ'},
    'transfer_order': {'en': 'Transfer Order', 'bn': 'অর্ডার স্থানান্তর'},
    'held_orders': {'en': 'Held Orders', 'bn': 'হোল্ড অর্ডার'},
    'shift_report': {'en': 'Shift Report', 'bn': 'শিফট রিপোর্ট'},
    'hardware_settings': {'en': 'Hardware Settings', 'bn': 'হার্ডওয়্যার সেটিংস'},
    'system_info': {'en': 'System Info', 'bn': 'সিস্টেম তথ্য'},
    'clear_cart_menu': {'en': 'Clear Cart', 'bn': 'কার্ট মুছুন'},
  };
}

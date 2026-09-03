class MedicineModel {
  final String id;
  final String name;
  final String genericName;
  final double price;
  final String category;
  final String imagePath;
  final bool isLowStock;
  final bool isExpiringSoon;
  final String? discountPercentage;

  MedicineModel({
    required this.id,
    required this.name,
    required this.genericName,
    required this.price,
    required this.category,
    required this.imagePath,
    this.isLowStock = false,
    this.isExpiringSoon = false,
    this.discountPercentage,
  });
}

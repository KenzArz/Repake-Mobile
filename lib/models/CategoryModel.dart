class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  final String id;
  final String name;
  final String? iconUrl;
}
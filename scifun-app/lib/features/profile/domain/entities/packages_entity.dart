class PackagesEntity {
  PackagesEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  final int? id;
  final String? name;
  final String? price;
  final List<String> description;
}

import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final int? price;
  final int? durationDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Plan copyWith({
    String? id,
    String? name,
    int? price,
    int? durationDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    final rawPrice = json["price"];
    final int? parsedPrice = rawPrice is num ? rawPrice.toInt() : null;

    return Plan(
      id: json["id"],
      name: json["name"],
      price: parsedPrice,
      durationDays: json["durationDays"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        durationDays,
        createdAt,
        updatedAt,
      ];
}

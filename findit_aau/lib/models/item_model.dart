import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String location;
  final String contactInfo;
  final String status; // 'Lost' or 'Found'
  final String date;

  const ItemModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.location,
    required this.contactInfo,
    required this.status,
    required this.date,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Other',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
      status: json['status'] ?? 'Lost',
      date: json['date'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'location': location,
      'contactInfo': contactInfo,
      'status': status,
      'date': date,
    };
  }

  ItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    String? location,
    String? contactInfo,
    String? status,
    String? date,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      contactInfo: contactInfo ?? this.contactInfo,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        imageUrl,
        location,
        contactInfo,
        status,
        date,
      ];
}

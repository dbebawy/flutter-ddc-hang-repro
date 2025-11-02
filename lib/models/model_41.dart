import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Model41 {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;
  
  Model41({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.metadata,
  });
  
  factory Model41.fromJson(Map<String, dynamic> json) => Model41(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    metadata: json['metadata'] as Map<String, dynamic>,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
  };
}

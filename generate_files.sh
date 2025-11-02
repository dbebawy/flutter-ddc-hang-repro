#!/bin/bash

# Generate many model files
for i in {1..50}; do
  cat > lib/models/model_$i.dart << DART
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Model$i {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;
  
  Model$i({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.metadata,
  });
  
  factory Model$i.fromJson(Map<String, dynamic> json) => Model$i(
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
DART
done

# Generate controller files
for i in {1..30}; do
  cat > lib/controllers/controller_$i.dart << DART
import 'package:get/get.dart';
import '../models/model_$i.dart';

class Controller$i extends GetxController {
  final data = <Model$i>[].obs;
  final isLoading = false.obs;
  final error = Rx<String?>(null);
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      data.value = List.generate(100, (index) => Model$i(
        id: 'id_\$index',
        name: 'Item \$index',
        description: 'Description for item \$index',
        createdAt: DateTime.now(),
        metadata: {'index': index},
      ));
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refresh() => loadData();
}
DART
done

# Generate widget files
for i in {1..40}; do
  cat > lib/ui/widgets/widget_$i.dart << DART
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/controller_${((i % 30) + 1)}.dart';

class Widget$i extends StatelessWidget {
  const Widget$i({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller${((i % 30) + 1)}());
    
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              final item = controller.data[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Text(item.createdAt.toString()),
                onTap: () {
                  Get.snackbar(
                    'Tapped',
                    'You tapped on \${item.name}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
            },
          ));
  }
}
DART
done

# Generate screen files
for i in {1..25}; do
  cat > lib/ui/screens/screen_$i.dart << DART
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/widget_${((i % 40) + 1)}.dart';

class Screen$i extends StatelessWidget {
  const Screen$i({super.key});
  
  static const String route = '/screen$i';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen $i'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic
            },
          ),
        ],
      ),
      body: const Widget${((i % 40) + 1)}(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'Action',
            'FloatingActionButton pressed',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
DART
done

echo "Generated 145 files (50 models, 30 controllers, 40 widgets, 25 screens)"

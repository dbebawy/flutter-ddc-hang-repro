import 'package:get/get.dart';
import '../models/model_1.dart';

class Controller1 extends GetxController {
  final data = <Model1>[].obs;
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
      data.value = List.generate(100, (index) => Model1(
        id: 'id_$index',
        name: 'Item $index',
        description: 'Description for item $index',
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

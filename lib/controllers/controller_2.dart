import 'package:get/get.dart';
import '../models/model_2.dart';

class Controller2 extends GetxController {
  final data = <Model2>[].obs;
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
      data.value = List.generate(100, (index) => Model2(
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

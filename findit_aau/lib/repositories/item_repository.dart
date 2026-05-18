import '../models/item_model.dart';
import '../services/api_service.dart';

class ItemRepository {
  final ApiService _apiService;

  ItemRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<ItemModel>> fetchItems() async {
    final data = await _apiService.getItems();
    return data
        .map((json) => ItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ItemModel> addItem(ItemModel item) async {
    final data = await _apiService.createItem(item.toJson());
    return ItemModel.fromJson(data);
  }

  Future<ItemModel> updateItem(ItemModel item) async {
    if (item.id == null) throw Exception('Item ID is required for update.');
    final data = await _apiService.updateItem(item.id!, item.toJson());
    return ItemModel.fromJson(data);
  }

  Future<void> deleteItem(String id) async {
    await _apiService.deleteItem(id);
  }
}

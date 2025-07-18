import 'package:flutter/material.dart';
import 'package:mall_blackstone/services/shopservices.dart';

class ShopProvider with ChangeNotifier {
  final ShopService _shopService = ShopService();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchItems() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _items = await _shopService.fetchShopItems();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

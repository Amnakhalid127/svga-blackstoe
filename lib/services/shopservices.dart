import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopService {
  final String baseUrl = 'https://www.blackstonevoicechatroom.online';
  final String endpoint = '/shop/items';

  Future<List<Map<String, dynamic>>> fetchShopItems() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

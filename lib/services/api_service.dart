import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';


class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://fakestoreapi.com';
  final http.Client _client;

  
  Future<String> login({required String username, required String password}) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');
    try {
      final http.Response res = await _client
          .post(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{'username': username, 'password': password}))
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(res.body) as Map<String, dynamic>;
        final String token = body['token'] as String? ?? '';
        if (token.isEmpty) throw const HttpException('Empty token');
        return token;
      }
      throw HttpException('Login failed: HTTP ${res.statusCode}');
    } on SocketException {
      throw const HttpException('No internet connection');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException('Unexpected login error: $e');
    }
  }

  
  Future<bool> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/users');
    try {
      final http.Response res = await _client
          .post(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                'email': email,
                'username': username,
                'password': password,
                'name': <String, String>{'firstname': username, 'lastname': ''},
                'address': <String, dynamic>{
                  'city': '',
                  'street': '',
                  'number': 0,
                  'zipcode': '00000',
                  'geolocation': <String, String>{'lat': '0', 'long': '0'},
                },
                'phone': '',
              }))
          .timeout(const Duration(seconds: 15));

      return res.statusCode == 200 || res.statusCode == 201;
    } on SocketException {
      throw const HttpException('No internet connection');
    } catch (e) {
      throw HttpException('Unexpected signup error: $e');
    }
  }

  
  Future<List<Product>> fetchProducts() async {
    final Uri url = Uri.parse('$_baseUrl/products');
    try {
      final http.Response res = await _client.get(url).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(res.body) as List<dynamic>;
        return list.map((dynamic e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw HttpException('Failed to load products: HTTP ${res.statusCode}');
    } on SocketException {
      throw const HttpException('No internet connection');
    } catch (e) {
      throw HttpException('Unexpected fetch error: $e');
    }
  }

  
  Future<Product> addProduct(Product product) async {
    final Uri url = Uri.parse('$_baseUrl/products');
    try {
      final http.Response res = await _client
          .post(url, headers: <String, String>{'Content-Type': 'application/json'}, body: jsonEncode(product.toJson()))
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw HttpException('Failed to add product: HTTP ${res.statusCode}');
    } on SocketException {
      throw const HttpException('No internet connection');
    } catch (e) {
      throw HttpException('Unexpected add error: $e');
    }
  }

  
  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw const HttpException('Product id is required for update');
    }
    final Uri url = Uri.parse('$_baseUrl/products/${product.id}');
    try {
      final http.Response res = await _client
          .put(url, headers: <String, String>{'Content-Type': 'application/json'}, body: jsonEncode(product.toJson()))
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw HttpException('Failed to update product: HTTP ${res.statusCode}');
    } on SocketException {
      throw const HttpException('No internet connection');
    } catch (e) {
      throw HttpException('Unexpected update error: $e');
    }
  }

  
  Future<bool> deleteProduct(int id) async {
    final Uri url = Uri.parse('$_baseUrl/products/$id');
    try {
      final http.Response res = await _client.delete(url).timeout(const Duration(seconds: 20));
      return res.statusCode == 200;
    } on SocketException {
      throw const HttpException('No internet connection');
    } catch (e) {
      throw HttpException('Unexpected delete error: $e');
    }
  }
}



// lib/services/payment_channel_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/models/payment_channel.dart';
import 'package:jawaramobile_1/services/api_client.dart';

class PaymentChannelService {
  static Future<List<PaymentChannel>> getChannels() async {
    final http.Response res = await ApiClient.get(
      '/payment-channels',
      auth: true,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => PaymentChannel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Gagal memuat channel transfer (status: ${res.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> createChannel({
    required String name,
    required String type,
    required String accountName,
    required String accountNumber,
    String? bankName,
    String? qrisImageUrl,
  }) async {
    final response = await ApiClient.post(
      '/payment-channels/',  // Note the trailing slash
      {
        'name': name,
        'type': type,
        'account_name': accountName,
        'account_number': accountNumber,
        'bank_name': bankName,
        'qris_image_url': qrisImageUrl,
      },
      auth: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }

    // Better error message
    String errorMsg = 'Failed to create channel';
    try {
      final errorBody = json.decode(response.body);
      if (errorBody['detail'] != null) {
        errorMsg = errorBody['detail'].toString();
      }
    } catch (e) {
      errorMsg = 'Status ${response.statusCode}: ${response.body}';
    }

    throw Exception(errorMsg);
  }
}
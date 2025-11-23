// lib/services/payment_channel_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawaramobile_1/models/payment_channel.dart';
import 'package:jawaramobile_1/services/api_client.dart';

class PaymentChannelService {
  static Future<List<PaymentChannel>> getChannels() async {
    final http.Response res = await ApiClient.get(
      '/payment-channels', // sesuaikan dengan backend-mu
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
}

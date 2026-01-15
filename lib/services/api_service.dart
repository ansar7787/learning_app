import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../data/models/home_model.dart';
import '../data/models/video_model.dart';
import '../data/models/streak_model.dart';

class ApiService {
  static Future<HomeResponse> getHomeData() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.homeEndpoint}'),
    );

    if (response.statusCode == 200) {
      return HomeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Home API failed');
    }
  }

  static Future<VideoResponse> getVideos() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.videosEndpoint}'),
    );

    if (response.statusCode == 200) {
      return VideoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Video API failed');
    }
  }

  static Future<StreakModel> getStreakData() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.streakEndpoint}'),
    );

    if (response.statusCode == 200) {
      return StreakModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Streak API failed');
    }
  }
}

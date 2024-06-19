import 'package:modarb_app/core/networking/api_service.dart';
import 'package:modarb_app/features/nutrition/data/models/today_intake_response.dart';

class NutritionRepo{

  final ApiService _apiService ;
  NutritionRepo(this._apiService);

  Future<TodayIntakeResponse> getTodayIntake() async {
    try {
      return await _apiService.getTodayIntake();
    } catch (error) {
      throw Exception('Failed to get data: $error');
    }
  }





}
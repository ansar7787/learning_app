import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static bool isOnboardingComplete() {
    return _box.read('onboarding_complete') ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    await _box.write('onboarding_complete', true);
  }
}

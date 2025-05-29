import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:hotel_booking/core/force_update/force_update_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateService {
  final FirebaseRemoteConfig _remoteConfig;

  ForceUpdateService(this._remoteConfig);

  Future<void> initialize() async {
    try {
      // 1. تعيين القيم الافتراضية
      await _remoteConfig.setDefaults({
        'min_app_version': '1.0.0', // القيمة الافتراضية
        'force_update_enabled': false, // القيمة الافتراضية
      });

      // 2. ضبط إعدادات الجلب
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // أثناء التطوير
      ));

      // 3. جلب وتنشيط القيم
      await _remoteConfig.fetchAndActivate();

      debugPrint('تم تهيئة Remote Config بنجاح');
      debugPrint('القيم المتاحة: ${_remoteConfig.getAll()}');
    } catch (e) {
      debugPrint('خطأ في تهيئة Remote Config: $e');
    }
  }

  Future<bool> isUpdateRequired() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final minVersion = _remoteConfig.getString('min_app_version');
      final isForceUpdateEnabled = _remoteConfig.getBool('force_update_enabled');

      debugPrint('''
      Force Update Check:
      - Current: $currentVersion
      - Minimum: $minVersion
      - Enabled: $isForceUpdateEnabled
      ''');

      return isForceUpdateEnabled &&
          ForceUpdateUtils.compareVersions(currentVersion, minVersion) < 0;
    } catch (e) {
      debugPrint('Error in isUpdateRequired: $e');
      return false;
    }
  }
}
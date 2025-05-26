import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'models/device_info_model.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    debugPrint('Running on ${androidInfo.model}'); // Cihaz modeli (ör: SM-G998B)
    debugPrint('Android sürümü: ${androidInfo.version.release}'); // Android OS sürümü (ör: 13)
    debugPrint('Üretici: ${androidInfo.manufacturer}'); // Cihaz üreticisi (ör: samsung)

  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    debugPrint('Running on ${iosInfo.utsname.machine}'); // Cihaz türü (ör: iPhone14,7) - Model adı değil, donanım tanımlayıcısı
    debugPrint('Cihaz Adı: ${iosInfo.name}'); // Cihazın kullanıcı tarafından verilen adı (ör: Benim iPhone'um)
    debugPrint('Sistem Adı: ${iosInfo.systemName}'); // Sistem adı (ör: iOS)
    debugPrint('Sistem Versiyonu: ${iosInfo.systemVersion}'); // iOS sürümü (ör: 16.0)
    debugPrint('Model: ${iosInfo.model}'); // Cihaz modeli (ör: iPhone)

  } else if (Platform.isMacOS) {
     MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
     debugPrint('Running on macOS ${macOsInfo.osRelease}'); // macOS sürümü (ör: 12.3)
     debugPrint('Model Adı: ${macOsInfo.model}'); // Mac modeli (ör: MacBookPro18,1)

  }
  // Diğer platformlar için (Windows, Linux, Web) de benzer bilgiler alabilirsiniz.
  // Web için: WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
}

Future<MyAppDeviceInfo> getDeviceInfo2() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String platform;
  String? osVersion;
  String? model;
  String? deviceName;
  String? manufacturer;
  String? browserName;
  String? browserVersion;


  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    platform = 'android';
    osVersion = androidInfo.version.release;
    model = androidInfo.model;
    manufacturer = androidInfo.manufacturer;

  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    platform = 'ios';
    osVersion = iosInfo.systemVersion;
    model = iosInfo.utsname.machine; // Hardware identifier
    deviceName = iosInfo.name; // User-assigned name
    // iOS'ta genellikle manufacturer bilgisi standart olarak alınmaz

  } else if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    platform = 'web';
    browserName = webInfo.browserName.toString().split('.').last; // Enum'dan string'e çevir
    browserVersion = webInfo.userAgent; // userAgent genellikle sürümü içerir, veya spesifik alanlar da olabilir
    // Web'de OS Version, Model, Manufacturer gibi kavramlar doğrudan cihazdaki gibi işlemez

  } else if (Platform.isMacOS) {
    MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
    platform = 'macos';
    osVersion = macOsInfo.osRelease;
    model = macOsInfo.model;

  }
   else if (Platform.isWindows) {
     WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
     platform = 'windows';
     osVersion = windowsInfo.releaseId.isNotEmpty ? windowsInfo.releaseId : windowsInfo.buildNumber.toString();
     model = windowsInfo.computerName; // Bilgisayar adı

  }
   else if (Platform.isLinux) {
     LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
     platform = 'linux';
     osVersion = linuxInfo.version; // Linux dağıtım sürümü
     model = linuxInfo.prettyName; // Dağıtım adı

  }
  else {
    platform = 'unknown';
    // Bilinmeyen platformlar için bilgiler boş kalır
  }

  // Topladığınız bilgileri MyAppDeviceInfo sınıfına aktarın
  return MyAppDeviceInfo(
    platform: platform,
    osVersion: osVersion,
    model: model,
    deviceName: deviceName,
    manufacturer: manufacturer,
    browserName: browserName,
    browserVersion: browserVersion,
  );
}
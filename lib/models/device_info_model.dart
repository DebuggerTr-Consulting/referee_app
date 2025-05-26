class MyAppDeviceInfo {
  final String platform; // android, ios, web, macos, etc.
  final String? osVersion; // 13, 16.0, 12.3 etc.
  final String? model; // SM-G998B, iPhone14,7, MacBookPro18,1 etc.
  final String? deviceName; // User-assigned device name (iOS)
  final String? manufacturer; // samsung (Android)
  final String? browserName; // Chrome, Firefox (Web)
  final String? browserVersion; // 110.0.5481.100 (Web)


  MyAppDeviceInfo({
    required this.platform,
    this.osVersion,
    this.model,
    this.deviceName,
    this.manufacturer,
    this.browserName,
    this.browserVersion,
  });

  // İsteğe bağlı: Bu bilgiyi Map olarak döndüren bir method
  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
      'osVersion': osVersion,
      'model': model,
      'deviceName': deviceName,
      'manufacturer': manufacturer,
      'browserName': browserName,
      'browserVersion': browserVersion,
    };
  }
}
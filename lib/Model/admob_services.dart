import 'dart:io';

class AdMobServices {
  String getAdMobAppId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-6414358134929772~3794478078";
    }
    return null;
  }

  String getBanerAppId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-6414358134929772/3299654056";
    }
    return null;
  }
}

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  bool get isAdLoaded => _isAdLoaded;

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3741659942413980/8735305607',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoaded = true;
          print('Quảng cáo Mở ứng dụng(Open App) đã được tải thành công.');
        },
        onAdFailedToLoad: (error) {
          print('Không thể tải quảng cáo Mở ứng dụng(Open App): $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_isAdLoaded && _appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Quảng cáo đã bị đóng.');
          _isAdLoaded = false;
          loadAppOpenAd(); // Tải lại quảng cáo mới sau khi hiển thị
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Quảng cáo không thể hiển thị: $error');
          _isAdLoaded = false;
          loadAppOpenAd(); // Tải lại quảng cáo mới
        },
      );
      _appOpenAd!.show();
      _appOpenAd = null; // Xóa quảng cáo đã hiển thị
    } else {
      print('Quảng cáo chưa được tải hoặc đã bị hủy.');
    }
  }
}

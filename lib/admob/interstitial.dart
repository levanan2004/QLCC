import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3741659942413980/9159382402', // Thay thế bằng ID quảng cáo của bạn
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Tải quảng cáo Trung gian(Interstitial) thất bại: $error');
          _interstitialAd = null; // Đặt lại biến quảng cáo
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          // Tải quảng cáo mới sau khi quảng cáo hiện tại bị đóng
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
          ad.dispose();
          // Tải quảng cáo mới sau khi không thể hiển thị quảng cáo hiện tại
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      print('Quảng cáo Trung gian(Interstitial) chưa được tải lên.');
      // Thực hiện hành động thay thế nếu quảng cáo không có sẵn
      // Ví dụ: hiển thị một dialog thông báo hoặc chuyển hướng người dùng
    }
  }
}

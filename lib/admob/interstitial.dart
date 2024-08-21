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
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
          ad.dispose();
        },
      );
      _interstitialAd!.show();
    } else {
      print('Quảng cáo Trung gian(Interstitial) chưa được tải lên.');
    }
  }
}

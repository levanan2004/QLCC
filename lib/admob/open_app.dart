import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  AppOpenAd? _appOpenAd;
  bool _isAdLoading = false;

  void loadAd() {
    if (_isAdLoading) return; // Prevent loading multiple ads simultaneously

    _isAdLoading = true;

    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3741659942413980/8735305607',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoading = false;
          _appOpenAd!.show();
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _appOpenAd = null;
              _isAdLoading = false;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _appOpenAd = null;
              _isAdLoading = false;
              debugPrint('Ad failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdLoading = false;
          debugPrint('Error: $error');
        },
      ),
    );
  }
}

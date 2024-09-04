import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3741659942413980/8679465280', // Thay thế bằng ID quảng cáo của bạn
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => print('Banner ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          print('Tải quảng cáo Biểu ngữ(Banner) thất bại: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : SizedBox(height: 80), // Placeholder while loading
      width: _bannerAd?.size.width.toDouble() ?? 0,
      height: _bannerAd?.size.height.toDouble() ?? 0,
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

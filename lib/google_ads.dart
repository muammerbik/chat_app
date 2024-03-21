import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class GoogleAds with ChangeNotifier {
  static const String banner1 = "ca-app-pub-3940256099942544/6300978111";
  static const String interstitial1 = "ca-app-pub-3940256099942544/1033173712";
  static const String rewardad1 = "ca-app-pub-3940256099942544/5224354917";
  static const String appId = "ca-app-pub-8080828811373662~8857348352";
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: banner1,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadInterstitialAd({bool showAfterLoad = false}) {
    InterstitialAd.load(
      adUnitId: interstitial1,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("reklam yüklendi");
          interstitialAd = ad;
          if (showAfterLoad) showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }

  void loadRewardAd() {
    RewardedAd.load(
      adUnitId: rewardad1,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('  reklam geldi!! $ad loaded.');

          rewardedAd = ad;
          rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {},
          );
          rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}

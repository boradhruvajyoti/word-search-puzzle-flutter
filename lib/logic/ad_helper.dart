// Logic: AdHelper — Mobile ads helper to manage Interstitial and Rewarded ads
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  static bool _isInterstitialLoading = false;
  static bool _isRewardedLoading = false;

  // Google AdMob Ad Unit IDs
  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    try {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3811425395582544/2514405666';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3811425395582544/2643961275';
      }
    } catch (_) {}
    return '';
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    try {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3811425395582544/5080859253';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3811425395582544/6010797540';
      }
    } catch (_) {}
    return '';
  }

  /// Initializes the Mobile Ads SDK and preloads ads safely.
  static Future<void> init() async {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await MobileAds.instance.initialize();
        loadInterstitialAd();
        loadRewardedAd();
      }
    } catch (e) {
      debugPrint('AdHelper: failed to initialize ads: $e');
    }
  }

  /// Preloads an Interstitial Ad (skippable video).
  static void loadInterstitialAd() {
    if (kIsWeb) return;
    try {
      if (!Platform.isAndroid && !Platform.isIOS) return;
    } catch (_) {
      return;
    }
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('AdHelper: Interstitial Ad Loaded.');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('AdHelper: Interstitial Ad Failed to Load: $error');
        },
      ),
    );
  }

  /// Preloads a Rewarded Ad.
  static void loadRewardedAd() {
    if (kIsWeb) return;
    try {
      if (!Platform.isAndroid && !Platform.isIOS) return;
    } catch (_) {
      return;
    }
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          debugPrint('AdHelper: Rewarded Ad Loaded.');
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          _rewardedAd = null;
          debugPrint('AdHelper: Rewarded Ad Failed to Load: $error');
        },
      ),
    );
  }

  /// Shows the preloaded skippable Interstitial ad.
  /// Calls [onAdDismissed] when closed or if the ad failed to show.
  static void showInterstitialAd(VoidCallback onAdDismissed) {
    if (_interstitialAd == null) {
      debugPrint('AdHelper: Interstitial Ad not ready, skipping to action.');
      onAdDismissed();
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
        loadInterstitialAd(); // Load next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
        loadInterstitialAd(); // Load next one
      },
    );

    _interstitialAd!.show();
  }

  /// Shows the preloaded Rewarded video ad.
  /// Calls [onRewardGranted] only if the user finishes watching the ad.
  /// Calls [onAdClosed] when closed or if the ad failed to load/show.
  static void showRewardedAd({
    required VoidCallback onRewardGranted,
    required VoidCallback onAdClosed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('AdHelper: Rewarded Ad not ready, granting fallback bypass.');
      onRewardGranted(); // Fallback so user is not blocked
      onAdClosed();
      loadRewardedAd();
      return;
    }

    bool rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        if (rewardEarned) {
          onRewardGranted();
        }
        onAdClosed();
        loadRewardedAd(); // Load next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onRewardGranted(); // Fail-safe fallback
        onAdClosed();
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewardEarned = true;
      },
    );
  }
}

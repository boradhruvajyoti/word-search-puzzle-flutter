// Logic: AdHelper — Mobile ads helper to manage Interstitial and Rewarded ads
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AdHelper {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  static bool _isInterstitialLoading = false;
  static bool _isRewardedLoading = false;

  static int _interstitialRetryAttempts = 0;
  static int _rewardedRetryAttempts = 0;
  static const int _maxRetryAttempts = 4;

  /// Set to true to force Google official test ads during development and testing.
  /// Defaults to kDebugMode so testing is 100% compliant with AdMob policies.
  static bool useTestAds = kDebugMode;

  // Google AdMob Official Sample Test Ad Unit IDs (100% fill, policy compliant)
  static const String _testAndroidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testIosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testIosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  // Production Ad Unit IDs
  static const String _prodAndroidInterstitial = 'ca-app-pub-3811425395582544/2514405666';
  static const String _prodAndroidRewarded = 'ca-app-pub-3811425395582544/5080859253';
  static const String _prodIosInterstitial = 'ca-app-pub-3811425395582544/2643961275';
  static const String _prodIosRewarded = 'ca-app-pub-3811425395582544/6010797540';

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    try {
      if (Platform.isAndroid) {
        return useTestAds ? _testAndroidInterstitial : _prodAndroidInterstitial;
      } else if (Platform.isIOS) {
        return useTestAds ? _testIosInterstitial : _prodIosInterstitial;
      }
    } catch (_) {}
    return '';
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    try {
      if (Platform.isAndroid) {
        return useTestAds ? _testAndroidRewarded : _prodAndroidRewarded;
      } else if (Platform.isIOS) {
        return useTestAds ? _testIosRewarded : _prodIosRewarded;
      }
    } catch (_) {}
    return '';
  }

  /// Whether an interstitial ad is preloaded and ready to show.
  static bool get isInterstitialReady => _interstitialAd != null;

  /// Whether a rewarded ad is preloaded and ready to show.
  static bool get isRewardedReady => _rewardedAd != null;

  /// Requests iOS App Tracking Transparency (ATT) permission if applicable.
  static Future<void> requestTrackingAuthorization() async {
    if (kIsWeb) return;
    try {
      if (Platform.isIOS) {
        final status = await AppTrackingTransparency.trackingAuthorizationStatus;
        debugPrint('AdHelper: Current ATT status: $status');
        if (status == TrackingStatus.notDetermined) {
          final requestedStatus =
              await AppTrackingTransparency.requestTrackingAuthorization();
          debugPrint('AdHelper: Requested ATT result: $requestedStatus');
        }
      }
    } catch (e) {
      debugPrint('AdHelper: App Tracking Transparency error: $e');
    }
  }

  /// Initializes the Mobile Ads SDK and preloads ads safely.
  static Future<void> init() async {
    if (kIsWeb) return;
    try {
      if (Platform.isIOS) {
        await requestTrackingAuthorization();
      }

      if (Platform.isAndroid || Platform.isIOS) {
        await MobileAds.instance.initialize();
        debugPrint('AdHelper: MobileAds initialized (useTestAds=$useTestAds)');
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

    final adUnitId = interstitialAdUnitId;
    debugPrint('AdHelper: Loading Interstitial Ad ($adUnitId)...');

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialRetryAttempts = 0;
          debugPrint('AdHelper: Interstitial Ad Loaded successfully.');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('AdHelper: Interstitial Ad Failed to Load: $error (Code: ${error.code})');
          _interstitialRetryAttempts++;
          if (_interstitialRetryAttempts <= _maxRetryAttempts) {
            final delay = Duration(seconds: _interstitialRetryAttempts * 4);
            debugPrint('AdHelper: Retrying Interstitial Ad load in ${delay.inSeconds}s (attempt $_interstitialRetryAttempts)');
            Future.delayed(delay, loadInterstitialAd);
          }
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

    final adUnitId = rewardedAdUnitId;
    debugPrint('AdHelper: Loading Rewarded Ad ($adUnitId)...');

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedRetryAttempts = 0;
          debugPrint('AdHelper: Rewarded Ad Loaded successfully.');
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          _rewardedAd = null;
          debugPrint('AdHelper: Rewarded Ad Failed to Load: $error (Code: ${error.code})');
          _rewardedRetryAttempts++;
          if (_rewardedRetryAttempts <= _maxRetryAttempts) {
            final delay = Duration(seconds: _rewardedRetryAttempts * 4);
            debugPrint('AdHelper: Retrying Rewarded Ad load in ${delay.inSeconds}s (attempt $_rewardedRetryAttempts)');
            Future.delayed(delay, loadRewardedAd);
          }
        },
      ),
    );
  }

  /// Shows the preloaded skippable Interstitial ad.
  /// Calls [onAdDismissed] when closed or if the ad failed to show.
  static void showInterstitialAd(VoidCallback onAdDismissed) {
    if (_interstitialAd == null) {
      debugPrint('AdHelper: Interstitial Ad not ready, proceeding with action.');
      onAdDismissed();
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdHelper: Interstitial ad dismissed by user.');
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
        loadInterstitialAd(); // Preload next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdHelper: Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
        loadInterstitialAd(); // Preload next one
      },
    );

    _interstitialAd!.show();
  }

  /// Shows the preloaded Rewarded video ad.
  /// Calls [onRewardGranted] only if the user finishes watching the ad (or on fail-safe).
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
        debugPrint('AdHelper: Rewarded ad dismissed. Reward earned: $rewardEarned');
        ad.dispose();
        _rewardedAd = null;
        if (rewardEarned) {
          onRewardGranted();
        }
        onAdClosed();
        loadRewardedAd(); // Preload next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdHelper: Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        onRewardGranted(); // Fail-safe fallback so user is not stuck
        onAdClosed();
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('AdHelper: User earned reward: ${reward.amount} ${reward.type}');
        rewardEarned = true;
      },
    );
  }
}


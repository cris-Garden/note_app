// // Copyright 2017 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // ignore_for_file: public_member_api_docs
// import 'package:firebase_admob/firebase_admob.dart';

// import 'app_util.dart';

// class AdmodUtil {
//   static final AdmodUtil _util = AdmodUtil._internal();

//   AdmodUtil._internal();

//   factory AdmodUtil() {
//     return _util;
//   }

//   Future<bool> show() async {
//     await hidden();
//     _bannerAd = createBannerAd();
//     await _bannerAd.load();
//     return await _bannerAd.show(horizontalCenterOffset:0,anchorOffset: 60);
//   }

//   Future<bool> showBottom() async {
//     await hidden();
//     _bannerAd = createBannerAd();
//     await _bannerAd.load();
//     return await _bannerAd.show(horizontalCenterOffset:0,anchorOffset:0);
//   }

//   Future<bool> hidden() async {
//     if(_bannerAd==null){
//       return false;
//     }
//     final dis = await _bannerAd?.dispose();
//     _bannerAd = null;
//     return dis;
//   }

//   init() async {
//     FirebaseAdMob.instance.initialize(appId:AppUtil.isReleaseContext() ? appID : FirebaseAdMob.testAppId);
//     RewardedVideoAd.instance.listener =
//         (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//       print("RewardedVideoAd event $event");
//       if (event == RewardedVideoAdEvent.rewarded) {}
//     };
//   }

//   static const adUnitID = 'ca-app-pub-9899963092044978/6408931493';
//   static const appID = 'ca-app-pub-9899963092044978~7913584850';

//   static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     childDirected: true,
//     nonPersonalizedAds: true,
//   );

//   BannerAd _bannerAd;
//   NativeAd _nativeAd;
//   InterstitialAd _interstitialAd;
//   int _coins = 0;

//   BannerAd createBannerAd() {
//     if(_bannerAd == null){
//       _bannerAd = BannerAd(
//         adUnitId: AppUtil.isReleaseContext() ? adUnitID : BannerAd.testAdUnitId,
//         size: AdSize.fullBanner,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) {
//           print("BannerAd event $event");
//         },
//       );
//     }
//     return _bannerAd;
//   }

//   InterstitialAd createInterstitialAd() {
//     return InterstitialAd(
//       adUnitId: InterstitialAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("InterstitialAd event $event");
//       },
//     );
//   }

//   NativeAd createNativeAd() {
//     return NativeAd(
//       adUnitId: NativeAd.testAdUnitId,
//       factoryId: 'adFactoryExample',
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("$NativeAd event $event");
//       },
//     );
//   }
// }

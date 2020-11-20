//
//  AdmobView.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/11/21.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import SwiftUI
import GoogleMobileAds


struct AdmobView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

struct AdmobView_Previews: PreviewProvider {
    static var previews: some View {
        AdmobView()
    }
}

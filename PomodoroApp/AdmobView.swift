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
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        banner.adUnitID = "ca-app-pub-4588764854563805/4203830120"
        #endif
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

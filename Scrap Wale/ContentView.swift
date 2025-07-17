//
//  ContentView.swift
//  Scrap Wale
//
//  Created by WEBbrella Infotech on 17/07/25.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://scrap-wale.in")!) // Or your site
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

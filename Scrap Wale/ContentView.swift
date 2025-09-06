//
//  ContentView.swift
//  Scrap Wale
//
//  Created by WEBbrella Infotech on 17/07/25.
//

import SwiftUI

// MARK: - Main ContentView
struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area
            Group {
                switch selectedTab {
                case .home:
                    WebView(url: URL(string: "https://scrap-wale.in/app/index.html")!)
                case .about:
                    WebView(url: URL(string: "https://scrap-wale.in/app/about.html")!)
                case .services:
                    WebView(url: URL(string: "https://scrap-wale.in/app/services.html")!)
                case .scrapRates:
                    ScrapRatesView()
                case .contact:
                    WebView(url: URL(string: "https://scrap-wale.in/app/contact.html")!)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            Divider()
            
            // Bottom Menu
            HStack(spacing: 0) {
                TabButton(tab: .home, selectedTab: $selectedTab)
                TabButton(tab: .about, selectedTab: $selectedTab)
                TabButton(tab: .services, selectedTab: $selectedTab)
                TabButton(tab: .scrapRates, selectedTab: $selectedTab)
                TabButton(tab: .contact, selectedTab: $selectedTab)
            }
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground).shadow(radius: 2))
        }
    }
}

// MARK: - Tab Enum
enum Tab: String, CaseIterable {
    case home = "Home"
    case about = "About"
    case services = "Service"
    case scrapRates = "Scrap Rates"
    case contact = "Contact"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .about: return "info.circle.fill"
        case .services: return "gearshape.fill"
        case .scrapRates: return "dollarsign.circle.fill"
        case .contact: return "phone.fill"
        }
    }
}

// MARK: - Bottom Tab Button
struct TabButton: View {
    var tab: Tab
    @Binding var selectedTab: Tab
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? Color(hex: "#0A9642") : .gray)
                Text(tab.rawValue)
                    .font(.caption2)
                    .foregroundColor(selectedTab == tab ? Color(hex: "#0A9642") : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

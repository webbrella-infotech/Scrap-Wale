import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var titleOffset: CGFloat = 50
    @State private var titleOpacity: Double = 0.0
    @State private var subtitleOffset: CGFloat = 50
    @State private var subtitleOpacity: Double = 0.0

    var body: some View {
        if isActive {
            // Navigate to main app
            ContentView()
        } else {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {
                    // Logo
                    Image("scrap_wale_logo") // Ensure asset exists
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.2)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                        //.shadow(color: .gray.opacity(0.4), radius: 5, x: 2, y: 2)

                    // Title
                    /*Text("SCRAP")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "#0A9642"))
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.2).delay(0.8)) {
                                titleOffset = 0
                                titleOpacity = 1.0
                            }
                        }

                    // Subtitle
                    Text("Recycle Made Easy")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "#fe5716"))
                        .opacity(subtitleOpacity)
                        .offset(y: subtitleOffset)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.2).delay(1.0)) {
                                subtitleOffset = 0
                                subtitleOpacity = 1.0
                            }
                        }*/
                }
            }
            .onAppear {
                // Navigate after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

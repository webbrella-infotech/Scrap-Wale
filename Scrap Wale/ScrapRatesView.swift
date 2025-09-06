import SwiftUI

struct ScrapRatesView: View {
    @StateObject private var viewModel = ScrapRatesViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    var onSupportTap: (() -> Void)?
    
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)
                    
                    if viewModel.isLoading {
                        ProgressView("Loading rates...")
                            .padding(.top, 200)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "wifi.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            Text("Failed to Load Rates")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(error)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Retry") { viewModel.fetchRates() }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 200)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            ForEach(viewModel.categories) { category in
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(category.category_name)
                                        .font(.title.bold())
                                        .padding(.horizontal)
                                    
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(category.items) { item in
                                            ScrapItemGrid(item: item, viewModel: viewModel)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = value
                }
                
                Color.green
                    .opacity(scrollOffset < -10 ? 1 : 0)
                    .frame(height: 100)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("scrap_wale_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { onSupportTap?() } label: {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.categories.isEmpty {
                viewModel.fetchRates()
            }
        }
    }
}

struct ScrapItemGrid: View {
    let item: ScrapItem
    @ObservedObject var viewModel: ScrapRatesViewModel
    
    var body: some View {
        NavigationLink(destination: ScrapRateDetailPage(item: item, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: item.safeImageURL) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Color.gray.opacity(0.1).overlay(Image(systemName: "photo.fill"))
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Text(item.item_name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("₹\(item.price, specifier: "%.2f")")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        Text("/ \(item.unit.lowercased())")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding(5)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

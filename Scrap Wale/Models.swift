import Foundation

// Response wrapper
struct ScrapRateResponse: Codable {
    let status: String
    let data: [ScrapCategory]
}

// Category with items
struct ScrapCategory: Codable, Identifiable {
    let id: Int
    let category_name: String
    let items: [ScrapItem]
    
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case category_name, items
    }
}

// Item with nested category info
struct ScrapItem: Codable, Identifiable {
    let id: Int
    let item_name: String
    let price: Double
    let unit: String
    let image_url: String
    let category: ScrapCategoryLite?
    
    struct ScrapCategoryLite: Codable {
        let id: Int
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case item_name, price, unit, image_url, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        item_name = try container.decode(String.self, forKey: .item_name)
        unit = try container.decode(String.self, forKey: .unit)
        image_url = try container.decode(String.self, forKey: .image_url)
        category = try? container.decode(ScrapCategoryLite.self, forKey: .category)
        
        let priceString = try container.decode(String.self, forKey: .price)
        price = Double(priceString) ?? 0.0
    }
    
    var safeImageURL: URL? {
        URL(string: image_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}

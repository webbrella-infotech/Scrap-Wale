import Foundation
import SwiftUI

class ScrapRatesViewModel: ObservableObject {
    @Published var categories: [ScrapCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func fetchRates() {
        guard let url = URL(string: "https://scrap-wale.in/api/scrap-rates.php") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ScrapRateResponse.self, from: data)
                DispatchQueue.main.async {
                    self.categories = decoded.data
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func submitEnquiry(itemId: Int, name: String, phone: String, email: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "https://scrap-wale.in/api/scrap-enquiry.php") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "item_id=\(itemId)&name=\(name)&phone=\(phone)&email=\(email)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                completion(true, "Enquiry submitted successfully")
            }
        }.resume()
    }
}

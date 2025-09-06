import SwiftUI

struct ScrapRateDetailPage: View {
    let item: ScrapItem
    @ObservedObject var viewModel: ScrapRatesViewModel
    
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // HERO IMAGE
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: item.safeImageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 250)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red.opacity(0.3)
                                .overlay(Text("Image failed"))
                                .frame(height: 250)
                        } else {
                            Color.gray.opacity(0.3)
                                .overlay(ProgressView())
                                .frame(height: 250)
                        }
                    }
                    
//                    LinearGradient(
//                        gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
//                        startPoint: .bottom,
//                        endPoint: .center
//                    )
//                    .frame(height: 120)
//                    .frame(maxHeight: .infinity, alignment: .bottom)
                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text(item.item_name)
//                            .font(.title.bold())
//                            .foregroundColor(.white)
//                        
//                        HStack {
//                            Text("₹\(item.price, specifier: "%.2f")")
//                                .font(.title2.bold())
//                                .foregroundColor(.green)
//                            Text("/ \(item.unit.uppercased())")
//                                .font(.headline)
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                    }
//                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .padding(.horizontal)
                
                // DETAILS
                VStack(alignment: .leading, spacing: 12) {
//                    Text("Details")
//                        .font(.headline)
//                        .padding(.bottom, 4)
                    
                    HStack {
                        Text(item.item_name)
                             .font(.title.bold())
                    }
                    
//                    HStack {
//                        Text("Category:").fontWeight(.semibold)
//                        Spacer()
//                        Text(item.category?.name ?? "--")
//                    }
                    
                    HStack {
                        Text("Price:").fontWeight(.semibold)
                        Spacer()
                        Text("₹\(item.price, specifier: "%.2f") / \(item.unit.uppercased())")
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .padding(.horizontal)
                
                // ENQUIRY FORM
                VStack(alignment: .leading, spacing: 16) {
                    Text("Send Enquiry").font(.title2.bold())
                    
                    VStack(spacing: 14) {
                        TextField("Name (Required)", text: $name)
                            .textFieldStyle(ModernTextFieldStyle())
                        
                        TextField("Phone (Required)", text: $phone)
                            .textFieldStyle(ModernTextFieldStyle())
                            .keyboardType(.phonePad)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(ModernTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    Button(action: submitEnquiry) {
                        if isSubmitting {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity).padding()
                        } else {
                            Text("Submit Enquiry")
                                .font(.headline).frame(maxWidth: .infinity).padding()
                        }
                    }
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(!isFormValid || isSubmitting)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Enquiry Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: { Text(alertMessage) }
    }
    
    private func submitEnquiry() {
        isSubmitting = true
        viewModel.submitEnquiry(itemId: item.id, name: name, phone: phone, email: email) { success, msg in
            isSubmitting = false
            alertMessage = msg
            showAlert = true
            
            if success {
                name = ""; phone = ""; email = ""
            }
        }
    }
}

private struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(14)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
    }
}

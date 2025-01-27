import SwiftUI

struct Product: View {
    let fullScanHistoryEntry: FullScanHistoryEntry
//    let productImageURL: String
//    let productName: String
//    let description: String
//    let reviewAverage: String
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                AsyncImage(url: URL(string: fullScanHistoryEntry.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped()
                            .cornerRadius(30)
                    case .failure:
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(spacing: 10) {
                    if fullScanHistoryEntry.average_grade > 0.0 {
                        Text(Image(systemName: "star"))
                        + Text(" \(String(round(fullScanHistoryEntry.average_grade*10)/10)) ")
                        + Text(fullScanHistoryEntry.name)
                            .font(.headline)
                    } else {
                        Text(fullScanHistoryEntry.name)
                            .font(.headline)
                    }
                    
                    Text(fullScanHistoryEntry.description)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: 170)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
}

#Preview {
    Product(fullScanHistoryEntry: FullScanHistoryEntry(
        id: 1234567890123,
        name: "MacBook Pro",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        image: "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        average_grade: 4.7,
        timestamp: "01.01.2025"))
}

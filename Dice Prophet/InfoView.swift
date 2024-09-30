import SwiftUI

struct CreatorInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("DiceLogo") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Dice Prophet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("AbacusNoir Apps")
                    .font(.headline)
                
                Text("Version 1.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("© 2024 All rights reserved")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

#Preview {
    CreatorInfoView()
}
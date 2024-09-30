import SwiftUI

struct CreatorInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Dice Prophet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Created by Agam Brahma")
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
//
//  UserInfoView.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

struct UserInfoView: View {
    let user: User
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // Avatar
                AsyncImage(url: user.avatar) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 280, height: 280)
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 8)
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding()

                // Name
                Text(user.name)
                    .bold()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)

                // Username
                Text("@\(user.username)")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.darkGray))

                HStack(spacing: 4) {

                    // User Email
                    Text(user.email)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(isValidEmailDomain ? .green : .red)

                    // Email Validation
                    if !isValidEmailDomain {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .accessibilityLabel("Invalid email domain")
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color.mint.opacity(0.24))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
  
                    // Dismiss Button
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }

    private var isValidEmailDomain: Bool {
        Validator.isValidEmailDomain(user.email)
    }
}

#Preview {
    UserInfoView(user: User.userA)
}

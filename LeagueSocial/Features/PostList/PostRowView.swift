//
//  PostRowView.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

struct PostRowView: View {
    let post: Post
    let onTapGesture: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 8) {

                // Avator image
                AsyncImage(url: post.user?.avatar) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color.gray)
                    default:
                        EmptyView()
                    }
                }

                // Username
                Text(post.user?.username ?? "unknown")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 72, alignment: .center)
            }
            .onTapGesture { onTapGesture() }

            // Post title & description
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(post.body)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 8)
    }
}

#Preview {
    PostRowView(post: Post.mock.first!, onTapGesture: {})
        .background(Color.mint.opacity(0.2))
}

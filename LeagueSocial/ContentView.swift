//
//  ContentView.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dependencies) private var dependencies

    var body: some View {
        NavigationStack {
            LoginView(viewModel: LoginViewModel(api: dependencies.apiService))
        }
    }
}

#Preview {
    ContentView()
        .environment(\.dependencies, Container(apiService: MockAPIService()))
}

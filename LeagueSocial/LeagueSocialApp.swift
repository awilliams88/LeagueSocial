//
//  LeagueSocialApp.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

@main
struct LeagueSocialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencies, Container(apiService: APIService()))
        }
    }
}

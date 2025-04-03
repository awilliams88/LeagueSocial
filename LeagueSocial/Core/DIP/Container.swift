//
//  Container.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

/// A container to hold global dependencies for dependecy injection using @Environment.
struct Container {
    let apiService: APIServiceProtocol
}

private struct ContainerKey: EnvironmentKey {
    static let defaultValue = Container(
        apiService: APIService()
    )
}

extension EnvironmentValues {
    var dependencies: Container {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }
}

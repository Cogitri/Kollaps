//
//  AppState.swift
//  Kollaps
//
//  Created by Rasmus Thomsen on 27.04.23.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var queue = DispatchQueue(label: "wormhole-runner")
}


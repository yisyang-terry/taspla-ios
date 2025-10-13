//
//  TasplaApp.swift
//  Taspla
//
//  Created by Scott  Yang on 10/12/25.
//

import SwiftUI

@main
struct TasplaApp: App {
    // Keep a single store instance for the app lifetime.
    @StateObject private var store = AppStore()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}

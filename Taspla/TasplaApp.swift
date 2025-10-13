//
//  TasplaApp.swift
//  Taspla
//
//  Created by Scott  Yang on 10/12/25.
//

import SwiftUI

@main
struct TasplaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppStore())
        }
    }
}

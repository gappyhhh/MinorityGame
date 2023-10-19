//
//  MinorityGameApp.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/08/24.
//

import SwiftUI
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//
//    return true
//  }
    
//}
@main
struct MinorityGameApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
                ContentView()
                .onChange(of:scenePhase) {
                    phase in
                    switch phase {
                    case .active:
                        print("active")
                    case .inactive:
                        print("inactive")
                    case .background:
                        print("background")
                    @unknown default:
                        print("@unknown")
                    }
                }
        }
    }
}



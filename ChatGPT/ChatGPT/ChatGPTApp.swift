//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ChatTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

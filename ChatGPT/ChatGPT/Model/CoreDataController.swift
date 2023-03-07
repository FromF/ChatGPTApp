//
//  CoreDataController.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/07.
//

import Foundation
import CoreData

class CoreDataController: NSObject {
    private let viewContext = PersistenceController.shared.container.viewContext

    func fetchPreviousMessages() throws -> [ChatGPTMessage] {
        var messages: [ChatGPTMessage] = []
        
        let request = NSFetchRequest<ChatGptMessageItem>(entityName: "ChatGptMessageItem")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatGptMessageItem.timestamp, ascending: true)]
        let chatGptMessageItems = try viewContext.fetch(request)
        
        for item in chatGptMessageItems {
            if let role = item.role,
               let message = item.message {
                messages.append(ChatGPTMessage(role: role, content: message))
            }
        }
        
        return messages
    }
    
    func insertMessageIntoCoreData(role: String, message: String) throws {
        let newItem = ChatGptMessageItem(context: viewContext)
        newItem.timestamp = Date()
        newItem.role = role
        newItem.message = message
        
        try viewContext.save()
    }

}

//
//  ChatViewModel.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import Foundation
import CoreData

class ChatViewModel: ObservableObject {
    @Published var errorMessage = ""
    private let chatGPTController = ChatGPTController()
    private let viewContext = PersistenceController.shared.container.viewContext

    
    func send(_ message: String) async {
        do {
            var messages: [ChatGPTMessage] = try fetchPreviousMessages()
            
            let newMessage = ChatGPTMessage(role: .own, content: message)
            messages.append(newMessage)
            
            try insertMessageIntoCoreData(role: "user", message: message)
            let result = try await chatGPTController.send(messages)
            let sortedResult = result.choices.sorted { lhs, rhs in
                return lhs.index < rhs.index
            }
            
            if let resposeMessage = sortedResult.last?.message.content,
               let resposeRole = sortedResult.last?.message.role {
                try insertMessageIntoCoreData(role: resposeRole, message: resposeMessage)
            }
            
            if errorMessage.isEmpty == false {
                errorMessage = ""
            }
        } catch {
            errorLog(error)
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchPreviousMessages() throws -> [ChatGPTMessage] {
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
    
    private func insertMessageIntoCoreData(role: String, message: String) throws {
        let newItem = ChatGptMessageItem(context: viewContext)
        newItem.timestamp = Date()
        newItem.role = role
        newItem.message = message
        
        try viewContext.save()
    }
}

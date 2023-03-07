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
    private let coreDataController = CoreDataController()
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func send(_ message: String) async {
        do {
            var messages: [ChatGPTMessage] = try coreDataController.fetchPreviousMessages()
            
            let newMessage = ChatGPTMessage(role: .own, content: message)
            messages.append(newMessage)
            
            try coreDataController.insertMessageIntoCoreData(role: "user", message: message)
            let result = try await chatGPTController.send(messages)
            let sortedResult = result.choices.sorted { lhs, rhs in
                return lhs.index < rhs.index
            }
            
            if let resposeMessage = sortedResult.last?.message.content,
               let resposeRole = sortedResult.last?.message.role {
                try coreDataController.insertMessageIntoCoreData(role: resposeRole, message: resposeMessage)
            }
            
            if errorMessage.isEmpty == false {
                errorMessage = ""
            }
        } catch {
            errorLog(error)
            errorMessage = error.localizedDescription
        }
    }
}

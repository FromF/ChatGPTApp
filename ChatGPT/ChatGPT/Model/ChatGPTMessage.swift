//
//  ChatGPTMessage.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import Foundation

struct ChatGPTMessage: Codable {
    let role, content: String
    
    init(role: String, content: String) {
        self.role = role
        self.content = content
    }
    
    init(role: Role, content: String) {
        self.role = role.rawValue
        self.content = content
    }
}

//
//  ChatGPTRequestParameter.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import Foundation

struct ChatGPTRequestParameter: Codable {
    let model: String
    let messages: [ChatGPTMessage]
    
    init(_ messages: [ChatGPTMessage]) {
        self.messages = messages
        self.model = "gpt-3.5-turbo"
    }
}

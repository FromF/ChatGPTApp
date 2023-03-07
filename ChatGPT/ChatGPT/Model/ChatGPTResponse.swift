//
//  ChatGPTResponse.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct ChatGPTResponse: Codable {
    // MARK: - Choice
    struct Choice: Codable {
        let message: ChatGPTMessage
        let finishReason: String?
        let index: Int

        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
            case index
        }
    }

    // MARK: - Usage
    struct Usage: Codable {
        let promptTokens, completionTokens, totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }

    let id, object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

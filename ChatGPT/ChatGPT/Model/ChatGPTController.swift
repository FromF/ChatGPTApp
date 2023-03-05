//
//  ChatGPTController.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import Foundation

class ChatGPTController: NSObject {
    func send(_ messages: [ChatGPTMessage]) async throws -> ChatGPTResponse {
        guard let accessToken = UserDefaults.standard.string(forKey: userDefaultsChatGptApiKey),
        accessToken.isEmpty == false else {
            throw APIClientError.authError
        }
        
        let body = try JSONEncoder().encode(ChatGPTRequestParameter(messages))
        debugLog(String(data: body, encoding: .utf8))
        
        let response = try await post(with: chatGPTEndPoint, body: body, authKey: accessToken)
        let chatGPTResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: response)
        
        return chatGPTResponse
    }
    
    // MARK: - private method
    enum APIClientError: Error {
        case authError
        case jsonEncodeError
        case invalidURL
        case responseError
        case noData
        case badStatus(statusCode: Int)
        case serverError(_ error: Error)
    }
    
    private func post(with urlString: String, body: Data, authKey: String?) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIClientError.invalidURL
        }
        do {
            var request = URLRequest(url: url)
            // request.timeoutInterval = 600
            request.httpMethod = "POST"
            request.addValue("*/*", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            if let authKey = authKey {
                request.addValue("Bearer \(authKey)", forHTTPHeaderField: "Authorization")
            }
            request.httpBody = body

            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIClientError.responseError
            }
            debugLog(httpStatus)
            debugLog(String(data: data, encoding: .utf8))
            switch httpStatus.statusCode {
            case 200 ..< 400:
                let response = data
                if response.isEmpty {
                    throw APIClientError.noData
                }
                return response

            case 400... :
                throw APIClientError.badStatus(statusCode: httpStatus.statusCode)

            default:
                fatalError()
                break
            }
        } catch {
            throw APIClientError.serverError(error)
        }
    }
}

//
//  ChatGptMessageItem+CoreDataProperties.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//
//

import Foundation
import CoreData


extension ChatGptMessageItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatGptMessageItem> {
        return NSFetchRequest<ChatGptMessageItem>(entityName: "ChatGptMessageItem")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var message: String?
    @NSManaged public var role: String?

}

extension ChatGptMessageItem : Identifiable {
    public var isUser: Bool {
        let role = ChatGptRole(rawValue: role ?? "") ?? .own
        return role == .own
    }
}

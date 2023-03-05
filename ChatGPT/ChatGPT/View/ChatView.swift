//
//  ChatView.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChatGptMessageItem.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ChatGptMessageItem>
    
    @StateObject private var viewModel = ChatViewModel()
    @State private var message: String = ""
    @State private var isProgress: Bool = false
    
    var body: some View {
        VStack {
            ScrollViewReader { reader in
                List {
                    ForEach(0 ..< items.count, id:\.self) { index in
                        let item = items[index]
                        HStack {
                            if let timeStamp = item.timestamp {
                                VStack {
                                    Text(timeStamp, style: .date)
                                        .font(.caption)
                                    Text(timeStamp, style: .time)
                                        .font(.caption)
                                }
                            }
                            if let role = item.role {
                                Image(systemName: role == "user" ? "person" : "brain")
                            }
                            if let message = item.message {
                                Text(message)
                            }
                        }
                        .id(index)
                    }
                }
                
                ZStack {
                    TextField("メッセージを入力してください", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            Task {
                                if message.isEmpty == false {
                                    isProgress = true
                                    await viewModel.send(message)
                                    message = ""
                                    isProgress = false
                                }
                            }
                        }
                        .padding()
                    if isProgress {
                        Color.gray
                            .frame(height: 40)
                        ProgressView()
                    }
                } // ZStack
            } // ScrollViewReader
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

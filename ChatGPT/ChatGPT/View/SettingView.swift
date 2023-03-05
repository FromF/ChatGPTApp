//
//  SettingView.swift
//  ChatGPT
//
//  Created by 藤治仁 on 2023/03/05.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChatGptMessageItem.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ChatGptMessageItem>
    
    @AppStorage(userDefaultsChatGptApiKey) private var apiKey: String = ""
    @State private var isShow = false

    var body: some View {
        VStack {
            Text("Open AIのAPI Keysサイトで\"Create new secret key\"を押してキーを発行して貼り付けてください")
                .padding()
            Text("https://platform.openai.com/account/api-keys")
                .padding()
            
            HStack {
                if isShow {
                    TextField("OpenAIのAPIキーを入力してください", text: $apiKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("OpenAIのAPIキーを入力してください", text: $apiKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Button {
                    isShow.toggle()
                } label: {
                    Image(systemName: isShow ? "eye.slash.fill" : "eye.fill")
                }
            }
            .padding()

            Divider()
            
            Button {
                for item in items {
                    viewContext.delete(item)
                }
                if viewContext.hasChanges {
                    try? viewContext.save()
                }
            } label: {
                Text("履歴をクリアする")
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

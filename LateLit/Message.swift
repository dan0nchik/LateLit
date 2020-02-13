//
//  Message.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase
struct Message: View {
//    var subjects = ["ООП", "Алгебра", "Биология", "География", "Английский", "ТОИ", "История", "Литература", "Обществознание", "Русский", "Технология", "Физика", "Физ-ра", "Химия"]
//    @State private var selectedSubject = 0
//    @State private var numOfSub = 0
//    @State private var reason = ""
//    private var name = ""
//    private var surname = ""
//    let accData = Database.database().reference(withPath: "Users")
//    let mess = Database.database().reference(withPath: "late_list")

    var body: some View {
        NavigationView{
        VStack{
            Text("Отправка сообщения")
                .font(.title)
                .bold()
//            Picker(selection: $selectedSubject, label: Text("Выберите предмет")){
//                ForEach(0 ..< subjects.count){
//                    Text(self.subjects[$0]).tag($0)
//                }
//            }
//            .padding(.horizontal, 10)
//
//                Picker(selection: $numOfSub, label: Text("Номер урока")){
//                ForEach(1 ..< 8){
//                    Text("\($0)").tag($0)
//                }
//            }
//                .padding(.horizontal, 10)
//            TextField("Причина", text: $reason)
//            Button(action: {
//                let userID = Auth.auth().currentUser?.uid
//                self.accData.child("Users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
//                    let value = snapshot.value as? NSDictionary
//                    let name = value?["name"] as? String ?? ""
//                    let surname = value?["surname"] as? String ?? ""
//                })
//                print(self.name)
//                print(self.surname)
//            }){
//                Text("Отправить")
//            }
            Spacer()
            }
        }
        }
    }
struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
    }
}

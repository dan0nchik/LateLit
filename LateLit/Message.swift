//
//  Message.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth
struct Message: View {
    var subjects = ["ООП", "Алгебра", "Биология", "География", "Английский", "ТОИ", "История", "Литература", "Обществознание", "Русский", "Технология", "Физика", "Физ-ра", "Химия"]
    @State private var selectedSubject = 0
    @State private var numOfSub = 0
    @State private var reason = ""
    @State private var name = ""
    @State private var surname = ""
    let ref = Database.database().reference(withPath: "Users")
    var body: some View {
        
        NavigationView{
        VStack{
            Text("Отправка сообщения")
                .font(.title)
                .bold()
            Picker(selection: $selectedSubject, label: Text("Выберите предмет")){
                ForEach(0 ..< subjects.count){
                    Text(self.subjects[$0]).tag($0)
                }
            }
        

                Picker(selection: $numOfSub, label: Text("Номер урока")){
                ForEach(1 ..< 8){
                    Text("\($0)").tag($0)
                }
                }
            
            
            TextField("Причина", text: $reason)
            Button(action: {
                let userID = Auth.auth().currentUser?.uid
                
                
                print("ID: \(userID ?? "no")") //debug
                print(self.ref.child(userID!))
                self.ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                    if let value = snapshot.value as? NSDictionary{
                        let nameInBase = value["name"] as? String ?? "Имя не указано"
                        let surnameInBase = value["surname"] as? String ?? "Имя не указано"
                        self.name = nameInBase
                        self.surname = surnameInBase
                    }
                    
            })
                print(self.name)
                print(self.surname)
                })
            {
                Text("Отправить")
        }
    }
        }
    }
}
    
    
        
struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
    }
}

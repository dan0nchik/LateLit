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
    @State var subjectToSend = ""
    @State var numOfSubjectToSend = 0
    @State private var numOfSub = 0
    @State private var reason = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var showingAlert = false
    @State private var showingAlertAgain = true
    @Binding var showMessageView: Bool
    let ref = Database.database().reference(withPath: "Users")
    var body: some View {
        
        NavigationView{
        VStack{
            Text("Отправка сообщения")
                .font(.title)
                .bold()
            Picker(selection: $selectedSubject, label: Text("Выберите предмет")){
                ForEach(0 ..< subjects.count){ index in
                    Text(self.subjects[index]).tag(index).contrast(5)
                    
                }
            }
            
                Picker(selection: $numOfSub, label: Text("Номер урока")){
                ForEach(0 ..< 8){ index in
                    Text("\(index)").tag(index).contrast(5)
                }
                }
            
            
            TextField("Причина", text: $reason)
            Button(action: {
                self.subjectToSend = self.subjects[self.selectedSubject]
                self.numOfSubjectToSend = self.numOfSub
                let userID = Auth.auth().currentUser?.uid
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
                if(self.showingAlertAgain == true){
                self.showingAlert = true
                }
                else{
                    self.showMessageView.toggle()
                }
                })
            {
                Text("Отправить")
                Spacer()
        }
            .alert(isPresented: $showingAlert)
            {
                Alert(title: Text("Отправить?"), message: Text("Нажмите отправить еще раз и все проверьте"), dismissButton: .default(Text("OK")){
                    self.showingAlert = false
                    self.showingAlertAgain = false
                    })
            }
    }
        }
    }
}
    
    
        
struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message(showMessageView: .constant(true))
    }
}

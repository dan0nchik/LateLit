//
//  Account.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase
import UIKit
struct SignIn: View {
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @State var surname = ""
    @State var empty = true
    @State var showAlert = false
    @State var alertText: String = ""
    @State var roles = ["Ученик", "Учитель"]
    @State var _class = ["9.1", "9.2", "9.3","9.4","9.5","9.6","10.1", "10.2","10.3", "10.4", "10.5","10.6", "11.1", "11.2", "11.3", "11.4","11.5", "11.6"]
    @State var selectorInRoles = 0
    @State var studGroupSelector = 0
    @State var teachGroupSelector = 0
    @State var selectedRole = ""
    @State var code = ""
    @Binding var role_send: String
    @Binding var showThisView: Bool
    @Binding var signed_send: Bool
    let url: NSURL = URL(string: "https://danielkhromov.wixsite.com/latelit/poluchit-kod-dostupa")! as NSURL
    @ObservedObject var settings = Settings()
    let ref = Database.database().reference(withPath: "Users")
    var body: some View {
            
        ScrollView{
            VStack {
                
        Text("Ваш аккаунт")
        .font(.largeTitle)
        .bold()
        TextField("Имя", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Фамилия", text: $surname)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        SecureField("Пароль", text: $pass)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    Picker("Роль", selection: $selectorInRoles){
                        ForEach(0 ..< roles.count){
                            index in Text(self.roles[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                if(self.roles[self.selectorInRoles] == "Ученик"){
                    SecureField("Код доступа для ученика", text: $code).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    Button(action: {
                        
                        UIApplication.shared.open(self.url as URL)
                    }, label:
                    {
                        Text("Как получить код доступа?")
                    })
                    Picker("        Класс", selection: $studGroupSelector){
                        ForEach(0 ..< _class.count){
                            index in Text(self._class[index]).tag(index).contrast(5)
                        }
                    }
                }
                else{
                    SecureField("Код доступа для учителя", text: $code).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    Button(action: {
                        
                        UIApplication.shared.open(self.url as URL)
                    }, label:
                    {
                        Text("Как получить код доступа?")
                    })
                    Picker("        Класс", selection: $teachGroupSelector){
                        ForEach(0 ..< _class.count)
                        {
                            index in Text(self._class[index]).tag(index).contrast(5)
                        }
                    }
                }
                    
                    HStack{
                Button(action: {
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.pass)
                    {
                    (res, err) in
                
                    if err != nil
                    {
                        print((err!.localizedDescription))
                        self.alertText = err!.localizedDescription
                        self.showAlert = true
                    }
                    else{
                    self.signed_send = true
                    self.settings.SignedIn = self.signed_send
                        
                    self.selectedRole = self.roles[self.selectorInRoles]
                    if(self.selectedRole == "Ученик")
                    {
                        self.role_send = "user"
                        self.settings.Role = self.role_send
                    }
                    else
                    {
                        self.role_send = "admin"
                        self.settings.Role = self.role_send
                    }
                    self.showThisView.toggle()
                        }
                }
            }) {
                
                Text("Войти")
                    .fontWeight(.medium)
                    .padding()
                    .background(Color("Color"))
                    .foregroundColor(Color.white)
                    .cornerRadius(20.0)
                    .disabled(email.isEmpty || pass.isEmpty || code.isEmpty)
                    }
                    //вывод ошибки
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка 👇"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить")){self.signed_send = false})
                        })
//
                        
            Button(action: {
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    if err != nil
                    {
                        print((err!.localizedDescription))
                        self.alertText = err!.localizedDescription
                        self.showAlert = true
                        
                    }
                    else{
                        self.signed_send = true
                        self.settings.SignedIn = self.signed_send
                        
                        self.selectedRole = self.roles[self.selectorInRoles]
                        if(self.selectedRole == "Ученик"){
                            self.role_send = "user"
                            self.settings.Role = self.role_send
                        }else{
                            self.role_send = "admin"
                            self.settings.Role = self.role_send
                        }
                        
                        if self.role_send == "admin"{
                    let userID = Auth.auth().currentUser?.uid
                            self.ref.child(userID!).setValue(["email" : self.email, "name": self.name, "role": self.role_send, "surname":self.surname, "group" : self._class[self.teachGroupSelector]])
                            
                        }
                        else{
                            let userID = Auth.auth().currentUser?.uid
                            self.ref.child(userID!).setValue(["email" : self.email, "name": self.name, "role": self.role_send, "surname":self.surname, "group" : self._class[self.studGroupSelector]])
                        }
                    self.showThisView.toggle()
                    }
                }
               
            }) {
                Text("Зарегистрироваться")
                    .fontWeight(.medium)
                .padding()
                .background(Color("Color"))
                .shadow(color: Color("Color"), radius: 10)
                .foregroundColor(.white)
                .cornerRadius(20.0)
            }.disabled(email.isEmpty || pass.isEmpty || code != "0457" && self.roles[self.selectorInRoles] == "Учитель" || code != "5058" && self.roles[self.selectorInRoles] == "Ученик")
                

                        //вывод ошибки
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка 👇"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить")){self.signed_send = false})
                        })
                        
                    }
                    
                Image("account")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                 Spacer()
                
                
            }
        }
    }
        
}


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(role_send: .constant(""), showThisView: .constant(true), signed_send: .constant(false))
    }
}


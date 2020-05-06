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
    @State var _class = ["5.1","5.2","5.3","5.4","5.5","5.6","6.1","6.2","6.3","6.4","6.5","6.6","7.1","7.2","7.3","7.4","7.5","7.6","8.1","8.2","8.3","8.4","8.5","8.6", "9.1", "9.2", "9.3","9.4","9.5","9.6","10.1", "10.2","10.3", "10.4", "10.5","10.6", "11.1", "11.2", "11.3", "11.4","11.5", "11.6"]
    @State var selectorInRoles = 0
    @State var studGroupSelector = 0
    @State var teachGroupSelector = 0
    @State var selectedRole = ""
    @State var code = ""
    @Binding var role_send: String
    let url: NSURL = URL(string: "https://danielkhromov.wixsite.com/latelit/poluchit-kod-dostupa")! as NSURL
    @ObservedObject var settings = Settings()
    let ref = Database.database().reference(withPath: "Users")
    
    @EnvironmentObject var session: SessionStore
    
    func signIn(){
        session.signIn(email: email, password: pass){
            (result, error) in
            if let error = error{
                self.alertText = error.localizedDescription
                self.showAlert = true
            }
            else{
                self.email = ""
                self.pass = ""
            }
        }
    }
    
    
    func signUp(){
        session.signUp(email: email, password: pass){
            (result, error) in
            if let error = error{
                self.alertText =  error.localizedDescription
            }
            else{
                self.email = ""
                self.pass = ""
            }
        }
    }
    
    var body: some View {
        NavigationView{
        ScrollView{
            VStack {
                
                HStack{
                    Image("lit")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
                    
                    
                    Text("&").bold().font(.title).padding()
                    
                    Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
                    
                }
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
                    
                    self.signIn()
                        
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
                            Alert(title: Text("Ошибка 👇"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить")))
                        })
                                    
                
                    Button(action: {
                            
                        self.signUp()
                        let userID = Auth.auth().currentUser?.uid
                        self.selectedRole = self.roles[self.selectorInRoles]
                        if(self.selectedRole == "Ученик"){
                            self.role_send = "user"
                            self.settings.Role = self.role_send
                            self.ref.child(userID!).setValue(["email" : self.email , "name": self.name , "role": self.role_send , "surname": self.surname , "group" : self._class[self.studGroupSelector]])
                        }
                        else{
                            self.role_send = "admin"
                            self.settings.Role = self.role_send
                            self.ref.child(userID!).setValue(["email" : self.email, "name": self.name, "role": self.role_send, "surname":self.surname, "group" : self._class[self.teachGroupSelector]])
                        }
                        
                    }) {
                        
                        Text("Зарегистрироваться")
                            .fontWeight(.medium)
                            .padding()
                            .background(Color("Color"))
                            .foregroundColor(Color.white)
                            .cornerRadius(20.0)
                            .disabled(email.isEmpty || pass.isEmpty || code.isEmpty)
                            }
                            //вывод ошибки
                                .alert(isPresented: $showAlert, content: {
                                    Alert(title: Text("Ошибка 👇"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить")))
                                })
                        
                }
                 Spacer()
                
                
            }
        }
        .navigationBarTitle("Вход/регистрация")
    }
        
}
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(role_send: .constant(""))
    }
}


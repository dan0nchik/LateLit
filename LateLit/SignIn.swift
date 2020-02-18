//
//  Account.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase

struct SignIn: View {
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @State var surname = ""
    @State var empty = true
    @State var showAlert = false
    @State var alertText: String = ""
    @State var roles = ["Ученик", "Учитель"]
    @State var selector = 0
    @State var selectedRole = ""
    @State var roleToSend = ""
    @Binding var showThisView: Bool
    @ObservedObject var signed = Settings()
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
                    Picker("Роль", selection: $selector){
                        ForEach(0 ..< roles.count){
                            index in Text(self.roles[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    
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
                    self.signed.Sign = true
                    self.showThisView = false
                    self.selectedRole = self.roles[self.selector]
                    self.signed.Access = self.roleToSend
                        }
                }
            }) {
                
                Text("Войти")
                    .fontWeight(.medium)
                    .padding()
                    .background(Color("Color"))
                    .shadow(color: Color("Color"), radius: 10)
                    .foregroundColor(Color.white)
                    .cornerRadius(20.0)
                    .disabled(email.isEmpty || pass.isEmpty)
                    }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка входа"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить вход")){self.signed.Sign = false})
                        })
                
                
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
                        
                        self.selectedRole = self.roles[self.selector]
                        if(self.selectedRole == "Ученик"){
                            self.roleToSend = "user"
                        }else{
                            self.roleToSend = "admin"
                        }
                    let userID = Auth.auth().currentUser?.uid
                        self.ref.child(userID!).setValue(["email" : self.email, "name": self.name, "role": self.roleToSend, "surname":self.surname])
                    self.signed.Sign = true
                    self.signed.Access = self.roleToSend
                    self.showThisView = false
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
                .disabled(email.isEmpty || pass.isEmpty)
                }
                
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка регистрации"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить вход")){self.signed.Sign = false})
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
        SignIn(showThisView: .constant(true))
    }
}


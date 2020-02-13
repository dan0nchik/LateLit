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
    @ObservedObject var signed = Settings()
    let ref = Database.database().reference(withPath: "Users")
    var body: some View {
            
            
            VStack {
                if(self.signed.Sign == false)
                {
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
                    
        
                    HStack{
                Button(action: {
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.pass)
                    {
                    (res, err) in
                
                    if err != nil
                    {
                        print((err!.localizedDescription))
                        
                    }
                    self.signed.Sign = true
                    
                }
            }) {
                
                Text("Войти")
                    .fontWeight(.medium)
                    .padding()
                    .background(Color("Color"))
                    .shadow(color: Color("Color"), radius: 10)
                    .foregroundColor(.white)
                    .cornerRadius(20.0)
                    
                    }
                .disabled(email.isEmpty || pass.isEmpty)
                
            Button(action: {
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    if err != nil
                    {
                        print((err!.localizedDescription))
                    }
                    let userID = Auth.auth().currentUser?.uid
                    self.ref.child(userID ?? "Not set").setValue(["email" : self.email, "name": self.name, "password": self.pass, "role":"user", "surname":self.surname])
                    self.signed.Sign = true
                    
                }
               
            }, label: {
                Text("Зарегистрироваться")
                    .fontWeight(.medium)
                .padding()
                .background(Color("Color"))
                .shadow(color: Color("Color"), radius: 10)
                .foregroundColor(.white)
                .cornerRadius(20.0)
                
                })
                .disabled(email.isEmpty || pass.isEmpty)
                    }
                    
                Image("account")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                 Spacer()
                }
               
                
                else{
                    Text("Вы успешно вошли :)")
                        .font(.largeTitle)
                        .bold()
                    Image("nice")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                    Button(action: {
                        let fireBaseAuth = Auth.auth()
                        self.signed.Sign = false
                        do{
                            try fireBaseAuth.signOut()
                        }
                        catch let signOutError as NSError{
                            print(signOutError)
                        }
                    }){
                        Text("Выйти")
                    }
                    Spacer()
                }
    }
    }


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
}

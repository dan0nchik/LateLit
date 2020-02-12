//
//  Account.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase

struct Account: View {
    @State var email = ""
    @State var pass = ""
    
    var body: some View {
        VStack{
        TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Пароль", text: $pass)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
    
        HStack
            {
            Button(action: {
                Auth.auth().signIn(withEmail: self.email, password: self.pass) {
                    (res, err) in
                    if err != nil{
                        print((err!.localizedDescription))
                    }
                }
            }, label: {
                Text("Войти")
            })
            Button(action: {
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    if err != nil{
                        print((err!.localizedDescription))
                    }
                }
            }, label: {
                Text("Зарегистрироваться")
            })
        }
    }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}

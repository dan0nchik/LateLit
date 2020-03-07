//
//  ContentView.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/10/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase
import CodableFirebase
struct ContentView: View {

    @ObservedObject var settings = Settings()
    @State private var role_fromSignIn = ""
    @State private var signed_fromSignedIn = false
    @State private var showSignIn = false
    var body: some View {
        NavigationView{
            if(self.role_fromSignIn == "user" || self.settings.Role == "user")
            {
                VStack
                    {
                    
                     Spacer()
                        LateButton()
                    Spacer()
                        HurryImage()
                        }
                .navigationBarTitle("LateLit")
                .navigationBarItems(trailing: NavigationLink(destination: Account(), label: {
                    AccountImage()
                }))
            }
            if(self.role_fromSignIn == "admin" || self.settings.Role == "admin")
            {
                NavigationView{
                    List{
                        StudentList()
                    }
                }.navigationBarTitle("Сегодня")
            }
            if(self.role_fromSignIn == "" && self.settings.Role == "No"){
                Text("Войдите или зарегистрируйтесь!")
                    .font(.largeTitle)
                Image("pleaseLogIn")
                    .resizable()
                Spacer()
            }
            
        }.onAppear(perform: {
            if(self.settings.SignedIn != true){
                self.showSignIn = true
            }
            if(self.settings.SignedIn == true)
            {
                self.showSignIn = false
            }
            
        }).sheet(isPresented: $showSignIn, content: {
            SignIn(role_send: self.$role_fromSignIn, showThisView: self.$showSignIn, signed_send: self.$signed_fromSignedIn)
        })
        
    }
    }
                
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct LateButton: View {
    @State public var showMessageView = false
    var body: some View {
        Button(action:{
            self.showMessageView = true
        }) {
            Text("Я опоздаю")
                .fontWeight(.semibold)
                .foregroundColor(Color(.white))
                .padding(90)
                .background(Color("Color"))
                .mask(Circle())
                .shadow(color: Color("Color"), radius: 10)
            
        }
    .sheet(isPresented: $showMessageView, content: {
        Message(showMessageView: self.$showMessageView)
    })
    }
}

struct HurryImage: View {
    var body: some View {
        Image("hurry")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct AccountImage: View {
    var body: some View {
        Text("Аккаунт")
        .foregroundColor(Color("Color"))
            .fontWeight(.medium)
    }
}

public struct Student: Codable{
    var lesson: String
    var name: String
    var reason: String
    var surname: String
}

struct StudentList: View{
    let ref = Database.database().reference(withPath: "Users")
    let lateList = Database.database().reference(withPath: "late_list")
    let decoder = JSONDecoder()
    
    var body: some View{
        Button(action: {self.lateList.observe(.value, with: {
            (snapshot) in
            guard let value = snapshot.value else {return}
            do{
                let model = try FirebaseDecoder().decode(Student.self, from: value)
                print(model)
            } catch let error{
                print(error)
            }
            
        })}, label: {Text("Print")})
        
//        VStack{
//            HStack{
//                VStack(alignment: .leading){
//                    Text("Dan")
//                        .font(.largeTitle)
//                        .fontWeight(.black)
//                    Text("Причина")
//                        .fontWeight(.medium)
//                    Text("Урок")
//                        .fontWeight(.medium)
//                }
//            .layoutPriority(100)
//            Spacer()
//            }
//        .padding()
//        }
//
//    .cornerRadius(10)
//    .overlay(
//        RoundedRectangle(cornerRadius: 10)
//            .stroke(Color(.black), lineWidth: 1)
//        )
//            .padding([.top, .horizontal])
        
        
            
        }
    }


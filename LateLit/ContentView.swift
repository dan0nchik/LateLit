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
    @State public var role_fromSignIn = ""
    @State public var signed_fromSignedIn = false
    @State public var showSignIn = false
    let lateList = Database.database().reference(withPath: "late_list")
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
                .navigationBarTitle("LateLit")
                .navigationBarItems(trailing: Button(action: {
                    if Auth.auth().currentUser != nil {
                        do {
                              try Auth.auth().signOut()
                              self.role_fromSignIn = ""
                                self.settings.Role = "No"
                              self.signed_fromSignedIn = false
                              self.settings.SignedIn = false
                            self.showSignIn = true
                            print(self.signed_fromSignedIn)
                            }
                       catch let error as NSError
                        {
                          print (error.localizedDescription)
                         }
                                  }
                }, label: {
                Text("Выйти")
                .fontWeight(.medium)
                .foregroundColor(Color(.white))
                .padding()
                .background(Color.red)
                 .cornerRadius(20)
                }))
                        
                }
                
            }
            if(self.role_fromSignIn == "admin" || self.settings.Role == "admin")
            {
                VStack{
                    StudentList()
                    
                    .navigationBarTitle("Сегодня")
                        .navigationBarItems(trailing:
                        
                        Button(action: {
                            if Auth.auth().currentUser != nil {
                                do {
                                    try Auth.auth().signOut()
                                    self.role_fromSignIn = ""
                                    self.settings.Role = "No"
                                    self.signed_fromSignedIn = false
                                    self.settings.SignedIn = false
                                    self.showSignIn = true
                                }
                                catch let error as NSError
                                {
                                    print (error.localizedDescription)
                                }
                            }

                        }, label: {
                            Text("Выйти")
                                .fontWeight(.medium)
                                .foregroundColor(Color(.white))
                                .padding()
                                .background(Color.red)
                                .cornerRadius(20)
                            
                        })
                        
                                )
                        
                
                }
        
            }
            if(self.role_fromSignIn == "" || self.settings.Role == "No" ){
                Text("Войдите или зарегистрируйтесь!")
                    .font(.largeTitle)
                Image("pleaseLogIn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
            
        }.onAppear(perform: {
            if(self.settings.SignedIn != true || self.signed_fromSignedIn != true){
                self.showSignIn = true
            }
            if(self.settings.SignedIn == true || self.signed_fromSignedIn == true)
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



public struct Student:Identifiable
{
    public var id = UUID()
    var lesson: String
    var name: String
    var reason: String
    var surname: String
    var group: String
}

struct StudentList: View{
    let ref = Database.database().reference(withPath: "Users")
    let lateList = Database.database().reference(withPath: "late_list")
    @State var names: [Student] = []
    @State var namePicker = 0
    @State var group = ["9.1", "9.2", "9.3","9.4","9.5","9.6","10.1", "10.2","10.3", "10.4", "10.5","10.6", "11.1", "11.2", "11.3", "11.4","11.5", "11.6"]
    var name = ""
    var lesson = ""
    var surname = ""
    var group1 = ""
    var reason = ""
    var body: some View{
        VStack{
            
                
            Picker("Класс", selection: $namePicker, content: {
                ForEach(0 ..< group.count){
                    index in Text(self.group[index]).tag(index).contrast(5)
                }
            })
                
            Button(action: {
                
                self.lateList.observe(.value, with: { snapshot in
                    var tempArray: [Student] = []
                    for child in snapshot.children.allObjects as! [DataSnapshot]
                    {
                        
                        for snap in child.children.allObjects as! [DataSnapshot]
                        {
                            
                            tempArray.insert(Student(lesson: snap.childSnapshot(forPath: "lesson").value as? String ?? "Не указан",
                                                          name: snap.childSnapshot(forPath: "name").value as? String ?? "Не указано",
                                                          reason: snap.childSnapshot(forPath: "reason").value as? String ?? "Без причины",
                                                          surname: snap.childSnapshot(forPath: "surname").value as? String ?? "Не указана", group: snap.childSnapshot(forPath: "group").value as? String ?? "Без группы"), at: 0)
                            self.names = tempArray
                            
                       }
                        
                    }
                })
//                self.names.removeAll()
                

            }, label: {Text("Обновить").bold().padding()
            })
            
            
            Button(action: {self.lateList.removeValue();self.names.removeAll()
                }, label: {Text("Очистить список")})
                

                List{
                ForEach(self.names, id: \.id){ name in
                    HStack{
                        VStack(alignment: .leading){
                            HStack{
                        Text("Имя: ")
                            .bold()
                        Text(name.name)}
                            HStack{
                        Text("Фамилия: ")
                            .bold()
                        Text(name.surname)}
                            HStack{
                        Text("Группа: ")
                            .bold()
                        Text(name.group)}
                            HStack{
                        Text("Урок: ")
                            .bold()
                        Text(name.lesson)}
                            HStack{
                        Text("Причина: ")
                            .bold()
                        Text(name.reason)}
                    }
                        Spacer()
                    }
                .padding()
                    .cornerRadius(10.0)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.black), lineWidth: 1)
                .accentColor(Color("Color"))
                    )

                }

               }
            
        Spacer()
        }
}


}


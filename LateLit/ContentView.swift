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
    @State var angle = 360.0
    @State var spin = false
   
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
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(Animation.spring().delay(1).repeatForever(autoreverses: false))
        }.onAppear(perform: {
            self.spin.toggle()
        })
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
    var date: String
}

struct StudentList: View{
    let ref = Database.database().reference(withPath: "Users")
    let lateList = Database.database().reference(withPath: "late_list")
    @State var names: [Student] = []
    @State var date = ""
    @State var teachingGroup = "."
    public var cardColors: [Color] = [Color("blue"), Color("red"),Color("yellow"), Color("green"),Color("violet")]
    var body: some View{
        ZStack{
       
            
            VStack{
            if(names.capacity != 0)
            {
                
                ScrollView{
                ForEach(self.names, id: \.id)
                { name in
                    VStack{
                        HStack{
                        VStack(alignment: .leading)
                        {
                            Text(name.date).fontWeight(.ultraLight).font(.title).foregroundColor(.white)
                            Text(name.surname).font(.title).bold().foregroundColor(.white)
                            Text(name.name).font(.title).bold().foregroundColor(.white)
                            Text(name.reason).font(.body).foregroundColor(.white)
                        }
                        
                        Spacer()
                            
                    }
                    .padding(15)
                    
                    .background(Color("violet"))
                    }
                            .cornerRadius(20)
                            .padding([.top, .horizontal])
                            .shadow(color: Color("violet").opacity(0.5), radius: 5, x: 10, y: 10)
                    }
                 
                }
                
            }
            
            else{
                Image("nice")
                .resizable()
                .aspectRatio(contentMode: .fit)
                Text("Пока никто не опоздал 👏")
                .fontWeight(.medium)
                .foregroundColor(.gray)
                Spacer()
            }
                
            }
            
        
            VStack{
            Spacer()
            HStack(alignment: .bottom){
                
                Button(action: {
                    
                    self.lateList.observe(.value, with: { snapshot in //заходит в latelit
                        
                        for child in snapshot.children.allObjects as! [DataSnapshot] //заходит в дату (19_03_20 например)
                        {
                            
                            for snap in child.children.allObjects as! [DataSnapshot] //заходит в подпапку даты
                            {
                                
                                
                                if snap.childSnapshot(forPath: "group").value as? String ?? " " == self.teachingGroup // удаляет если снимок (Snap) равен группе
                                {
                                    snap.ref.removeValue()
                                }
                                
                            }
                        }
                        
                    })
                    self.names.removeAll() //очистка моего массива внутри приложения
                }, label: {
                    Image(systemName: "trash")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(Color("violet"))
                    }
               
                )   .padding(10)
                    .background(Color.white)
                    .mask(Circle())
                    .shadow(color: Color(.lightGray).opacity(0.5), radius: 5, x: 3, y: 3)
                    
                    Spacer()
                    
                    Button(action: {
                        let userID = Auth.auth().currentUser?.uid
                        self.ref.child(userID!).observeSingleEvent(of: .value, with: {snapshot in
                            if let value = snapshot.value as? NSDictionary{
                                let groupInBase = value["group"] as! String
                                self.teachingGroup = groupInBase
                            }
                        })
                        
                        self.lateList.observe(.value, with: { snapshot in
                            var tempArray: [Student] = []
                            for child in snapshot.children.allObjects as! [DataSnapshot]
                            {
                                self.date = child.key
                                for snap in child.children.allObjects as! [DataSnapshot]
                                {
                                    if snap.childSnapshot(forPath: "group").value as? String ?? " " == self.teachingGroup
                                    {
                                        
                                        tempArray.insert(Student(lesson: snap.childSnapshot(forPath: "lesson").value as! String,
                                                                 name: snap.childSnapshot(forPath: "name").value as! String,
                                                                 reason: snap.childSnapshot(forPath: "reason").value as? String ?? "Не указано",
                                                                 surname: snap.childSnapshot(forPath: "surname").value as? String ?? "Не указана", group: snap.childSnapshot(forPath: "group").value as?  String ?? "No", date: self.date), at: 0)
                                        self.names = tempArray
                                    }
                                }
                            }
                        })
                        
                    },
                           label: {
                            Image(systemName: "arrow.clockwise")
                                .padding()
                                .font(.largeTitle)
                                .foregroundColor(Color("violet"))
                                
                    }
                    )   .padding(10)
                        .background(Color.white)
                        .mask(Circle())
                        .shadow(color: Color(.lightGray).opacity(0.5), radius: 5, x: 3, y: 3)
                }.padding(15)
            }
        
    }
}


}


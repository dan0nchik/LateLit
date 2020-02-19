//
//  ContentView.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/10/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var signed = Settings()
    @State public var showSignIn = false
    var body: some View {
        NavigationView{
            if(self.signed.Access == "user"){
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
            else{
                Text("Teacher")
            }
        }.onAppear(perform: {
            print("Signed: \(self.signed.Sign)")
            if(self.signed.Sign != true){
                self.showSignIn = true
            }
            if(self.signed.Sign == true){
                self.showSignIn = false
            }
            
        }).sheet(isPresented: $showSignIn, content: {
            SignIn(showThisView: self.$showSignIn)
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

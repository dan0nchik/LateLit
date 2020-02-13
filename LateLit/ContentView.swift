//
//  ContentView.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/10/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var showMessageView = false
    var body: some View {
        NavigationView
            {
            
        VStack
            {
             Spacer()
                LateButton()
            Spacer()
                HurryImage()
                }
            
        .navigationBarTitle("LateLit")
        .navigationBarItems(trailing: NavigationLink(destination: SignIn(), label: {
            AccountImage()
        }))
        }
    }
}
                
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LateButton: View {
    @State public var show = false
    var body: some View {
        Button(action:{
            self.show = true
        }) {
            Text("Я опоздаю")
                .fontWeight(.semibold)
                .foregroundColor(Color(.white))
                .padding(90)
                .background(Color("Color"))
                .mask(Circle())
                .shadow(color: Color("Color"), radius: 10)
            
        }
    .sheet(isPresented: $show, content: {
        Message(showMessageView: self.$show)
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

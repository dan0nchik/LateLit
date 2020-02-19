//
//  Settings.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/12/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import Foundation
import Firebase
class Settings: ObservableObject {
    @Published var Sign: Bool = UserDefaults.standard.bool(forKey: "Sign")
    @Published var Access: String = UserDefaults.standard.string(forKey: "Access") ?? "No"
        {
        didSet{
            UserDefaults.standard.set(Sign, forKey: "Sign")
            UserDefaults.standard.set(Access, forKey: "Access")
        }
    }
}

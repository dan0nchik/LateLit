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
    @Published var SignedIn: Bool = UserDefaults.standard.bool(forKey: "Sign")
    @Published var Role: String = UserDefaults.standard.string(forKey: "Access") ?? "No"
        {
        didSet{
            UserDefaults.standard.set(SignedIn, forKey: "Sign")
            UserDefaults.standard.set(Role, forKey: "Access")
        }
    }
}

//
//  Settings.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/12/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import Foundation

class Settings: ObservableObject {
    @Published var Sign: Bool = UserDefaults.standard.bool(forKey: "Sign")
        {
        didSet{
            UserDefaults.standard.set(Sign, forKey: "Sign")
        }
    }
}

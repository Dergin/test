//
//  MirrorDescription.swift
//  prueba
//
//  Created by Adrian on 23/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation
class MirrorDescription {
    
    var description: String {
        get {
            let mirror = Mirror(reflecting: self)
            var string = "\n\(mirror.subjectType):\n"
            
            for (name, value) in Mirror(reflecting: self).children {
                guard let name = name else { continue }
                string += "\t\(name): \(type(of: value)) = '\(value)'\n"
            }
            return string
        }
    }
}

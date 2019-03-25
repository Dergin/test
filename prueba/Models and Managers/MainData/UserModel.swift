//
//  MainModel.swift
//  prueba
//
//  Created by Adrian on 19/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int? = -1 // database entity
    var name: String? = ""
    var birthdate: String? = ""
}

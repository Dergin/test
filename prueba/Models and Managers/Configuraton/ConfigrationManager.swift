//
//  ConfigrationManager.swift
//  prueba
//
//  Created by Adrian on 19/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation


private let _shared = ConfigurationManager()

class ConfigurationManager {
    
    // MARK: - Properties
    
    class var shared: ConfigurationManager {
        return _shared
    }
    
    fileprivate let concurrentUserQueue = DispatchQueue(
        label: "com.prueba.configuration", attributes: DispatchQueue.Attributes.concurrent)
    
    // Property to save the Server URL
    fileprivate var _serverURL: String = ""
    var serverURL: String {
        var serverURLCopy: String!
        concurrentUserQueue.sync {
            serverURLCopy = self._serverURL
        }
        return serverURLCopy
    }
    
    func setServerURL(_ url: String) {
        concurrentUserQueue.async(flags: .barrier, execute: {
            // Clean URL Encoded and correct
            self._serverURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        })
    }
    
}

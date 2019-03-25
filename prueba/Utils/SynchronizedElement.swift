//
//  asd.swift
//  prueba
//
//  Created by Adrian on 21/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation

public class SynchronizedElement<Element> {
    
    fileprivate let queue: DispatchQueue
    fileprivate var _element: Element?
    
    var element: Element? {
        get {
            var result: Element?
            queue.sync {
                result = _element
            }
            return result
        }
        set {
            queue.async(flags: .barrier) {
                self._element = newValue
            }
        }
    }
    
    init(queueLabel: String? = nil) {
        queue = DispatchQueue(label: "com.prueba.SynchronizedElement.\(queueLabel ?? "default")", attributes: .concurrent)
    }
    
}

//
//  Utils.swift
//  prueba
//
//  Created by Adrian on 19/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation
import UIKit

var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}
class Utils : NSObject {

    static func convertBoolToString(_ source: [String: Any]?) -> [String:Any]? {
        guard let source = source else {
            return nil
        }
        var destination = [String:Any]()
        let theTrue = NSNumber(value: true)
        let theFalse = NSNumber(value: false)
        for (key, value) in source {
            switch value {
            case let x as NSNumber where x === theTrue || x === theFalse:
                destination[key] = "\(x.boolValue)"
            default:
                destination[key] = value
            }
        }
        return destination
    }
    class func LocalToUTC(date:Date) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    class func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        if date.contains("."){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        /*if dt == nil{
         
         dt = dateFormatter.date(from: date)
         }*/
        //dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = "dd-MM-yyyy'"
        
        if dt == nil{
            return date
        }
        
        return dateFormatter.string(from: dt!)
    }
    
    class func simpleConstraintAnimation(view: UIView, constraint: NSLayoutConstraint, desiredConstant: CGFloat, time: Double = 0.25, completion: ((Bool) -> Void)? = nil) {
        
        constraint.constant = desiredConstant
        
        view.animateConstraintWithDuration(time, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, completion: completion)
    }
    
    class func containString(value:String,valueFind:String)->Bool{
        var indContain:Bool = false
        if value.contains(valueFind){
            indContain = true
        }
        return indContain
    }
    
    class func findDateInString(value:String,valueFind:String)->Bool{
        var indContain:Bool = false
        if value.contains(valueFind){
            indContain = true
        }
        return indContain
    }
    class func compareInt(value:Int,valueFind:Int)->Bool{
        var indContain:Bool = false
        if value==valueFind{
            indContain = true
        }
        return indContain
    }
}

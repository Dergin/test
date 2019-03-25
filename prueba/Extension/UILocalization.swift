//
//  UILocalization.swift
//  prueba
//
//  Created by Adrian on 20/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit
import Localize_Swift
import Atributika

// MARK: - UILabel localization
@IBDesignable
public extension UILabel {
    
    //    override open func awakeFromNib() {
    //        super.awakeFromNib()
    //        NotificationCenter.default.addObserver(self, selector: #selector(self.textKey), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    //    }
    
    @IBInspectable
    var textKey: String {
        get { return "" }
        set {
            if  newValue.localized() == newValue {
                print("key \(newValue) not found in strings files")
            }
            let boldStyle = Style("b").font(UIFont.boldSystemFont(ofSize: self.font.pointSize))
            let linkStyle = Style("a").font(UIFont.boldSystemFont(ofSize: self.font.pointSize)).foregroundColor(UIColor.blue)
            self.attributedText = newValue.localized().style(tags: [boldStyle, linkStyle]).attributedString
            //self.text = newValue.localized()
        }
    }
}


// MARK: - UITextField localization
@IBDesignable
public extension UITextField {
    
    @IBInspectable
    var textKey: String {
        get { return "" }
        set {
            self.text = newValue.localized()
        }
    }
    
    @IBInspectable
    var placeholderKey: String {
        get { return "" }
        set {
            self.placeholder = newValue.localized()
        }
    }
}


// MARK: - UITextView localization
@IBDesignable
public extension UITextView {
    
    @IBInspectable
    var textKey: String {
        get { return "" }
        set {
            self.text = newValue.localized()
        }
    }
}


// MARK: - UIButton localization
@IBDesignable
public extension UIButton {
    
    @IBInspectable
    var defaultTitleKey: String {
        get { return "" }
        set {
            self.setTitle(newValue.localized(), for: UIControl.State())
        }
    }
    
    @IBInspectable
    var highLightedTitleKey: String {
        get { return "" }
        set {
            self.setTitle(newValue.localized(), for: .highlighted)
        }
    }
    
    @IBInspectable
    var selectedTitleKey: String {
        get { return "" }
        set {
            self.setTitle(newValue.localized(), for: .selected)
        }
    }
    
    @IBInspectable
    var disabledTitleKey: String {
        get { return "" }
        set {
            self.setTitle(newValue.localized(), for: .disabled)
        }
    }
}


// MARK: - UIBarItem localization
@IBDesignable
public extension UIBarItem {
    
    @IBInspectable
    var titleKey: String {
        get { return "" }
        set {
            // Disable animations, it might be visible in some situations otherwise
            UIView.setAnimationsEnabled(false)
            self.title = newValue.localized()
            UIView.setAnimationsEnabled(true)
        }
    }
}


// MARK: - UINavigationItem localization
@IBDesignable
public extension UINavigationItem {
    
    @IBInspectable
    var titleKey: String {
        get { return "" }
        set {
            self.title = newValue.localized()
        }
    }
    
    @IBInspectable
    var promptKey: String {
        get { return "" }
        set {
            self.prompt = newValue.localized()
        }
    }
    
    @IBInspectable
    var backButtonKey: String {
        get { return "" }
        set {
            if let backBarButtonItem = self.backBarButtonItem {
                backBarButtonItem.title = newValue.localized()
            } else {
                self.backBarButtonItem = UIBarButtonItem(
                    title: newValue.localized(),
                    style: UIBarButtonItem.Style.plain,
                    target: nil,
                    action: nil
                )
            }
        }
    }
}


// MARK: - UISearchBar localization
@IBDesignable
public extension UISearchBar {
    
    @IBInspectable
    var textKey: String {
        get { return "" }
        set {
            self.text = newValue.localized()
        }
    }
    
    @IBInspectable
    var placeholderKey: String {
        get { return "" }
        set {
            self.placeholder = newValue.localized()
        }
    }
    
    @IBInspectable
    var promptKey: String {
        get { return "" }
        set {
            self.prompt = newValue.localized()
        }
    }
}


// MARK: - UISegmentedControl localization
@IBDesignable
public extension UISegmentedControl {
    
    /// Comma separated keys to set the corresponding segments with the localized string.
    /// Note that each key is trimed to remove leading and trailing spaces.
    /// You may as well leave a key empty not to change that specific segment title.
    @IBInspectable
    var titleKeysCSV: String {
        get { return "" }
        set {
            let keys = newValue.components(separatedBy: CharacterSet(charactersIn: ","))
            let spaceCharacterSet = CharacterSet(charactersIn: " ")
            
            for index in 0..<self.numberOfSegments {
                if index >= keys.count {
                    break
                }
                let key = keys[index].trimmingCharacters(in: spaceCharacterSet)
                if (!key.isEmpty) {
                    let title = key.localized()
                    self.setTitle(title, forSegmentAt: index)
                }
            }
        }
    }
}

//
//  AppApp.swift
//  MemeMe 1.0
//
//  Created by A Abdullah on 6/2/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
struct AppApp {
    
    static let defaultTopTextFieldText = "TOP"
    static let defaultBottomTextFieldText = "BOTTOM"
    static let fontsTableViewSegueIdentifier = "fontsTableView"
    static let fontsCellReuseIdentifier = "fontsCell"
    
    // to send msg for cancellation :D
    struct alert {
        static let alertTitle = "Discard"
        static let alertMessage = "This will cancel your meme ARE YOU SURE?"
    }
    
    // set up the text attributes
    static let memeTextAttributes : [NSAttributedString.Key:Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue):UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue):-4.0
    ]
    
  static let fontsAvailable = UIFont.familyNames
    static var currentFontIndex: Int = -1
    static var selectedFont: String = ""
    
}

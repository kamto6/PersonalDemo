//
//  UIFontExtension.swift
//  Reindeer
//
//  Created by Sword on 2/7/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

import UIKit

extension UIFont {
    class func mediumSTHeitiFontOfSize(_ size:CGFloat) -> UIFont {
        let size = size
        return UIFont (name: "STHeiti-Medium", size: size)!
    }
    func test() -> UIFont {
        print("test")
        return UIFont.systemFont(ofSize: 12)
    }
}

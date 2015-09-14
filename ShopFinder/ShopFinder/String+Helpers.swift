//
//  String+Helpers.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 14/09/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}
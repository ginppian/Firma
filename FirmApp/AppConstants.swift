//
//  AppConstants.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 12/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let USER = "user"
    static let PASSWORD = "password"
    
    struct Color {
        static let TEXT_PRIMARY = "#5D6A72"
        static let TABLE_PARENT_SELECTED = "#A7D46B"
        static let TABLE_PARENT = "#70B721"
        static let TABLE_PARENT_TEXT_SELECTED = "#000000"
        static let TABLE_PARENT_TEXT = "#FFFFFF"
        static let TABLE_CHILD = "#A7D46B"
        static let TABLE_CHILD_HEADER_TEXT = "#5D6A72"
        static let TABLE_CHILD_TEXT = "#9E9E9E"
        static let TABLE_CHILD_HEADER = "#F1F1F1"
        static let TABLE_DOC_SELECTED = "#76B703"
        static let TABLE_DOC = "#F1F1F1"
        static let TEXT_FIELD_GRAY = "#F3F3F3"
        static let INFO_ERROR_RED = "#B70303"
        static let BUTTON_GREEN = "#76B703"
        static let BUTTON_BLUE = "#74B5C1"
        static let BUTTON_GRAY = "#F3F3F3"
        static let SEPARATOR_GRAY = "#5E6871"
        static let OPERATION_INFO_BORDER = "#C4B301"
        static let TAB_BUTTON_SELECTED = "#70B721"
        static let TAB_BUTTON = "#F1F1F1"
        static let TAB_TEXT_SELECTED = "#FFFFFF"
        static let TAB_TEXT = "#323136"
        static let HEADER_TITLE = "#76B703"
        static let BADGE = "#D52082"
    }
    
    struct Font {
        
        static let OPEN_SANS_TABLE_TITLE_SUBTITLE = UIFont(name: "OpenSans", size: 11.0)
        static let OPEN_SANS_FORM_TEXT = UIFont(name: "OpenSans", size: 18.0)
        static let OPEN_SANS_WARNING = UIFont(name: "OpenSans", size: 15.0)
        static let OPEN_SANS_SPLASH_TITLE = UIFont(name: "OpenSans", size: 15.0)
        static let OPEN_SANS_BUTTON = UIFont(name: "OpenSans", size: 27.0)
        static let OPEN_SANS_POP_UP_TITLE = UIFont(name: "OpenSans", size: 23.0)
        static let OPEN_SANS_HEADER_TITLE = UIFont(name: "OpenSans", size: 28.0)
        static let OPEN_SANS_OPERATION_TITLE = UIFont(name: "OpenSans", size: 14.0)
        static let OPEN_SANS_TABLE_HEADER = UIFont(name: "OpenSans", size: 22.0)
        static let OPEN_SANS_HEADER_BUTTON = UIFont(name: "OpenSans", size: 12.0)
        static let OPEN_SANS_BUTTON_SMALL  = UIFont(name: "OpenSans", size: 9.0)
        static let OPEN_SANS_TABLE_TITLE_SUBTITLE_BOLD  = UIFont(name: "OpenSans-Bold", size: 12.0)
        static let OPEN_SANS_TABLE_BUTTON_MIDDLE  = UIFont(name: "OpenSans", size: 18.0)
        
    }
}

enum Mode {
    case add
    case edit
    case delete
    case sign
    case deny
}

//
//  AccordionTable.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 13/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation

/**
 Define the state of a cell
 
 - Collapsed: Cell collapsed
 - Expanded:  Cell expanded
 */
enum State {
    case collapsed
    case expanded
}

/**
 Enum to define the number of cell expanded at time
 
 - One:     One cell expanded at time.
 - Several: Several cells expanded at time.
 */
enum NumberOfCellExpanded {
    case one
    case several
}

/**
 *  The Parent struct of the data source.
 */
struct URL {
    
    /// State of the cell
    var state: State
    
    /// The childs of the cell
    var childs: [Document]
    
    /// The name of the URL.
    var name: String
    
    /// URL of the URL
    var url: String
}

struct Document {
    var name: String
    var dateIni: String
    var dateEnd: String
    var url: String
    var location: String
    var obs: String
    var multilateralId: Int
    
    var state: State = .collapsed
}

struct Key {
    var name: String
    var files: [File]?
}

struct File {
    var fileName: String
    var filePath: String
}

/**
 Overload for the operator != for tuples
 
 - parameter lhs: The first tuple to compare
 - parameter rhs: The seconde tuple to compare
 
 - returns: true if there are different, otherwise false
 */
func != (lhs: (Int, Int), rhs: (Int, Int)) -> Bool {
    return lhs.0 != rhs.0 && rhs.1 != lhs.1
}

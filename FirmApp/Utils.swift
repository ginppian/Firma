//
//  Utils.swift
//  SeguriData
//
//  Created by mikel.sanchez.local on 14/4/16.
//  Copyright © 2016 Babel. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func setColor(_ color: UIColor, forState: UIControlState, button: UIButton) {
        
        let colorView : UIView = UIView(frame: button.frame)
        colorView.backgroundColor = color
        
        UIGraphicsBeginImageContext(colorView.bounds.size)
        colorView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let colorImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        button.setBackgroundImage(colorImage, for: forState)
    }
    
    static func pixelToPoints(_ px: CGFloat) -> CGFloat {
        let pointsPerInch: CGFloat = 72.0 // see: http://en.wikipedia.org/wiki/Point%5Fsize#Current%5FDTP%5Fpoint%5Fsystem
        let scale: CGFloat = 1 // We dont't use [[UIScreen mainScreen] scale] as we don't want the native pixel, we want pixels for UIFont - it does the retina scaling for us
        var pixelPerInch: CGFloat // aka dpi
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            pixelPerInch = 132 * scale;
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            pixelPerInch = 163 * scale;
        } else {
            pixelPerInch = 160 * scale;
        }
        let result: CGFloat = px * pointsPerInch / pixelPerInch;
        return result;

        
    }
}


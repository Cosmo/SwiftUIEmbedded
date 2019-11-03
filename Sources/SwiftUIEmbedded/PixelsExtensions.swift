//
//  File.swift
//  
//
//  Created by Devran on 03.11.19.
//

import Pixels
import OpenSwiftUI

extension Pixels {
    func colorDepth(_ color: Color) -> ColorDepth {
        let blue = Int(color._blue * 255) << 8
        let green = Int(color._green * 255) << 16
        let red = Int(color._red * 255) << 24
        return ColorDepth(blue + green + red)
    }
}

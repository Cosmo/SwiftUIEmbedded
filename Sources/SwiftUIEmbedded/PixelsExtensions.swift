//
//  File.swift
//  
//
//  Created by Devran on 03.11.19.
//

import Pixels
import OpenSwiftUI

extension Pixels {
    func unsignedIntegerFromColor(_ color: Color) -> ColorDepth {
        let blue = UInt32(color._blue * 255) << 8
        let green = UInt32(color._green * 255) << 16
        let red = UInt32(color._red * 255) << 24
        return ColorDepth(blue + green + red)
    }
}

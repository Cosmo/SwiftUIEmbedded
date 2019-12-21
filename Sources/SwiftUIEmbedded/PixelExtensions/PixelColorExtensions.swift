import Pixels
import OpenSwiftUI

extension Pixels {
    func unsignedIntegerFromColor(_ color: Color, colorScheme: ColorScheme = .light) -> ColorDepth {
        switch color.provider {
        case let provider as _Resolved:
            return rgbValues(red: provider.linearRed, green: provider.linearGreen, blue: provider.linearBlue)
        case let provider as DisplayP3:
            return rgbValues(red: provider.red, green: provider.green, blue: provider.blue)
        case let provider as SystemColorType:
            switch colorScheme {
            case .light:
                return systemColorLight(provider.value)
            case .dark:
                return systemColorDark(provider.value)
            }
        default:
            return ColorDepth.max
        }
    }
    
    func rgbValues(red: Double, green: Double, blue: Double) -> ColorDepth {
        let blue = UInt32(blue * 255) << 8
        let green = UInt32(green * 255) << 16
        let red = UInt32(red * 255) << 24
        return ColorDepth(blue + green + red)
    }
    
    func systemColorDark(_ color: SystemColorType.SystemColor) -> ColorDepth {
        switch color {
        case .clear:
            return rgbValues(red: 0, green: 0, blue: 0)
        case .black:
            return rgbValues(red: 0, green: 0, blue: 0)
        case .white:
            return rgbValues(red: 1, green: 1, blue: 1)
        case .gray:
            return rgbValues(red: 142/255.0, green: 142/255.0, blue: 147/255.0)
        case .red:
            return rgbValues(red: 255/255.0, green: 69/255.0, blue: 58/255.0)
        case .green:
            return rgbValues(red: 49/255.0, green: 209/255.0, blue: 88/255.0)
        case .blue:
            return rgbValues(red: 10/255.0, green: 132/255.0, blue: 255/255.0)
        case .orange:
            return rgbValues(red: 255/255.0, green: 159/255.0, blue: 10/255.0)
        case .yellow:
            return rgbValues(red: 255/255.0, green: 214/255.0, blue: 10/255.0)
        case .pink:
            return rgbValues(red: 255/255.0, green: 55/255.0, blue: 95/255.0)
        case .purple:
            return rgbValues(red: 191/255.0, green: 90/255.0, blue: 242/255.0)
        case .primary:
            return rgbValues(red: 255/255.0, green: 255/255.0, blue: 255/255.0)
        case .secondary:
            return rgbValues(red: 141/255.0, green: 141/255.0, blue: 147/255.0)
        case .accentColor:
            return rgbValues(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        }
    }
    
    func systemColorLight(_ color: SystemColorType.SystemColor) -> ColorDepth {
        switch color {
        case .clear:
            return rgbValues(red: 0, green: 0, blue: 0)
        case .black:
            return rgbValues(red: 0, green: 0, blue: 0)
        case .white:
            return rgbValues(red: 1, green: 1, blue: 1)
        case .gray:
            return rgbValues(red: 138/255.0, green: 138/255.0, blue: 142/255.0)
        case .red:
            return rgbValues(red: 255/255.0, green: 59/255.0, blue: 48/255.0)
        case .green:
            return rgbValues(red: 53/255.0, green: 199/255.0, blue: 89/255.0)
        case .blue:
            return rgbValues(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        case .orange:
            return rgbValues(red: 255/255.0, green: 149/255.0, blue: 0/255.0)
        case .yellow:
            return rgbValues(red: 255/255.0, green: 204/255.0, blue: 0/255.0)
        case .pink:
            return rgbValues(red: 255/255.0, green: 45/255.0, blue: 85/255.0)
        case .purple:
            return rgbValues(red: 175/255.0, green: 82/255.0, blue: 222/255.0)
        case .primary:
            return rgbValues(red: 0/255.0, green: 0/255.0, blue: 0/255.0)
        case .secondary:
            return rgbValues(red: 138/255.0, green: 138/255.0, blue: 142/255.0)
        case .accentColor:
            return rgbValues(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        }
    }
}

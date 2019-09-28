
import UIKit

extension UIView {
    
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
        
        
    }
    
}

extension UIColor {
    convenience init?(hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scaner = Scanner(string: hexValue)
            scaner.locale = 1
            
            var hexInt32: UInt32 = 0
            if hexValue.count == 7 {
                if scaner.scanHexInt32(&hexInt32) {
                    let red = CGFloat((hexInt32 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt32 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt32 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
    
}


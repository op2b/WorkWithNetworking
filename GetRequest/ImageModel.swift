
import UIKit

struct ImageModel {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey  key: String) {
        self.key = key
        guard let data = image.pngData() else {return nil}
        self.data = data
    }
    
    
}

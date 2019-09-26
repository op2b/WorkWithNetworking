
import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url  = "https://hdqwalls.com/download/neon-genesis-evangelion-4k-p8-1125x2436.jpg"
    private let url2 = "https://hdqwalls.com/download/sekiro-shadows-die-twice-digital-fan-art-6l-1125x2436.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndecator.isHidden = true
        activityIndecator.hidesWhenStopped = false
        
    }
    
    func fetchImage() {
        
        NetWorkManager.downloadImage(url: url) { (image) in
            self.activityIndecator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchImageWithAlamofire() {
        
        request(url2).responseData { (responseData) in
            
            switch responseData.result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else {return}
                self.activityIndecator.stopAnimating()
                self.imageView.image = image
                self.activityIndecator.isHidden = true
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}

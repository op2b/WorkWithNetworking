
import UIKit

class ImageViewController: UIViewController {
    
    private let url  = "https://hdqwalls.com/download/neon-genesis-evangelion-4k-p8-1125x2436.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndecator.isHidden = true
        activityIndecator.hidesWhenStopped = false
        fetchImage()
    }
    
    func fetchImage() {
        
        activityIndecator.isHidden = false
        activityIndecator.stopAnimating()
        
        NetWorkManager.downloadImage(url: url) { (image) in
            self.activityIndecator.stopAnimating()
            self.imageView.image = image
        }
    
    }
}

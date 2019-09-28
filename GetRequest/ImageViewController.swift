
import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url  = "https://hdqwalls.com/download/neon-genesis-evangelion-4k-p8-1125x2436.jpg"
    private let url2 = "https://hdqwalls.com/download/sekiro-shadows-die-twice-digital-fan-art-6l-1125x2436.jpg"
    private let url3 = "https://wallpapercave.com/wp/wp3611707.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var complitedView: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        complitedView.isHidden = true
        progressView.isHidden = true
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
        
        
        AlamoFireNetworkRequest.downloadImage(url: url3) { (image) in
            
            self.activityIndecator.stopAnimating()
            self.imageView.image = image
            
            
        }
        
        
    }
    
    func downloadImageInProgreaa() {
        
        AlamoFireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
            
        }
        
        AlamoFireNetworkRequest.complited = { complited in
            self.complitedView.isHidden = false
            self.complitedView.text =  complited
            
        }
        AlamoFireNetworkRequest.downloadImageProgress(url: url3) { (image) in
            self.activityIndecator.stopAnimating()
            self.complitedView.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
        }
    }
}


import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
}

private let uploadImage = "https://api.imgur.com/3/image/"
private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"





class MainViewController: UICollectionViewController {
    
    private var alert: UIAlertController!
    let actions = Actions.allCases
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        dataProvider.filelocation = { (location) in
            
            //saved file for user use
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }

    }
    
    private func showALert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let hide = NSLayoutConstraint(item: alert.view!,
                                      attribute: NSLayoutConstraint.Attribute.height,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 0,
                                      constant: 170)
        alert.view.addConstraint(hide)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .darkGray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress =  { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = actions[indexPath.row].rawValue
    
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetWorkManager.getRequest(url: url)
        case .post:
            NetWorkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            NetWorkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showALert()
            dataProvider.stratDownload()
        }
    }


}

extension MainViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download Complite"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Transfer Complite", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

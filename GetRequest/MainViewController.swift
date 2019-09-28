
import UIKit
import UserNotifications
import FBSDKLoginKit
import FirebaseAuth

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case alamoFire = "Corses (Alamofire)"
    case alamoResponseData = "Response data Alamofire"
    case responseString = "Response string Alamo."
    case response = "response Alamofire"
    case downloadLargeImage = "Download Large Image"
    case postAlamofire = "POST with Alamofire"
    case putRequest = "PUT request with Alamofire"
    case uploadImagewithAlamofire = "Upload image(Alamo)"
}

private let uploadImage = "https://api.imgur.com/3/image/"
private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let chackJoke1 = "https://api.chucknorris.io/jokes/Jim0jIOySUmV7Bbz5TFyXQ"
private let chackJoke2 = "https://api.chucknorris.io/jokes/JiOvC_0ARxGlx7uWGXqSzA"
private let chackJoke3 = "https://api.chucknorris.io/jokes/JiMoo9CcS4OmmLMxBmuv7A"





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
        
        checkLoggedIn()

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
        case .alamoFire:
            performSegue(withIdentifier: "Alamofire", sender: self)
        case .alamoResponseData:
            performSegue(withIdentifier: "ResponseData", sender: self)
            AlamoFireNetworkRequest.responseData(url: chackJoke1)
        case .responseString:
            AlamoFireNetworkRequest.responseString(url: chackJoke2)
        case .response:
            AlamoFireNetworkRequest.response(url: chackJoke3)
        case .downloadLargeImage:
            performSegue(withIdentifier: "LargeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "posRequest", sender: self)
        case .putRequest:
            performSegue(withIdentifier: "PutRequest", sender: self)
        case .uploadImagewithAlamofire:
            AlamoFireNetworkRequest.uploadImage(url: uploadImage)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CourseViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch  segue.identifier {
        case "OurCourses":
            coursesVC?.fetchData()
        case "Alamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "ShowImage":
            imageVC?.fetchImage()
        case "ResponseData":
            imageVC?.fetchImageWithAlamofire()
        case "LargeImage":
            imageVC?.downloadImageInProgreaa()
        case "posRequest":
            coursesVC?.postRequest()
        case "PutRequest":
           coursesVC?.putRequest()
        default:
            break
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

//: MARK FBSDK

extension MainViewController {
    
    private func checkLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewCOntroller = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(loginViewCOntroller, animated: true)
                return
            }
            
        }
        
    }
    
}

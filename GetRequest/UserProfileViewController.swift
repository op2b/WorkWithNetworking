
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase


class UserProfileViewController: UIViewController {
    
    private var provider: String?
    private var currentUser: CurrentUser?
    
    
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.isHidden = true
        setUpViews()
        activityIndecator.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchingUserData()
    }
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32, y: view.frame.height - 172, width: view.frame.width  - 64, height: 50)
        button.backgroundColor = #colorLiteral(red: 0.4254773855, green: 0.5664381981, blue: 1, alpha: 1)
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private func setUpViews() {
        view.addSubview(logoutButton)
    }
    
}



extension UserProfileViewController {
    
    
    private func openLoginViewController() {
        
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewCOntroller = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(loginViewCOntroller, animated: true)
                return
            }
        } catch let error{
            print("Fail sign out error", error.localizedDescription)
        }
    }
    
    @objc private func signOut() {
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfp in providerData {
                
                switch userInfp.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("Iser log-out with FB")
                    openLoginViewController()
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                    print("User did logout of google")
                    openLoginViewController()
                case "password":
                    try! Auth.auth().signOut()
                    openLoginViewController()
                default:
                    print("User is signed in with \(userInfp.providerID)")
                }
            }
        }
        
    }
    
    private func fetchingUserData() {
        if Auth.auth().currentUser != nil {
            
            if let userName  = Auth.auth().currentUser?.displayName {
                activityIndecator.stopAnimating()
                userNameLabel.isHidden = false
                userNameLabel.text = userName
            } else  {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                Database.database().reference()
                    .child("users")
                    .child(uid)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let userData = snapshot.value as? [String:Any] else {return}
                        self.currentUser = CurrentUser(uid: uid, data: userData)!
                        self.activityIndecator.stopAnimating()
                        self.activityIndecator.isHidden = true
                        self.userNameLabel.isHidden = false
                        self.userNameLabel.text = self.getProviderData()
                        
                    }) { (error) in
                        print(error)
                }
                
            }
        }
    }
    
    private func getProviderData() -> String{
        
        var greetings = ""
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
               
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                default:
                    break
                }
            }
            greetings = "\(currentUser?.name ?? "Noname") Logged in with \(provider!)"
            
        }
        return greetings
    }
    
}

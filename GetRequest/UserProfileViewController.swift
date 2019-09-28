
import UIKit
import FBSDKLoginKit
import FirebaseAuth

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
    }
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.frame = CGRect(x: 32, y: view.frame.height - 172, width: view.frame.width  - 64, height: 50)
        return loginButton
    }()
    
    private func setUpViews() {
        view.addSubview(fbLoginButton)
    }

}

//MARK: FB SDK

extension UserProfileViewController: LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error)
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        openLoginViewController()
       
    }
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
    
    
}

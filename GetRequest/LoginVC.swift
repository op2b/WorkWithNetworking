
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 360, width: view.frame.width  - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    lazy var customFBLoginButton : UIButton = {
        
        let loginButton = UIButton()
        loginButton.backgroundColor = #colorLiteral(red: 0.1008148119, green: 0.406178534, blue: 1, alpha: 0.8840503961)
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 360 + 60 , width: view.frame.width - 64, height: 50)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomFBlogin), for: .touchUpInside)
        return loginButton
        
    }()
    
    lazy var customGoogleLoginButtom: UIButton = {
        
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 80 + 30, width: view.frame.width - 68, height: 40)
        loginButton.backgroundColor = .white
        loginButton.setTitle("Loggin with google", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        return loginButton
    }()
    
    lazy var googleLoginButton: GIDSignInButton = {
        
        let logintButton = GIDSignInButton()
        logintButton.frame = CGRect(x: 32, y: 360 + 80 + 55, width: view.frame.width - 64, height: 50)
        return logintButton
    }()
    
    lazy var signInWithEmail: UIButton = {
        
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 80 + 80 + 80, width: view.frame.width - 65, height: 50)
        loginButton.setTitle("Sign in with email", for: .normal)
        loginButton.addTarget(self, action: #selector(openSignInVc), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        setUpViews()
        
    }
    
    private func setUpViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(customGoogleLoginButtom)
        view.addSubview(signInWithEmail)
        
    }
    
    
}

extension LoginViewController: LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error)
            return
        }
        
        guard AccessToken.isCurrentAccessTokenActive else {return}
        signIntroFirebase()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        
        print("Did log-out Facebook")
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    @objc private func handleCustomFBlogin() {
        
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (resolt, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let result = resolt else {return}
            if result.isCancelled {return}
            else {
                self.signIntroFirebase()
            }
        }
        
    }
    
    private func signIntroFirebase() {
        
        let accessToken = AccessToken.current
        
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            
            if let error = error {
                print("Somthing went wrong:", error)
                return
            }
            
            print("Seccessfully logged in with our user")
            self.fecthFacebookFields()
        }
        
    }
    
    private func fecthFacebookFields() {
        
        GraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"]).start { (_, result, error) in
            
            if let error = error {
                print(error)
                return
            } else {
                if let userData = result as? [String:Any] {
                    self.userProfile = UserProfile(data: userData)
                    print(userData)
                    print(self.userProfile?.name ?? "nil")
                    self.savedIntoFirebase()
                }
            }
        }
    }
    
    private func savedIntoFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userdata = ["name": userProfile?.name, "email": userProfile?.email]
        
        let values = [uid: userdata]
        
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            if let error = error {
                print(error)
                return
            } else {
                print("successfull saved intro Firebase")
                self.openMainViewController()
            }
        }
        
    }
}

// MARK: Google SDK

extension LoginViewController: GIDSignInDelegate , GIDSignInUIDelegate{
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("failed to log into Google", error)
            return
        }
        print("log - in")
        
        if let userName = user.profile.name, let userEmail = user.profile.email {
            
            let userData  = ["name": userName, "email": userEmail]
            userProfile = UserProfile(data: userData)
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print("somthing went wornd with google user", error)
                return
            }
            print("Sucess logged with Google")
            self.savedIntoFirebase()
            
        }
    }
    
    @objc private func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func openSignInVc() {
        
    }
    
}

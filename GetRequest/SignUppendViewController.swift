
import UIKit
import Firebase

class SignUppendViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var activityIndecator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(continiumButton)
        
        userNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        confirmPassword.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        activityIndecator = UIActivityIndicatorView(style: .gray)
        activityIndecator.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        activityIndecator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndecator.center = continiumButton.center
        
        view.addSubview(activityIndecator)
        
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
 
    
    lazy var continiumButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continiumButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continiumButton.frame.height / 2)
        activityIndecator.center = continiumButton.center
    }
    
    @IBAction func goBSCK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setContinueButton(enabled:Bool) {
        
        if enabled {
            continiumButton.alpha = 1.0
            continiumButton.isEnabled = true
        } else {
            continiumButton.alpha = 0.5
            continiumButton.isEnabled = false
        }
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let userName = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPassword.text
            else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty) && !(userName.isEmpty) && confirmPassword == password
        
        setContinueButton(enabled: formFilled)
    }
    
    @objc private func handleSignUp() {
        
        setContinueButton(enabled: false)
        continiumButton.setTitle("", for: .normal)
        activityIndecator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let userName = userNameTextField.text
            else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user , error) in
            
            if let error = error {
                print(error.localizedDescription)
                
                self.setContinueButton(enabled: true)
                self.continiumButton.setTitle("Continue", for: .normal)
                self.activityIndecator.stopAnimating()
                
                return
            }
            
            print("Successfully logged into Firebase with User Email")
            
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                
                changeRequest.displayName = userName
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                    print(error.localizedDescription)
                        
                        self.setContinueButton(enabled: true)
                        self.continiumButton.setTitle("Continue", for: .normal)
                        self.activityIndecator.stopAnimating()
                    }
                    
                    print("User display name changed")
                    self.presentedViewController?.presentedViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                })
            }
        }
        
    }
    

}




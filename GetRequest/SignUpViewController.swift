

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndecator : UIActivityIndicatorView!
    
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
        button.addTarget(self, action: #selector(hangSignIn), for: .touchUpInside)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        
        view.addSubview(continiumButton)
        setContinumButton(enable: false)
        
        activityIndecator = UIActivityIndicatorView(style: .gray)
        activityIndecator.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        activityIndecator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndecator.center = continiumButton.center
        
        view.addSubview(activityIndecator)
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setContinumButton(enable: Bool) {
        
        if enable {
            continiumButton.alpha = 1
            continiumButton.isEnabled = true
        } else {
            continiumButton.alpha = 0.5
            continiumButton.isEnabled = false
        }
        
    }
    

    @objc func hangSignIn() {
        
        setContinumButton(enable: false)
        continiumButton.setTitle("", for: .normal)
        activityIndecator.startAnimating()
        
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        
        let formField = !(email.isEmpty) && !(password.isEmpty)
        setContinumButton(enable: formField)
        
    }
    @objc func keyBoardWillAppear(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continiumButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyBoardFrame.height - 16.0 - continiumButton.frame.height/2)
        
        activityIndecator.center = continiumButton.center
        
    }
    
    
 
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

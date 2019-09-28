
import UIKit
import FBSDKCoreKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bgSessionComplitionHandler: (() -> ())?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appID = Settings.appID
        
        if url.scheme != nil && (url.scheme?.hasPrefix("fb\(String(describing: appID))"))! && url.host == "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        
        return false
    }
    
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        bgSessionComplitionHandler = completionHandler
    }

}


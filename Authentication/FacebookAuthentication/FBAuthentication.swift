
import Foundation
import FBSDKLoginKit

class FBSignInHelper {
    
    public static var shared = FBSignInHelper()
   
    
    func signIn(user: @escaping (_ result: Any?) -> Void) {
        
        
        //if the user is already logged in
        
        if let token = AccessToken.current,
           !token.isExpired {
            getFBUserData(completion: { result in
                user(result)
            })
        }
        //Get Currunt RootView
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile ], viewController: rootViewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData(completion: { result in
                    user(result)
                })
            }
        }
    }
    
    private func getFBUserData(completion: @escaping (_ result: Any?) -> Void){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me",
                         parameters: ["fields": "id, name, picture.type(large), email"]).start(completion: { connection, result, error  in
                if error != nil {
                    completion(nil)
                }else {
                    completion(result)
                }
            })
        }
    }
    
}

/*
 
 lass AppDelegate: NSObject, UIApplicationDelegate {
 func application(_ application: UIApplication,
 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
 ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
 }
 
 func application(_ app: UIApplication,
 open url: URL,
 options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
 return ApplicationDelegate.shared.application(app, open: url, options: options)
 }
 }
 
 
 */


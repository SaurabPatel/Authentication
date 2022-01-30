
import Foundation
import FBSDKLoginKit

class FBSignInHelper {
    
    public static var shared = FBSignInHelper()
    
    func signIn() {
        
        
        //if the user is already logged in
        if let token = AccessToken.current,
                !token.isExpired {
            getFBUserData()
            return
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
                        self.getFBUserData()
                    }
                }
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me",
                                parameters: ["fields": "id, name, picture.type(large), email"]).start(completion: { connection, result, error  in
                print("error", error)
                print("connection", connection)
                print("error", error)
                  
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


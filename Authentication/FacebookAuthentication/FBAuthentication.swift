
import Foundation
import FBSDKLoginKit

struct FBLoginUser {
    var id: String?
    var first_name: String?
    var last_name: String?
    var middle_name: String?
    var name: String?
    var name_format: String?
    var picture: String?
    var short_name: String?
    var email: String?
}

class FBSignInHelper {
    
    public static var shared = FBSignInHelper()
    
    
    func signIn(user: @escaping (_ result: Any?) -> Void) {
        
        
        //if the user is already logged in
        
        if let token = AccessToken.current,
           !token.isExpired {
            getFBUserData(completion: { result in
                user(result)
            })
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
                    completion(self.getFBLoginUser(result))
                }
            })
        }
    }
    
    private func getFBLoginUser(_ user: Any) -> FBLoginUser? {
        if let json = user as? Dictionary<String, Any> {
            if let email = json["email"] as? String {
                print("\(email)")
            }
            if let firstName = json["first_name"] as? String {
                print("\(firstName)")
            }
            if let lastName = json["last_name"] as? String {
                print("\(lastName)")
            }
            if let id = json["id"] as? String {
                print("\(id)")
            }
            
            let id = json["id"] as? String
            let lastName = json["last_name"] as? String
            let firstName = json["first_name"] as? String
            let middleName = json["middle_name"] as? String
            let name = json["name"] as? String
            let name_format = json["name_format"] as? String
            let short_name = json["short_name"] as? String
            let email = json["email"] as? String
            var pictureURL: String? = nil
            if let picture = json["picture"] as? [String: Any], let data = picture["data"] as? [String: Any], let url = data["url"] as? String {
                pictureURL = url
            }
            let fbdUser = FBLoginUser(id: id, first_name: firstName, last_name: lastName, middle_name: middleName, name: name, name_format: name_format, picture: pictureURL, short_name: short_name, email: email)
            return fbdUser
        }else {
            return nil
        }
        
        
    }
    
}

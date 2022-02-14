
import Foundation
import GoogleSignIn

struct GoogleSignInUser {
    var userID: String?
    var email: String?
    var givenName: String?
    var familyName: String?
    var name: String?
    var imageURL: String?
}

fileprivate var signInConfig = GIDConfiguration.init(clientID: "")

class GoogleSignInHelper {
    
    public static var shared = GoogleSignInHelper()
    
    func signIn(completion: @escaping (_ user: GoogleSignInUser?) -> Void) {
        if !hasSignIn() {
            
            //Get Currunt RootView
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: rootViewController) { user, error in
                guard error == nil else { return }
                if let user = GIDSignIn.sharedInstance.currentUser {
                    completion(self.getGoogleSignInUser(user))
                }
            }
        }else {
            if let user = GIDSignIn.sharedInstance.currentUser {
                completion(getGoogleSignInUser(user))
            }
            
        }
    }
    
    func hasSignIn() -> Bool {
        return GIDSignIn.sharedInstance.hasPreviousSignIn()
    }
    
    func getGoogleSignInUser(_ user: GIDGoogleUser) -> GoogleSignInUser {
        let userID = user.userID
        let email = user.profile?.email
        let givenName = user.profile?.givenName
        let familyName = user.profile?.familyName
        let name = user.profile?.name
        var profilePicture: String?
        if user.profile?.hasImage != nil {
            let url = user.profile?.imageURL(withDimension: 300)
            profilePicture = url?.absoluteString
        }
        
        let googleUser = GoogleSignInUser(userID: userID, email: email, givenName: givenName, familyName: familyName, name: name, imageURL: profilePicture)
        return googleUser
        
       
    }
}


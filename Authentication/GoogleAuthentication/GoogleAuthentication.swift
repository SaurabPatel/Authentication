
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

fileprivate var signInConfig = GIDConfiguration.init(clientID: "439233323888-399evq08k3q7necoje3okmnm705lta8b.apps.googleusercontent.com")

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

/*
 
 Button("Sign in with google", action: {
     GoogleSignInHelper.shared.signIn(completion: { response in
         if response != nil {
            // print()
         }
     })
 }).padding()
 
 Button("Sign in with facebook", action: {
     FBSignInHelper.shared.signIn()
 }).padding()
 
 
 
 Button("Sign in With Apple", action: {
     AppleSignInCoordinator().didTapButton1()
 }).padding()
 
 Button("Camera Permission", action: {
     CameraPermssion.shared.request(result: { isGranted in
         if !isGranted {
             CameraPermssion.shared.onDeniedOrRestricted()
         }
     })
     
     
 }).padding()
 
 Button("Gallery Permission", action: {
     GalleryPermssion.shared.request(result: { isGranted in
         if !isGranted {
             GalleryPermssion.shared.onDeniedOrRestricted()
         }
     })
 })
 
 */


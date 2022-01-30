
import Foundation
import GoogleSignIn

class GoogleSignInHelper {
    
    public static var shared = GoogleSignInHelper()
    
    func signIn(completion: @escaping (_ user: GIDGoogleUser?) -> Void) {
        if !hasSignIn() {
            
            //Get Currunt RootView
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: rootViewController) { user, error in
                guard error == nil else { return }
                if user != nil {
                    completion(GIDSignIn.sharedInstance.currentUser)
                }
            }
        }else {
            completion(GIDSignIn.sharedInstance.currentUser)
        }
    }
    
    func hasSignIn() -> Bool {
        return GIDSignIn.sharedInstance.hasPreviousSignIn()
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


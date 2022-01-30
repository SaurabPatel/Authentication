

import Foundation
import AuthenticationServices
import SwiftUI

struct SignUpWithAppleView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        //Creating the apple sign in button
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
        authorizationButtonStyle: .black)
        button.cornerRadius = 10
        
        //Adding the tap action on the apple sign in button
        button.addTarget(context.coordinator,action: #selector(AppleSignInCoordinator.didTapButton),for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    
   /* func makeCoordinator() -> AppleSignInCoordinator {
        return AppleSignInCoordinator(self)
    }
    
    func makeUIView(context: Context) -> some  ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
          authorizationButtonStyle: .black)
          button.cornerRadius = 10
          
          //Adding the tap action on the apple sign in button
        //  button.addTarget(context.coordinator,action: #selector(AppleSignUpCoordinator.didTapButton),for: .touchUpInside)
          
          return button
    }
    
    func updateUIView(_ uiView:  ASAuthorizationAppleIDButton, context: Context) {
        
    }*/
    
   
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    
    var parent: SignUpWithAppleView?
    
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
           return (vc?.view.window!)!
        
    }
    
    //If authorization is successfull then this method will get triggered
    func authorizationController(controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization)
    {
       guard let credentials = authorization.credential as?ASAuthorizationAppleIDCredential else
       {
          print("credentials not found….")
          return
       }
       
       //Storing the credential in user default for demo purpose only    ideally we should have store the credential in Keychain
    let defaults = UserDefaults.standard
       defaults.set(credentials.user, forKey: "userId")
       //parent?.name = "\(credentials.fullName?.givenName ?? "")"
    }
    //If authorization faced any issue then this method will get triggered
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       //If there is any error will get it here
    }
    
    @objc func didTapButton() {
    //Create an object of the ASAuthorizationAppleIDProvider
       let appleIDProvider = ASAuthorizationAppleIDProvider()
       //Create a request
       let request = appleIDProvider.createRequest()
       //Define the scope of the request
       request.requestedScopes = [.fullName, .email]
       //Make the request
       let authorizationController =
    ASAuthorizationController(authorizationRequests: [request])
    authorizationController.presentationContextProvider = self
       authorizationController.delegate = self
       authorizationController.performRequests()
    }
    
    func didTapButton1() {
    //Create an object of the ASAuthorizationAppleIDProvider
       let appleIDProvider = ASAuthorizationAppleIDProvider()
       //Create a request
       let request = appleIDProvider.createRequest()
       //Define the scope of the request
       request.requestedScopes = [.fullName, .email]
       //Make the request
       let authorizationController =
    ASAuthorizationController(authorizationRequests: [request])
    authorizationController.presentationContextProvider = self
       authorizationController.delegate = self
       authorizationController.performRequests()
    }


    
    
}


/*
 
 func signIn() {
     let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
 }
 
 func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
     <#code#>
 }
 
 
 */

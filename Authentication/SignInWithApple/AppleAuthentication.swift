import AuthenticationServices
import Foundation
import SwiftUI

struct AppleSignInUser {
    var userIdentifier: String?
    var fullName: FullName?
    var email: String?
}

struct FullName {
    var middleName: String?
    var familyName: String?
    var givenName: String?
    var nickName: String?
}

@available(iOS 13.0, *)
open class AppleSignInManager: NSObject {
    static let shared: AppleSignInManager = .init()
    var result: ((_ user: AppleSignInUser?) -> Void)?

    func login() {
        handleAuthorizationAppleIDButtonPress()
    }

    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        result?(nil)
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        result?(getAppleSignInUser(appleIDCredential))
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
    
    private func getAppleSignInUser(_ credential: ASAuthorizationAppleIDCredential) -> AppleSignInUser {
        let fullName = FullName(middleName: credential.fullName?.middleName, familyName: credential.fullName?.familyName, givenName: credential.fullName?.givenName, nickName: credential.fullName?.nickname)
        let appleSignInUser = AppleSignInUser(userIdentifier: credential.user, fullName: fullName, email: credential.email)
        return appleSignInUser
    }
}

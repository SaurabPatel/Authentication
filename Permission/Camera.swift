
import Foundation
import Photos
import UIKit

class CameraPermssion {
    
    public static var shared = CameraPermssion()
    
    func request(result: @escaping (_ isGranted: Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [self] response in
            if response {
                //access granted
                result(true)
            } else {
                //access Denied
                result(false)
            }
        }
    }
    
    public func onDeniedOrRestricted() {
        let alert = UIAlertController(
            title: "We were unable to load your camera. Sorry!",
            message: "You can enable access in Privacy Settings",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        DispatchQueue.main.async {
            //Get Currunt RootView
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
}

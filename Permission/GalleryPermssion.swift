
import Foundation
import Photos
import UIKit

class GalleryPermssion {
    
    public static var shared = GalleryPermssion()
    
    func request(result: @escaping (_ isGranted: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ status in
             switch status {
             case .notDetermined:
                result(false)
             case .denied, .restricted:
                result(false)
             case .authorized:
                 result(true)
             case .limited:
                 result(true)
             @unknown default:
                fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
             }
          })
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

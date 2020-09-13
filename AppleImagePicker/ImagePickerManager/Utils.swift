import UIKit

// MARK:- Struct
// MARK: - Constant Message for Permission

struct Alert {
    
    static func photoPermission() -> DGAlert {
        let kPermissionMessage = "We need to have access to your photos to select a Photo.\nPlease go to the App Settings and allow Photos."
        return DGAlert(title: "Change your Settings", message: kPermissionMessage)
    }
    
    static func cameraPermission() -> DGAlert {
        let kPermissionMessage = "We need to have access to your camera to take a New Photo.\nPlease go to the App Settings and allow Camera."
        return DGAlert(title: "Change your Settings", message: kPermissionMessage)
    }
    
}


// MARK: - Extensions
// MARK: - Get Top ViewController

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

// MARK: - Present Image Picker On Top Controller

extension UIImagePickerController {
    func present() {
        if let topController = UIApplication.getTopViewController(){
            DispatchQueue.main.async {
                topController.present(self, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Present Alert On Top Controller

extension UIAlertController {
    func present() {
        if let topController = UIApplication.getTopViewController(){
            DispatchQueue.main.async {
                topController.present(self, animated: true, completion: nil)
            }
        }
    }
}

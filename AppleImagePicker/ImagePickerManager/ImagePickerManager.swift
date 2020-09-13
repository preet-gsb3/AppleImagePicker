/*
 
 MARK: - Quick Note
 Mark: - Add Following into your Info.plist
 
 MARK: - *********************************
 
 <key>NSPhotoLibraryUsageDescription</key>
 <string>This app requires access to the photo library to upload photo.</string>
 <key>NSCameraUsageDescription</key>
 <string>This app requires access to the camera to upload photo.</string>
 
 MARK: - *********************************
 
 */


import Foundation
import UIKit
import Photos

class ImagePickerManager: NSObject {
    static let shared = ImagePickerManager()
    private override init() {}
    
    private var imagePicker = UIImagePickerController()
    typealias CompletionHandler = (UIImage, Data)->Void
    var completion: CompletionHandler? = nil

    enum PickerType: String {
        case image = "public.image"
    }
    
    func callPickerOptions(_ sender: UIView, completion: CompletionHandler?) {
        sender.endEditing(true)
        
        self.imagePicker.delegate = self
        self.completion = completion
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.checkCameraAuth() {
                self.openCamera(.image)
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.checkPhotoAuth() {
                self.openGallary(.image)
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        alert.present()
    
    }
    
    private func openCamera(_ type: PickerType) {
        DispatchQueue.main.async {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.mediaTypes = [type.rawValue]
                self.imagePicker.allowsEditing = true
                self.imagePicker.present()
            }
            else {
                let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                alert.present()
            }
        }
    }
    
    private func openGallary(_ type: PickerType) {
        DispatchQueue.main.async {
            self.imagePicker.sourceType = type == .image ? UIImagePickerController.SourceType.photoLibrary : UIImagePickerController.SourceType.savedPhotosAlbum
            self.imagePicker.mediaTypes = [type.rawValue]
            self.imagePicker.allowsEditing = true
            self.imagePicker.present()
        }
    }
    
    //MARK:- Check the status of authorization for PHPhotoLibrary
    private func checkPhotoAuth(_ completion: @escaping ()->Void) {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .authorized:
                completion()
            case .restricted, .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    AlertManager.shared.show(Alert.photoPermission(), buttonsArray: ["Close","Go To Settings"], completionBlock: { (index : Int) in
                        
                        switch index{
                        case 0:
                            break
                        case 1:
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            break
                        default:
                            //print("-:Something Wrong")
                            break
                        }
                        
                    })
                })
            default:
                break
            }
        }
    }
    
    //MARK:- Check the status of authorization for Camera
    func checkCameraAuth(_ completion: @escaping ()->Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
            if (videoGranted) {
                completion()
            } else {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    AlertManager.shared.show(Alert.cameraPermission(), buttonsArray: ["Close","Go To Settings"], completionBlock: { (index : Int) in
                        
                        switch index{
                        case 0:
                            break
                        case 1:
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            break
                        default:
                            //print("-:Something Wrong")
                            break
                        }
                        
                    })
                    
                })
                
            }
        })
    }
    
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- ImagePicker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[.mediaType] as? String else { return }
        
        if mediaType == PickerType.image.rawValue {
            if let pickedImage = info[.editedImage] as? UIImage {
                let data = pickedImage.jpegData(compressionQuality: 1.0)
                if completion != nil {
                    completion!(pickedImage, data!)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

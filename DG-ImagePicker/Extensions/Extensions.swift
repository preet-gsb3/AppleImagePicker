
import UIKit
import Photos

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            }
            self.image = image
        }
    }
}

//MARK:- UIFont

extension UIFont {
    
    class func applyRegular(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "Helvetica" , size: fontSize * 1.0)!
        } else {
            return UIFont.init(name: "Helvetica" , size: fontSize)!
        }
    }
    
    class func applyBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "Helvetica-Bold" , size: fontSize * 1.0)!
        }else {
            return UIFont.init(name: "Helvetica-Bold" , size: fontSize)!
        }
    }
    
    class func applyMedium(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "HelveticaNeue-Medium" , size: fontSize * 1.0)!
        }else {
            return UIFont.init(name: "HelveticaNeue-Medium" , size: fontSize)!
        }
    }
    
    class func applyArialBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "ArialRoundedMTBold" , size: fontSize * 1.0)!
        }else {
            return UIFont.init(name: "ArialRoundedMTBold" , size: fontSize)!
        }
    }
    
    class func applyArialRegular(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "ArialMT" , size: fontSize * 1.0)!
        }else {
            return UIFont.init(name: "ArialMT" , size: fontSize)!
        }
    }
    
}

// MARK:- Navigation Controller
extension UINavigationController{
    func customize(isTransparent: Bool = false, isPicker: Bool? = false){
        
        let navigationFont               = UIFont.applyRegular(fontSize: 15.5)
        let navigationBarAppearace       = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = .lightGray
        
        if isTransparent {
            navigationBarAppearace.backgroundColor = .clear
        }
        
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font:navigationFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layer.masksToBounds = false
        
        if isTransparent {
            self.navigationBar.isTranslucent       = true
        }else{
            self.navigationBar.isTranslucent       = false
            self.navigationBar.isOpaque = true
        }
        
    }
    
}

class BarButton : NSObject {
    var title : String?
    var image : UIImage?
    var color : UIColor?
    var tintColor : UIColor?
    var isLeftMenu : Bool?
    var fontSize : CGFloat?
    
    init(title : String? = nil, image: UIImage? = nil , color : UIColor? = nil, fontSize: CGFloat? = nil , tintColor : UIColor? = nil, isLeftMenu : Bool? = nil) {
        self.title = title == nil ? "" : title
        self.image = image == nil ? UIImage() : image
        self.color = color == nil ? .blue : color
        self.tintColor = tintColor == nil ? .blue : tintColor
        self.isLeftMenu = isLeftMenu == nil ? true : isLeftMenu
        self.fontSize = fontSize == nil ? 13.0 : fontSize
    }
    
}

//MARK:- UIViewController
extension UIViewController {
    
    func toolBarDoneButtonClicked() {
        self.view.endEditing(true)
    }
    
    // add BarButton
    func addBarButtons(btnLeft : BarButton? , btnRight : BarButton? , title : String? , isShowLogo : Bool = false) -> [UIButton] {
        
        var arrButtons : [UIButton] = [UIButton(),UIButton()]
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)]
        
        // setup for left button
        if btnLeft != nil {
            
            let leftButton = UIButton(type: .custom)
            leftButton.contentHorizontalAlignment = .left
            
            if btnLeft?.title == String() {
                
                if btnLeft?.image != UIImage() {
                    leftButton.setImage(btnLeft?.image, for: .normal)
                    leftButton.imageView?.contentMode = .scaleAspectFit
                }
                
            }else
            {
                leftButton.setTitleColor(btnLeft?.color, for: .normal)
                leftButton.setTitleColor(.white, for: .disabled)
                leftButton.setTitle(btnLeft?.title, for: .normal)
                let btnFont = UIFont.applyRegular(fontSize: (btnLeft?.fontSize)!, isAspectRasio: false)
                leftButton.titleLabel?.font = btnFont
            }
            
            leftButton.adjustsImageWhenHighlighted = false
            leftButton.tintColor = btnLeft?.tintColor
            leftButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(44), height: 44)
            
            if (btnLeft?.isLeftMenu)! {
                // Add Action Here
            }else{
                let leftBtnSelector: Selector = NSSelectorFromString("leftButtonClicked")
                if responds(to: leftBtnSelector) {
                    leftButton.addTarget(self, action: leftBtnSelector, for: .touchUpInside)
                }
            }
            
            let leftItem = UIBarButtonItem(customView: leftButton)
            navigationItem.leftBarButtonItems = [leftItem]
            arrButtons.removeFirst()
            arrButtons.insert(leftButton, at:0)
            
        }
        
        // setup for right button
        
        if btnRight != nil {
            let rightButton = UIButton(type: .custom)
            rightButton.contentHorizontalAlignment = .right
            rightButton.tintColor = UIColor.darkGray
            
            if btnRight?.title == String() {
                if btnRight?.image != UIImage() {
                    rightButton.setImage(btnRight?.image, for: .normal)
                    rightButton.imageView?.contentMode = .scaleAspectFit
                }
            }else
            {
                rightButton.setTitleColor(btnRight?.color, for: .normal)
                rightButton.setTitleColor(.white, for: .disabled)
                if btnRight?.image != UIImage() {
                    rightButton.setImage(btnRight?.image, for: .normal)
                    rightButton.imageView?.contentMode = .scaleAspectFit
                    rightButton.setTitle(" \(btnRight?.title ?? "")", for: .normal)
                }else{
                    rightButton.setTitle(btnRight?.title, for: .normal)
                }
                
                let btnFont = UIFont.applyRegular(fontSize: (btnRight?.fontSize)!, isAspectRasio: false)
                rightButton.titleLabel?.font = btnFont
            }
            
            rightButton.adjustsImageWhenHighlighted = false
            rightButton.tintColor = btnRight?.tintColor
            rightButton.frame = CGRect(x: 0, y: CGFloat(0), width: CGFloat(44), height: 44)
            let rightBtnSelector: Selector = NSSelectorFromString("rightButtonClicked")
            if responds(to: rightBtnSelector) {
                rightButton.addTarget(self, action: rightBtnSelector, for: .touchUpInside)
            }
            let rightItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItems = [rightItem]
            arrButtons.removeLast()
            arrButtons.append(rightButton)
            
        }
        
        if (title!.isEmpty) {
            if isShowLogo {
                navigationTitleImage(sender: self)
            }else{
                self.navigationItem.title = ""
            }
        }else{
            self.navigationItem.title = title
        }
        
        return arrButtons
    }
    
    func navigationTitleImage(sender: UIViewController){
        let logo = UIImage(named: "location_pin")
        let imageView = UIImageView(image:logo)
        sender.navigationItem.titleView = imageView
    }
    
}

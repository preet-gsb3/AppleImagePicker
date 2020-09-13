# AppleImagePicker
AppleImagePicker is an easy to use for select image options (like gallery & camera) with actionsheet using default UIImagePicker. Just need to plug and play quickly into your project. Please follow below guideline .... Cheers!!!

[![Language: Swift 5](https://img.shields.io/badge/language-swift%205-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/preet-gsb3/AppleImagePicker/blob/master/LICENSE)

## Guideline

Just Drag and drop folder "ImagePickerManager" into your project and add following lines of code in your controller.

```
ImagePickerManager.shared.callPickerOptions(sender) { (image, imageData) in
    // Handle your action here
    // e.g. self.imgView.image = image
}

```
## Author
Gurpreet Singh.

## License
DG-ImagePicker is released under the MIT license.  
See [LICENSE](LICENSE) for details.



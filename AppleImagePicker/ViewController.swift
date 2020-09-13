//
//  ViewController.swift
//  ViewController
//
//  Created by Gurpreet Singh on 11/02/20.
//  Copyright © 2020 Gurpreet. All rights reserved.
//

import UIKit
import Photos
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnTapOnGallery(_ sender: UIButton) {
        ImagePickerManager.shared.callPickerOptions(sender) { (image, imageData) in
            self.imgView.image = image
        }
    }
    
}

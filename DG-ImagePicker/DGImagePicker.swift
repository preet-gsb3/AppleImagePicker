//
//  DGImagePicker.swift
//  DG-ImagePicker
//
//  Created by Gurpreet Singh on 11/02/20.
//  Copyright © 2020 Gurpreet. All rights reserved.
//

import UIKit
import Photos
import AVFoundation


class DGImagePicker: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
    
    private var allPhotos : PHFetchResult<PHAsset>? = nil
    private var arrSelectedItems: [UIImage?] = []
    
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var defaultImageSelectionCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = addBarButtons(btnLeft: BarButton(title: "Cancel"), btnRight: BarButton(title: "Select"), title: "")
        
        // Load Photos
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                DispatchQueue.main.async {
                    self.colView.reloadData()
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        self.setupForCameraSession()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    private func setupForCameraSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
    }
    
    private func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.view.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.view.bounds
        }
    }
    
    @objc func leftButtonClicked() {
        
    }

    @objc func rightButtonClicked() {
        
    }
    
    

}

extension DGImagePicker: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPhotos", for: indexPath) as! CellPhotos
        
        // Display Photo
        let asset = allPhotos?.object(at: indexPath.row)
        cell.imageView.fetchImage(asset: asset!, contentMode: .aspectFill, targetSize: cell.imageView.frame.size)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.colView.cellForItem(at: indexPath) as! CellPhotos
        
        if arrSelectedItems.contains(cell.imageView.image) {
            cell.imageView.layer.borderColor = UIColor.clear.cgColor
            cell.imageView.layer.borderWidth = 0
            if let index = arrSelectedItems.index(where: {$0 == cell.imageView.image}) {
                arrSelectedItems.remove(at: index)
            }
        }else{
            guard arrSelectedItems.count < defaultImageSelectionCount else { return }
            cell.imageView.layer.borderColor = UIColor.blue.cgColor
            cell.imageView.layer.borderWidth = 2
            arrSelectedItems.append(cell.imageView.image)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.width/4)
    }
    
}





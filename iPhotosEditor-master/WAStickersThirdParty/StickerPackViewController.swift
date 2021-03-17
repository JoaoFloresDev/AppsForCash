//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit
import GoogleMobileAds

class StickerPackViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate, GADInterstitialDelegate {
    
    var imagePicker: UIImagePickerController!
    var interstitial: GADInterstitial!
    
    @IBOutlet private weak var stickerPackPublisherLabel: UILabel!
    @IBOutlet private weak var stickersCollectionView: UICollectionView!
    @IBOutlet private weak var bottomCollectionViewConstraint: NSLayoutConstraint!
    
    private let topMarginInset: CGFloat = 5.0
    private let marginInset: CGFloat = 22
    private let interimMargin: CGFloat = 16.0
    private var itemsPerRow: Int = 4
    private let portraitItems = 4
    private let landscapeItems = 8
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    private var bottomGradientView: GradientView = GradientView(topColor: UIColor.white.withAlphaComponent(0.0), bottomColor: UIColor.white)
    private var topDivider: UIView = UIView()
    
    private var portraitOrientation: Bool {
        let currentOrientation = UIDevice.current.orientation
        return currentOrientation == .portrait || currentOrientation == .faceUp || currentOrientation == .faceDown || currentOrientation == .portraitUpsideDown
    }
    
    var stickerPack: StickerPack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        
        if #available(iOS 10.0, *) {
            stickersCollectionView.isPrefetchingEnabled = false
        }
        
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        stickersCollectionView.scrollIndicatorInsets.bottom = 10
        
        itemsPerRow = portraitOrientation ? portraitItems : landscapeItems
        
        let infoButton: UIButton = UIButton(type: .contactAdd)
        infoButton.addTarget(self, action: #selector(addPhotoPressed(button:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        bottomGradientView.isUserInteractionEnabled = false
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomGradientView)
        
        topDivider.isUserInteractionEnabled = false
        topDivider.backgroundColor = UIColor(red: 164.0/255.0, green: 164.0/255.0, blue: 164.0/255.0, alpha: 1.0).withAlphaComponent(0.2)
        topDivider.alpha = 0.0
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topDivider)
        
        let addButton: AquaButton = AquaButton(frame: .zero)
        addButton.setTitle("Add to WhatsApp", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed(button:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isEnabled = Interoperability.canSend()
        view.addSubview(addButton)
        
        stickerPackPublisherLabel.text = "\(stickerPack.publisher) • \(stickerPack.formattedSize)"
        
        let tapGuideLabel: UILabel = UILabel()
        tapGuideLabel.text = "Tap itens to see more"
        tapGuideLabel.font = UIFont.systemFont(ofSize: 15)
        tapGuideLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        tapGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tapGuideLabel)
        
        let buttonSize: CGSize = CGSize(width: 280.0, height: 50.0)
        let buttonLandscapeSize: CGSize = CGSize(width: 250.0, height: 50.0)
        let buttonBottomMargin: CGFloat = 20.0
        
        guard let view = view else { return }
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: addButton, attribute: .bottom, multiplier: 1.0, constant: buttonBottomMargin))
        let centerPortraitShareConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0)
        let centerLandscapeShareConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: -buttonSize.width / 2.0 - 5.0)
        portraitConstraints.append(centerPortraitShareConstraint)
        landscapeConstraints.append(centerLandscapeShareConstraint)
        view.addConstraint(centerPortraitShareConstraint)
        view.addConstraint(centerLandscapeShareConstraint)
        let widthPortraitShareConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonSize.width)
        let widthLandscapeShareConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonLandscapeSize.width)
        addButton.addConstraint(widthPortraitShareConstraint)
        addButton.addConstraint(widthLandscapeShareConstraint)
        portraitConstraints.append(widthPortraitShareConstraint)
        landscapeConstraints.append(widthLandscapeShareConstraint)
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonSize.height))
        
        // Tap guide label constraints
        view.addConstraint(NSLayoutConstraint(item: addButton, attribute: .top, relatedBy: .equal, toItem: tapGuideLabel, attribute: .bottom, multiplier: 1.0, constant: 14.0))
        view.addConstraint(NSLayoutConstraint(item: tapGuideLabel, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: view, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tapGuideLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: tapGuideLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        // Collection view constraint
        var bottomCollectionViewConstraint = self.bottomCollectionViewConstraint!
        view.removeConstraint(bottomCollectionViewConstraint)
        bottomCollectionViewConstraint = NSLayoutConstraint(item: tapGuideLabel, attribute: .top, relatedBy: .equal, toItem: stickersCollectionView, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        view.addConstraint(bottomCollectionViewConstraint)
        
        // Gradient constraints
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .bottom, relatedBy: .equal, toItem: stickersCollectionView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: view, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .width, relatedBy: .equal, toItem: stickersCollectionView, attribute: .width, multiplier: 1.0, constant: 0.0))
        bottomGradientView.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0))
        
        // Top divider constraints
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .top, relatedBy: .equal, toItem: stickersCollectionView, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        topDivider.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1.0))
        
        changeConstraints()
        
        populateStickersInit()
        stickersCollectionView.reloadData()
    }
    
    private func changeConstraints() {
        portraitConstraints.forEach { $0.isActive = portraitOrientation }
        landscapeConstraints.forEach { $0.isActive = !portraitOrientation }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        itemsPerRow = portraitOrientation ? portraitItems : landscapeItems
        changeConstraints()
    }
    
    // MARK: - Scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > topMarginInset {
            topDivider.alpha = 1.0
        } else {
            topDivider.alpha = 0.0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > topMarginInset {
            topDivider.alpha = 1.0
        } else {
            topDivider.alpha = 0.0
        }
    }
    
    // MARK: - Collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interimMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topMarginInset, left: marginInset, bottom: 60, right: marginInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (collectionView.bounds.size.width - marginInset * 2 - interimMargin * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerPack.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        cell.sticker = stickerPack.stickers[indexPath.row]
        
        // Use tag to check index of cell
        cell.tag  = indexPath[1] - 3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker: Sticker = stickerPack.stickers[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)
        showActionSheet(withSticker: sticker, overCell: cell!)
    }
    
    // MARK: - Targets
    func showActionSheet(withSticker sticker: Sticker, overCell cell: UICollectionViewCell) {
        var emojisString: String?
        
        #if DEBUG
        if let emojis = sticker.emojis {
            emojisString = emojis.joined(separator: " ")
        }
        #endif
        
        let actionSheet: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n", message: emojisString, preferredStyle: .actionSheet)
        
        actionSheet.popoverPresentationController?.sourceView = cell.contentView
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.midY, width: 0, height: 0)
        actionSheet.addAction(UIAlertAction(title: "Share Image", style: .default, handler: { _ in
            self.showShareSheet(withSticker: sticker)
        }))
        actionSheet.addAction(UIAlertAction(title: "Remove Sticker", style: .destructive, handler: { _ in
            //tag contain index of cell
            self.removeSticker(index: cell.tag)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let stickerImage = sticker.imageData.image {
            actionSheet.addImageView(withImage: stickerImage)
        }
        present(actionSheet, animated: true)
    }
    
    func showShareSheet(withSticker sticker: Sticker) {
        guard let image = sticker.imageData.image else { return }
        
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(shareViewController, animated: true)
    }
    
    
    // --------------------------------------------------------------------------------
    //    Functions Add Stickers
    // --------------------------------------------------------------------------------
    
    var modelData = ModelController().fetchImageObjectsInit()
    var modelController = ModelController()
    
    //    MARK: - Gallery Manage
    @objc func addPhotoPressed(button: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = UIImage(named: "landscapeIcon")!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {   image = img.cropToSquare()  }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {   image = img.cropToSquare()  }
        
        image = image.resizeImage(targetSize: CGSize(width: 512, height: 512))
        picker.dismiss(animated: true,completion: nil)
        
        if(image.size.height != 512 || image.size.width != 512) {
            alertZoom()
        }
        else {
            insertNewSticker(image: image)
        }
    }
    
    // MARK: - Collection Update
    func populateStickersInit() {
        let images = modelData
        for image in images {
            do {
                let sticker: Sticker = try Sticker(contentsOfFile: "placeholderGreen.png", emojis: nil)
                
                let aux = image.resizeToApprox(sizeInMB: 1)
                let imageData = ImageData(data: aux, type: ImageDataExtension.png)
                sticker.imageData = imageData
                
                stickerPack!.stickers.append(sticker)
            } catch {
                print(error)
            }
        }
    }
    
    func insertNewSticker(image: UIImage) {
        modelController.saveImageObject(image: image)
        
        do {
            let sticker: Sticker = try Sticker(contentsOfFile: "placeholderGreen.png", emojis: nil)
            let aux = image.resizeToApprox(sizeInMB: 1)
            let imageData = ImageData(data: aux, type: ImageDataExtension.png)
            sticker.imageData = imageData
            
            stickerPack!.stickers.append(sticker)
            
        } catch {
            print(error)
        }
        
        stickersCollectionView.reloadData()
    }
    
    func removeSticker(index: Int) {
        if(index >= 0) {
            print("--- index:", index)
            self.modelController.deleteImageObject(imageIndex: index)
            stickerPack.stickers.remove(at: index + 3)
            stickersCollectionView.reloadData()
        }
    }
    
    // MARK: - Share Button
    func shareWaths() {
        let loadingAlert: UIAlertController = UIAlertController(title: "Sending to WhatsApp", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true)
        stickerPack.sendToWhatsApp { completed in
            loadingAlert.dismiss(animated: true)
        }
    }
    
    @objc func addButtonPressed(button: AquaButton) {
        if(RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") || (UserDefaults.standard.object(forKey: "NoAds.iPhotos") != nil)) {
            shareWaths()
        }
        else if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        else {
            shareWaths()
        }
    }
    
    //  MARK: - UIAlert
    func alertZoom() {
        let alert = UIAlertController(title: "Size Image Error", message: "Increase zoom in the image", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //    ADS
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
      shareWaths()
    }
    
    fileprivate func setupAds() {
        //        ADS
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
        let request = GADRequest()
        interstitial.load(request)
        interstitial = createAndLoadInterstitial()
    }
}

// MARK: - Extension Image Handle
extension UIImage {
    func resizeToApprox(sizeInMB: Double, deltaInMB: Double = 0.2) -> Data {
        let allowedSizeInBytes = Int(sizeInMB * 1024 * 1024)
        let deltaInBytes = Int(deltaInMB * 1024 * 1024)
        let fullResImage = self.jpegData(compressionQuality: 1.0)
        if (fullResImage?.count)! < Int(deltaInBytes + allowedSizeInBytes) {
            return fullResImage!
        }
        
        var i = 0
        
        var left:CGFloat = 0.0, right: CGFloat = 1.0
        var mid = (left + right) / 2.0
        var newResImage = self.jpegData(compressionQuality: mid)
        
        while (true) {
            i += 1
            if (i > 13) {
                print("Compression ran too many times ")
                break
            }
            
            print("mid = \(mid)")
            
            if ((newResImage?.count)! < (allowedSizeInBytes - deltaInBytes)) {
                left = mid
            } else if ((newResImage?.count)! > (allowedSizeInBytes + deltaInBytes)) {
                right = mid
            } else {
                print("loop ran \(i) times")
                return newResImage!
            }
            mid = (left + right) / 2.0
            newResImage = self.jpegData(compressionQuality: mid)
        }
        
        return self.jpegData(compressionQuality: 0.5)!
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func cropToSquare() -> UIImage {
        var auxImg = self
        if(self.size.width < self.size.height) {
            auxImg = self.cropToBounds(image: self, width: Double(self.size.width), height: Double(self.size.width))
        }
        else if (self.size.width > self.size.height){
            auxImg = self.cropToBounds(image: self, width: Double(self.size.height), height: Double(self.size.height))
        }
        
        return auxImg
    }
    
    public func rounded(radius: CGFloat) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

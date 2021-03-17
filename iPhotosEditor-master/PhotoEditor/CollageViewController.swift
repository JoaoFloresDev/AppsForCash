//
//  CollageViewController.swift
//  iPhotos
//
//  Created by Joao Flores on 22/07/20.
//  Copyright © 2020 WhatsApp. All rights reserved.
//

import UIKit
import CLImageEditor
import Agrume
import StoreKit
import GoogleMobileAds

class CollageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate,  CLImageEditorDelegate, GADInterstitialDelegate {

    //    MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellOptions: UIView!

    @IBOutlet weak var backgroundCellImage: UIImageView!
    @IBOutlet weak var cellImage: UIView!
    @IBOutlet weak var backgroundOptions: UIImageView!

    //    MARK: - IBAction
    @IBAction func showImg(_ sender: Any) {
        let agrume = Agrume(image: imageView.image!)
        agrume.show(from: self)
    }

    @IBAction func editImgTest(_ sender: Any) {
        newImage()
    }

    @IBAction func saveImgTest(_ sender: Any) {
        if(RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") || (UserDefaults.standard.object(forKey: "NoAds.iPhotos") != nil)) {
            saveImage()
        }
        else if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        else {
            saveImage()
        }
    }

    @IBAction func editeeeImgTest(_ sender: Any) {
        editImage()
    }

    //    MARK: - VARIABLES
    let STORED_IMAGE_NAME = "/stored_image_name.png"

    var interstitial: GADInterstitial!

    //    MARK: - LIFE CYCLE
    /// load any stored image

    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        print("-------------")
        print("interstitialDidDismissScreen")
        self.saveImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(true, forKey:"FirtsUse")

        //        ADS
        interstitial = createAndLoadInterstitial()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)

        var image = readImageFromStorage()
        if image == nil {
            image = UIImage(named: "placeholder")
        }
        imageView.image = image

        cellOptions.clipsToBounds = false
        cellOptions.layer.shadowColor = UIColor.black.cgColor
        cellOptions.layer.shadowOpacity = 0.5
        cellOptions.layer.shadowRadius = 3
        cellOptions.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundOptions.layer.cornerRadius = 10

        cellImage.clipsToBounds = false
        cellImage.layer.shadowColor = UIColor.black.cgColor
        cellImage.layer.shadowOpacity = 0.5
        cellImage.layer.shadowRadius = 3
        cellImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundCellImage.layer.cornerRadius = 10
    }

    /// called when an image has been chosen
    /// here we start the editor with the new image


    //    MARK: - imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        imageView.image = image
        imageView.layer.cornerRadius = 10
        picker.dismiss(animated: true, completion: nil)

        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0)

          let path = UIBezierPath(roundedRect: imageView.bounds.insetBy(dx: 20 / 2, dy: 20 / 2), cornerRadius: 10.0)
        let context = UIGraphicsGetCurrentContext()

          context!.saveGState()
        // Clip the drawing area to the path
        path.addClip()

        // Draw the image into the context
//        imageView.image.dr
        imageView.image!.draw(in: imageView.bounds)
          (context ?? 100 as! CGContext).restoreGState()

        // Configure the stroke
          UIColor.purple.setStroke()
        path.lineWidth = 20

        // Stroke the border
        path.stroke()

        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        view.addSubview(UIImageView(image: roundedImage))
    }

    /// called when editor completes
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {

        imageView.image = image
        editor.dismiss(animated: true, completion: nil)

        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }

    //    MARK: - tabBar
    // mark - Tab Bar Delegate
    @objc func deselectTabBarItem(tabBar: UITabBar) {

        tabBar.selectedItem = nil
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        self.perform(#selector(deselectTabBarItem(tabBar:)), with: tabBar, afterDelay: 0.2)

        switch (item.tag) {
        case 0:
            self.newImage()
            break

        case 1:
            self.editImage()
            break

        case 2:
            self.saveImage()
            break

        default:
            break
        }
    }


    /// mark - Tab bar actions

    /// get a new image to edit
    func newImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    //    MARK: - OPTIONS
    /// edit current image
    func editImage() {

        if (imageView.image != nil) {
            let editor = CLImageEditor(image: imageView.image, delegate: self)
            self.present(editor!, animated: true, completion: nil)

        } else {
            newImage()
        }
    }

    /// save current image
    func saveImage() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
        else {
            showAlertWith(title: "Error", message: "Try again.")
        }
    }

    //    MARK: - IMAGE MAGEMENT
    func readImageFromStorage() -> UIImage? {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        if documentsPath.count > 0 {
            let documentDirectory = documentsPath[0]
            let restorePath = documentDirectory + STORED_IMAGE_NAME

            let image = UIImage(contentsOfFile: restorePath)

            return image
        } else {
            return nil
        }
    }

    func writeImageToStorage(image: UIImage) -> Bool {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        return true
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }

    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    //    ADS LIFECYCLE
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("-------------")
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillLeaveApplication")
    }
}

//
//  BookViewController.swift
//  Dispensado
//
//  Created by Joao Flores on 01/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import os.log
import StoreKit
import GoogleMobileAds

class BookViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADInterstitialDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //    novos texts
    @IBOutlet weak var missTextField: UILabel!
    @IBOutlet weak var lessonsTextField: UITextField!
    
    @IBOutlet weak var obsTextView: UITextView!
    
    @IBOutlet weak var missesState: UIView!
    
    var currentMiss = 0
    var maxMiss = 0
    
    var book: BookClass?
    var interstitial: GADInterstitial!
    var firstAdd = true
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/2509258121")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey:"FirtsUse")
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        //      ADS
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/2509258121")
        interstitial.delegate = self
        interstitial = createAndLoadInterstitial()
        let request = GADRequest()
        interstitial.load(request)
        // ------
        
        obsTextView.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("dismissKeyboardFunc")))
        
        view.addGestureRecognizer(tap)
        
        obsTextView.delegate = self as? UITextViewDelegate
        nameTextField.delegate = self
        
        if let bookControll = book {
            navigationItem.title = bookControll.name
            nameTextField.text = bookControll.name
            photoImageView.image = bookControll.photo
            
            missTextField.text = "\(bookControll.currentMiss) / \(bookControll.maxMiss)"
            
            currentMiss = bookControll.currentMiss
            maxMiss = bookControll.maxMiss
            
            lessonsTextField.text = String(bookControll.lessons)
            obsTextView.text = bookControll.observations
            missesState.alpha = 1
        } else {
            missesState.alpha = 0
        }
        
        updateSaveButtonState()
        
        cropBounds(viewlayer: photoImageView.layer, cornerRadius: 10)
    }
    
    //    MARK: - LifeCycle
    func cropBounds(viewlayer: CALayer, cornerRadius: Float) {
        
        let imageLayer = viewlayer
        imageLayer.cornerRadius = CGFloat(cornerRadius)
        imageLayer.masksToBounds = true
    }
    
    //    MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {   image = img    }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {   image = img    }
        
        photoImageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddBookMode = presentingViewController is UINavigationController
        
        if isPresentingInAddBookMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let lessons = Int(lessonsTextField.text ?? "0")
        let observations = obsTextView.text ?? ""
        maxMiss = Int(Double(lessons ?? 0))
        
        book = BookClass(name: name, photo: photo, currentMiss: currentMiss, maxMiss: maxMiss, lessons: lessons ?? 0, observations: observations)
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    //MARK: - Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        let imagePicker =  UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func subMiss(_ sender: Any) {
        if(currentMiss > 0) {
            currentMiss = currentMiss - 1
            missTextField.text = "\(currentMiss) / \(maxMiss)"
            if(currentMiss > maxMiss) {
                missTextField.textColor = UIColor.red
            }
            else {
                missTextField.textColor = UIColor.black
            }
        }
    }
    
    @IBAction func addMiss(_ sender: Any) {
        
        currentMiss = currentMiss + 1
        missTextField.text = "\(currentMiss) / \(maxMiss)"
        if(currentMiss > maxMiss) {
            missTextField.textColor = UIColor.red
        }
        else {
            missTextField.textColor = UIColor.black
        }
        
        if(RazeFaceProducts.store.isProductPurchased("NoAds.College") || (UserDefaults.standard.object(forKey: "NoAds.College") != nil)) {
            print("comprado")
        }
        else if interstitial.isReady && firstAdd {
          interstitial.present(fromRootViewController: self)
            firstAdd = false
        }
    }
    
    //MARK: - Private Methods
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @objc func dismissKeyboardFunc() {
        maxMiss = Int(Double(Int(lessonsTextField.text ?? "0") ?? 0))
        
        if book != nil {
            missTextField.text = "\(currentMiss) / \(maxMiss)"
            if(currentMiss > maxMiss) {
                missTextField.textColor = UIColor.red
            }
            else {
                missTextField.textColor = UIColor.black
            }
        }
        
        view.endEditing(true)
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}


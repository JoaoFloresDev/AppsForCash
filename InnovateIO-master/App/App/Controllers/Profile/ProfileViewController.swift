//
//  ProfileViewController.swift
//  App
//
//  Created by Joao Flores on 07/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import QuartzCore
import Photos
import os.log

/// Profile screen:
/// - graphics weight and good habits
/// - abstract
/// - header with general data

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //    MARK: - IBOutlet
    
    //BackgroundImages
    @IBOutlet weak var headerBackgroundImg: UIImageView!
    
    //  header
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileImgView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myGoalsTextView: UITextView!
    @IBOutlet weak var currentWeightLabel: UILabel!
    
    //  resume
    @IBOutlet weak var exercicePercentLabel: UILabel!
    @IBOutlet weak var fruitsPercentLabel: UILabel!
    @IBOutlet weak var waterPercentLabel: UILabel!
    
    //  graphics
    @IBOutlet weak var weightGraphicView: UIView!
    @IBOutlet weak var habitsGraphicView: UIView!
    @IBOutlet weak var resumeView: UIView!
    
    @IBOutlet weak var weightGraphicLineView: UIView!
    @IBOutlet weak var habitsGraphicLineView: UIView!
    @IBOutlet weak var meatsGraphicBarsView: UIView!
    
    //    MARK: - Variables
    var imagePicker: UIImagePickerController!
    
    var timerGoalsAnimation: Timer!
    var headerViewHeightConstraint: NSLayoutConstraint!
    var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var dataHandler: DataHandler?
    
    //    MARK: - Life Cicle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        do {
            self.dataHandler = try DataHandler.getShared()
        }
        catch {
            os_log("[ERROR] The App wasn't fully initialized yet for managing data!")
        }
        
        setupStyleViews()
        setupDataProfile()
        setUpdateDataProfileNotification()
        
        for constraints in headerView.constraints {
            if(constraints.identifier == "headerView") {
                headerViewHeightConstraint = constraints
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupGraphic()
    }
    
    func setUpdateDataProfileNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHeaderInformations), name: NSNotification.Name(rawValue: "updateDataProfile"), object: nil)
    }
    
    //    MARK: - @objc functions
    @objc func updateHeaderInformations() {
        ProfimeDataMenager().setupHeaderInformations(goalsTextView: myGoalsTextView,currentWeightLabel: currentWeightLabel)
    }
    
    //    MARK: - Graphics
    func setupGraphic() {
        
        do {
            let plotter = try PlotGraphicClass()
            for view in meatsGraphicBarsView.subviews {
                view.removeFromSuperview()
            }
            let (redPercentage, yellowPercentage) = try plotter.loadHabitsAsPercentage()
            plotter.plotGraphicHorizontalBars (view: meatsGraphicBarsView, redPercent: redPercentage, yellowPercent: yellowPercentage )
            
            let months = plotter.getMonths()
            
            // Getting the current days last two months
            let dates: NSMutableArray = plotter.getDatesGraphic(months)
            
            // Starting to populate and draw the charts...
            var numbersArray: [[Int32]] = plotter.getWeightsValuesGraphic(months)
            
            plotter.plotGraphicLine(graphicVIew: weightGraphicLineView, colorLinesArray: [UIColor.black], datesX: dates, numbersArray: numbersArray, topNumber: 120, bottomNumber: 0)
            
            let colorWater = R.color.habitsWaterColor()!
            let colorFruits = R.color.habitsFruitsColor()!
            let colorExercice = R.color.habitsExerciceColor()!
            
            //  Populating the habits with core data values
            numbersArray = plotter.getHabitsValuesGraphic(months)

            plotter.plotGraphicLine(graphicVIew: habitsGraphicLineView, colorLinesArray: [colorWater, colorFruits, colorExercice], datesX: dates, numbersArray: numbersArray, topNumber: 100, bottomNumber: 0)
            
            //set resume habits values
            
            var percentWater = numbersArray[0].popLast()!
            var percentFruits = numbersArray[1].popLast()!
            var percentExercise = numbersArray[2].popLast()!
            
            if(percentWater >= 97) {
                percentWater = 100
            }
            if(percentFruits >= 97) {
                percentFruits = 100
            }
            if(percentExercise >= 97) {
                percentExercise = 100
            }
            
            waterPercentLabel.text = String(percentWater) + " %"
            fruitsPercentLabel.text = String(percentFruits) + " %"
            exercicePercentLabel.text = String(percentExercise) + " %"
        }
        catch {
            os_log("[ERROR] Couldn't communicate with the operating system's internal calendar/time system or memory is too low!")
        }
    }
    //    MARK: - Take Profile Image
    func openGalery() {
        
        imagePicker =  UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {   image = img    }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {   image = img    }
        
        StyleClass().cropBounds(viewlayer: profileImg.layer,
                                cornerRadius: Float(profileImg.frame.size.width/2))
        
        profileImg.image = image
        picker.dismiss(animated: true,completion: nil)
        
        print(ProfimeDataMenager().saveImage(image: image))
    }
    
    //    MARK: - Data Profile
    func setupDataProfile() {
        ProfimeDataMenager().setupNameProfile(nameUser: nameLabel)
        ProfimeDataMenager().setupImgProfile(profileImg: profileImg)
        ProfimeDataMenager().setupHeaderInformations(goalsTextView: myGoalsTextView,
                                                     currentWeightLabel: currentWeightLabel)
    }
    
    //    MARK: - Animations
    func animateGoals() {
        if let timer = self.timerGoalsAnimation{
            do {
                timer.invalidate()
            }
        }
        if(headerViewHeightConstraint.constant >= 151) {
            self.timerGoalsAnimation = Timer.scheduledTimer(timeInterval: 0.00005, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: true)
        } else {
            gradientView.removeFromSuperview()
            self.timerGoalsAnimation = Timer.scheduledTimer(timeInterval: 0.00005, target: self, selector: #selector(self.animateShow), userInfo: nil, repeats: true)
        }
    }
    
    @objc func animateShow () {
        let neewSize = 100 + self.myGoalsTextView.contentSize.height
        let sizeWillFill = neewSize - headerViewHeightConstraint.constant
        
        if(headerViewHeightConstraint.constant <= neewSize - 60) {
            headerViewHeightConstraint.constant = headerViewHeightConstraint.constant + 0.02
        } else if(headerViewHeightConstraint.constant < neewSize && headerViewHeightConstraint.constant < 600) {
            headerViewHeightConstraint.constant = headerViewHeightConstraint.constant + sizeWillFill/3000 + 0.0001
        }
        else {
            self.timerGoalsAnimation.invalidate()
        }
    }
    
    @objc func animateHide () {
        let sizeWillFill = headerViewHeightConstraint.constant - 150
        
        if(headerViewHeightConstraint.constant >= 210) {
            headerViewHeightConstraint.constant = headerViewHeightConstraint.constant - 0.02
        }
        else if (headerViewHeightConstraint.constant > 150){
            headerViewHeightConstraint.constant = headerViewHeightConstraint.constant - sizeWillFill/3000 - 0.001
        }
        else {
            self.timerGoalsAnimation.invalidate()
            myGoalsTextView.addSubview(gradientView)
        }
    }
    
    //    MARK: - Style
    
    func setupStyleViews() {
        StyleClass().cropBounds(viewlayer: weightGraphicView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: habitsGraphicView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: resumeView.layer, cornerRadius: 10)
        
        StyleClass().cropBounds(viewlayer: headerBackgroundImg.layer, cornerRadius: 25)
        StyleClass().cropBounds(viewlayer: profileImgView.layer, cornerRadius: Float(profileImgView.frame.width/2))
        StyleClass().applicShadow(layer: headerView.layer)
        
        
        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: myGoalsTextView.frame.width, height: myGoalsTextView.frame.height))
        StyleClass().appliGradient(view: gradientView)
        myGoalsTextView.addSubview(gradientView)
    }
    
    //    MARK: - IBAction
      @IBAction func selectImgProfile(_ sender: Any) {
          openGalery()
      }
      
      @IBAction func showGoals(_ sender: Any) {
          animateGoals()
      }
}

// MARK: - DATE

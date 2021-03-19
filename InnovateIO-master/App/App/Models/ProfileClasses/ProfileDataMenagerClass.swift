//
//  profimeImgMenager.swift
//  App
//
//  Created by Joao Flores on 27/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

/// Functions to menage data with profile (image, goals, name, resume)

class ProfimeDataMenager {
    var defaults = UserDefaults.standard
    
//    MARK: - Profile Labels / UserDefaults
    func setupNameProfile(nameUser: UILabel) {
        var vet = UIDevice.current.name.split(separator: " ")
        for _ in 0...1 {
            vet.remove(at: 0)
        }
        
        nameUser.text = vet.joined(separator: " ").capitalized
    }
    
    func setupHeaderInformations(goalsTextView: UITextView,currentWeightLabel: UILabel) {
        goalsTextView.text = defaults.string(forKey: "Plain") ?? "Insira suas metas e planos no botão + \n"
        currentWeightLabel.text = "\(defaults.string(forKey: "Weight") ?? "00") Kg"
    }
    
//    MARK: - Profile Image
//    Load
    func setupImgProfile(profileImg: UIImageView) {
        if let image = getSavedImage(named: "ProfileImg") {
            StyleClass().cropBounds(viewlayer: profileImg.layer,
                       cornerRadius: Float(profileImg.frame.size.width/2))
            
            profileImg.image = image
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
//    Save
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("ProfileImg.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}



//
//  MealHistoryTableViewCell.swift
//  App
//
//  Created by Priscila Zucato on 05/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class MealHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var mealRoundedView: RoundedView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var noMealView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        mealRoundedView.isHidden = false
        noMealView.isHidden = true
    }
    
    func setup(meal: Meal?) {
        if let meal = meal {
            guard let rating = Rating(rawValue: Int(meal.quality)) else {
                        os_log("Error when mapping quality of fetched meal to Rating instance.")
                        return
                    }
                    
            commonSetup(rating: rating, note: meal.note, hour: Int(meal.hour), minute: Int(meal.minute))
        } else {
            mealRoundedView.isHidden = true
            noMealView.isHidden = false
        }
    }
    
    func commonSetup(rating: Rating?, note: String? = nil, image: UIImage? = nil, hour: Int, minute: Int) {
        colorView.backgroundColor = rating?.color ?? .white
        ratingLabel.text = rating?.title ?? ""
        
        noteLabel.text = note == nil ? rating?.defaultNoteForMeal : note
        
        // TODO: uncomment when meal image is implemented in Core Data.
             //        mealImage.isHidden = image == nil
             //        mealImage.image = image
        
        timeLabel.text = String(format: "%02d", hour) + "h" + String(format: "%02d", minute)
    }
    
    func setMealViewBorder(to value: CGFloat) {
        mealRoundedView.borderWidth = value
    }
}

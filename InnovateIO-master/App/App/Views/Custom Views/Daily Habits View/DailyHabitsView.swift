//
//  DailyHabitsView.swift
//  App
//
//  Created by Priscila Zucato on 28/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol DailyHabitsViewDelegate {
    func dailyDiaryDidUpdate(_ diary: DailyDiary)
}

class DailyHabitsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var todayRatingView: RatingView!
    @IBOutlet weak var groupedHabitsView: GroupedHabitsView!
    
    private var delegate: DailyHabitsViewDelegate?
    private var dailyHabits : [DailyHabits : Bool] = [.exercise : false, .fruit : false, .drinkWater : false]
    private var dailyDiary: DailyDiary?
    
    private var selectedRating: Rating?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.dailyHabitsView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    //MARK: - Methods
    func setup(delegate: DailyHabitsViewDelegate) {
        self.delegate = delegate
        todayRatingView.setup(delegate: self)
        groupedHabitsView.setup(delegate: self)
    }
    
    func setInitialDailyDiary(_ diary: DailyDiary?) {
        self.dailyDiary = diary
        updateViewToDiary()
    }
    
    private func updateViewToDiary() {
        guard let dailyDiary = self.dailyDiary else { return }
        
        dailyHabits[.drinkWater] = dailyDiary.didDrinkWater
        dailyHabits[.exercise] = dailyDiary.didPracticeExercise
        dailyHabits[.fruit] = dailyDiary.didEatFruit
        groupedHabitsView.initallySetHabits(dailyHabits: dailyHabits)
        
        let initialRating = Rating(rawValue: Int(dailyDiary.quality)) ?? .average
        todayRatingView.setInitiallySelectedRating(initialRating)
    }
    
    private func updatedDailyDiary() {
        if let diary = self.dailyDiary {
            delegate?.dailyDiaryDidUpdate(diary)
        }
    }
    
    private func updatedHabit(_ habit: DailyHabits) {
        let change = dailyHabits[habit] ?? false
        switch habit {
        case .drinkWater:
            dailyDiary?.didDrinkWater = change
        case .exercise:
            dailyDiary?.didPracticeExercise = change
        case .fruit:
            dailyDiary?.didEatFruit = change
        }
        
        updatedDailyDiary()
    }
}

// MARK: - Rating View Delegate
extension DailyHabitsView: RatingViewDelegate {
    func selectedRatingDidChange(to rating: Rating?) {
        guard let diary = dailyDiary, let rating = rating else { return }
        diary.quality = Int32(rating.rawValue)
        updatedDailyDiary()
    }
}

// MARK: - Grouped Habits Delegate
extension DailyHabitsView: GroupedHabitsDelegate {
    func dailyHabitDidChange(habit: DailyHabits, value: Bool) {
        self.dailyHabits[habit] = value
        updatedHabit(habit)
    }
}

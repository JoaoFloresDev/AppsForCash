//
//  GroupedHabitsView.swift
//  App
//
//  Created by Priscila Zucato on 29/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol GroupedHabitsDelegate {
    func dailyHabitDidChange(habit: DailyHabits, value: Bool)
}

class GroupedHabitsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var habitsStackView: UIStackView!
    
    var delegate: GroupedHabitsDelegate?
    var orderedHabits: [DailyHabits] = [.drinkWater, .fruit, .exercise]
    var dailyHabits: [DailyHabits : Bool] = [.drinkWater : false, .fruit : false, .exercise : false]
    
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
        Bundle.main.loadNibNamed(R.nib.groupedHabitsView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Methods
    func setup(delegate: GroupedHabitsDelegate) {
        self.delegate = delegate
        
        if let singleHabitViews = habitsStackView.subviews as? [SingleHabitView] {
            for index in 0 ... orderedHabits.count - 1 {
                singleHabitViews[index].setup(habit: orderedHabits[index], delegate: self)
            }
        }
    }
    
    func initallySetHabits(dailyHabits: [DailyHabits : Bool]) {
        self.dailyHabits = dailyHabits
        if let singleHabitViews = habitsStackView.subviews as? [SingleHabitView] {
            for index in 0 ... orderedHabits.count - 1 {
                singleHabitViews[index].isSelected = dailyHabits[orderedHabits[index]] ?? false
            }
        }
    }
}

// MARK: - Single Habit Delegate
extension GroupedHabitsView: SingleHabitViewDelegate {
    func selectionDidChange(habit: DailyHabits, value: Bool) {
        dailyHabits[habit] = value
        
        delegate?.dailyHabitDidChange(habit: habit, value: value)
    }
}

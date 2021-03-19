//
//  SingleHabitView.swift
//  App
//
//  Created by Priscila Zucato on 29/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol SingleHabitViewDelegate {
    func selectionDidChange(habit: DailyHabits, value: Bool)
}

class SingleHabitView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var selectionBarView: RoundedView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var delegate: SingleHabitViewDelegate?
    private var habit: DailyHabits = .drinkWater
    var isSelected: Bool = false {
        didSet {
            selectionBarView.backgroundColor = isSelected ? habit.color : .clear
            iconView.tintColor = isSelected ? habit.color : .lightGray
        }
    }
    
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
        Bundle.main.loadNibNamed(R.nib.singleHabitView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Methods
    func setup(habit: DailyHabits, delegate: SingleHabitViewDelegate) {
        self.delegate = delegate
        
        self.habit = habit
        selectionBarView.backgroundColor = isSelected ? habit.color : .clear
        iconView.tintColor = isSelected ? habit.color : .lightGray
        
        selectionBarView.cornerRadius = selectionBarView.bounds.height / 2
        iconView.image = habit.icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = habit.title
    }
    
    // MARK: - IBActions
    @IBAction func tappedSelection(_ sender: Any) {
        isSelected = !isSelected
        delegate?.selectionDidChange(habit: habit, value: isSelected)
    }
}

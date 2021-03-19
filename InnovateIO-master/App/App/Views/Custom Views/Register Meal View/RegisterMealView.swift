//
//  RegisterMealView.swift
//  App
//
//  Created by Priscila Zucato on 29/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol RegisterMealViewDelegate {
    func saveMeal(quality: Int, hour: Int, minute: Int, note: String?)
    func goToNote(note: String?)
    func goToInfo()
    func presentAlert(_ alert: UIAlertController)
    func dismissVCIfApplicable()
}

class RegisterMealView: UIView {
    @IBOutlet var contentView: RoundedView!
    @IBOutlet weak var thisMealRatingView: RatingView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var finishButton: RoundedButton!
    
    var delegate: RegisterMealViewDelegate?
    var note: String? {
        didSet {
            if let note = note, note.isEmptyOrWhitespace() == false {
                noteTableView.isHidden = false
                noteTableView.reloadData()
            } else {
                noteTableView.isHidden = true
            }
        }
    }
    var selectedDate: Date = Date()
    
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
        Bundle.main.loadNibNamed(R.nib.registerMealView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setTableView()
    }

// MARK: - Methods
    func setup(delegate: RegisterMealViewDelegate) {
        self.delegate = delegate
        thisMealRatingView.setup()
        thisMealRatingView.delegate = self
        setupDatePicker()
    }
    
    func setTableView() {
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(UINib(resource: R.nib.mealHistoryTableViewCell),
                               forCellReuseIdentifier: R.reuseIdentifier.mealHistoryTableViewCell.identifier)
    }
    
    func set(meal: Meal) {
        thisMealRatingView.setInitiallySelectedRating(Rating(rawValue: Int(meal.quality)))
        
        let (year, month, day, hour, minute) = (Int(meal.year), Int(meal.month), Int(meal.day), Int(meal.hour), Int(meal.minute))
        let receivedDate = Date.fromComponents(year: year, month: month, day: day, hour: hour, minute: minute) ?? Date()
        datePicker.date = receivedDate
        selectedDate = receivedDate
        note = meal.note
        
        finishButton.setTitle("Confirmar", for: .normal)
    }
    
    fileprivate func setupDatePicker() {
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.locale = Locale(identifier: "pt_BR")
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
    }
    
    fileprivate func reset() {
        self.datePicker.date = Date()
        self.thisMealRatingView.setInitiallySelectedRating(nil)
        self.note = nil
    }
    
// MARK: - Actions
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        noteTableView.reloadData()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.goToInfo()
    }
    
    @IBAction func addNoteTapped(_ sender: Any) {
        delegate?.goToNote(note: note)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let thisMealRate = thisMealRatingView.selectedRating else {
            let alert = UIAlertController(title: "Atenção!", message: "Selecione uma avaliação para sua refeição.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            delegate?.presentAlert(alert)
            return
        }
        do {
            print(selectedDate)
            let (_, _, _, hour, minute, _) = try selectedDate.getAllInformations()
            
            delegate?.saveMeal(quality: thisMealRate.rawValue, hour: hour, minute: minute, note: note)
            
            let alert = UIAlertController(title: "Salvo!", message: "Sua refeição foi registrada.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.delegate?.dismissVCIfApplicable()
                self.reset()
            }))
            delegate?.presentAlert(alert)
        } catch {
            print("Couldn't get hour and minute from date picker.")
            
            let alert = UIAlertController(title: "Ops!", message: "Algo deu errado, tente novamente!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            delegate?.presentAlert(alert)
        }
    }
}

// MARK: - Table View delegate and data source
extension RegisterMealView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mealHistoryTableViewCell.identifier) as? MealHistoryTableViewCell else { return UITableViewCell() }
        
        let (_, _, _, hour, minute, _) = try! selectedDate.getAllInformations()
        
        cell.commonSetup(rating: thisMealRatingView.selectedRating, note: note, hour: hour, minute: minute)
        cell.setMealViewBorder(to: 0.3)
        
        return cell
    }
}

// MARK: - Rating View Delegate
extension RegisterMealView: RatingViewDelegate {
    func selectedRatingDidChange(to rating: Rating?) {
        noteTableView.reloadData()
    }
}

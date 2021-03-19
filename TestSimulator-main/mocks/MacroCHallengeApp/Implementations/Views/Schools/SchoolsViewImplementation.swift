//
//  SchoolsViewImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import UIKit

class SchoolsViewImplementation: UIView, SchoolsViewProtocol {
    // MARK: -IBOutlets
    @IBOutlet weak var tableViewSchools: UITableView!
    
    // MARK: - Dependencies
    var viewController: SchoolsViewControllerProtocol
    
    // MARK: - Private attributes
    private var data: [School]
    
    // MARK: - Init methods
    required init(data: [School], controller: SchoolsViewControllerProtocol) {
        self.data = data
        self.viewController = controller
        super.init(frame: CGRect.zero)
        initFromNib()
        
        setupDelegateTableview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFromNib() {
        if let nib = Bundle.main.loadNibNamed("SchoolsViewImplementation", owner: self, options: nil),
           let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
}

// MARK: - Extension Table View Data Source Methods
extension SchoolsViewImplementation:UITableViewDataSource, UITableViewDelegate {
    
    func setupDelegateTableview() {
        tableViewSchools.delegate = self
        tableViewSchools.dataSource = self
        tableViewSchools.register(UINib(nibName: "SchoolsTableViewCell", bundle: nil), forCellReuseIdentifier: "SchoolsTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolsTableViewCell", for: indexPath) as? SchoolsTableViewCell {
            cell.schoolLabel.text = data[indexPath.row].name
            cell.locationLabel.text = data[indexPath.row].location.joined(separator: " ")
            cell.logoImageView.image = data[indexPath.row].logo
            return cell
        } else {
            let cell = UITableViewCell.init()
            cell.textLabel?.text = data[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewSchools.deselectRow(at: indexPath, animated: true)
        viewController.schoolWasSubmitted(data[indexPath.row])
    }
}

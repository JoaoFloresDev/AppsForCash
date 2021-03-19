//
//  MetricsViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import UIKit

class MetricsViewControllerImplementation: UIView, MetricsViewProtocol {
    // MARK: -IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    var viewController: MetricsViewControllerProtocol
    
    // MARK: - Private attributes
    private var generalResults: ResultsPerTopic
    private var topicsResults: [String : ResultsPerTopic]
    private let sectionHeaderTitleArray = ["Resultados Gerais", "", ""]
    
    // MARK: - Init methods
    required init(generalResults: ResultsPerTopic, topicsResults: [String : ResultsPerTopic], controller: MetricsViewControllerProtocol) {
        self.generalResults = generalResults
        self.topicsResults = topicsResults
        self.viewController = controller
        super.init(frame: CGRect.zero)
        initFromNib()
        
        setupDelegateTableview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFromNib() {
        if let nib = Bundle.main.loadNibNamed("MetricsViewImplementation", owner: self, options: nil),
           let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
}

// MARK: - Extension Table View Data Source Methods
extension MetricsViewControllerImplementation: UITableViewDataSource, UITableViewDelegate {
    
    func setupDelegateTableview() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}

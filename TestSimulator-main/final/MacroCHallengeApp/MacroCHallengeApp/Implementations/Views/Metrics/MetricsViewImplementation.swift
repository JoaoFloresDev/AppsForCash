//
//  MetricsViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import UIKit

class MetricsViewImplementation: UIView, MetricsViewProtocol {
    // MARK: -IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    var viewController: MetricsViewControllerProtocol
    
    // MARK: - Private attributes
    private var generalResults: ResultsPerTopic
    private var topicsResults: [String : ResultsPerTopic]
    private let sectionHeaderTitleArray = ["Resultados gerais",
                                           "Resultados por tópico"]
    private var topicsArraysKeys: [String] = []
    
    // MARK: - Init methods
    required init(generalResults: ResultsPerTopic, topicsResults: [String : ResultsPerTopic], controller: MetricsViewControllerProtocol) {
        self.generalResults = generalResults
        self.topicsResults = topicsResults
        self.viewController = controller
        super.init(frame: CGRect.zero)
        initFromNib()
        topicsArraysKeys = setupTopicsArrayKeys()
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
    
    // MARK: - Private methods
    /**
     
     Método responsável por referenciar a XIB de uma determinada célula.
     
     - parameters nibName: nome do arquivo XIB da célula
     
     */
    
    private func referenceXib(nibName: String) {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /**
     
     Método responsável de montar o array de seções a partir dos tópicos da prova.
     
     */
    private func setupTopicsArrayKeys() -> [String]{
        var resultArray: [String] = []
        
        for topic in topicsResults {
            let key = topic.key
            
            if !resultArray.contains(key) {
                resultArray.append(key)
            }
        }
        
        return resultArray
    }
}

// MARK: - Extension Table View Data Source Methods
extension MetricsViewImplementation: UITableViewDataSource, UITableViewDelegate {
    
    func setupDelegateTableview() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitleArray[section] as String
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.init(red: 242/255,
                                                                                          green: 242/255,
                                                                                          blue: 247/255,
                                                                                          alpha: 1.0)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.init(red: 123/255,
                                                                                   green: 123/255,
                                                                                   blue: 123/255,
                                                                                   alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == 0 { // resultado geral
            numberOfRows = 1
        } else if section == 1 { // resultado por tópicos
            numberOfRows = topicsResults.count
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = String()
        var finalCell = UITableViewCell()
        finalCell.backgroundColor = UIColor.init(red: 242/255,
                                                  green: 242/255,
                                                  blue: 247/255,
                                                  alpha: 1.0)
        
        if indexPath.section == 0 { // resultado geral
            cellIdentifier = "PieChartTableViewCell"
            referenceXib(nibName: cellIdentifier)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PieChartTableViewCell  else {
                fatalError("The dequeued cell is not an instance of PieChartTableViewCell.")
            }

            cell.updateView(numberOfRightAnswers: generalResults.totalNumberOfCorrectAnswers,
                            numberOfWrongAnswers: generalResults.totalNumberOfQuestions - generalResults.totalNumberOfCorrectAnswers,
                            totalNumberOfQuestions: generalResults.totalNumberOfQuestions)
            
            finalCell = cell
            
        } else if indexPath.section == 1 { // resultado por matéria
            cellIdentifier = "ProgressBarTableViewCell"
            referenceXib(nibName: cellIdentifier)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProgressBarTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ProgressBarTableViewCell.")
            }
            
            let keyForRow = topicsArraysKeys[indexPath.row]
            
            guard let resultPerTopic = topicsResults[keyForRow] else {
                return UITableViewCell()
            }
            
            cell.updateView(topic: keyForRow,
                            numberOfRightAnswers: resultPerTopic.totalNumberOfCorrectAnswers,
                            totalNumberOfQuestions: resultPerTopic.totalNumberOfQuestions,
                            percetage: resultPerTopic.totalPercentageOfCorrectAnswers)
            
            finalCell = cell
            
        }
        
        return finalCell
    }
    
}

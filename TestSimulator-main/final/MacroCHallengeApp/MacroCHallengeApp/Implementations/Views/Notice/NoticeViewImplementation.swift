//
//  NoticeViewImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 22/10/20.
//

import UIKit

class NoticeViewImplementation: UIView, NoticeViewProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet weak var testTableView: UITableView!
    
    // MARK: - Dependencies
    var viewController: NoticeViewControllerProtocol
    
    // MARK: - Private attributes
    private var data: Notice
    private var topicsArray: [String] = []
    private let sectionHeaderTitleArray = ["Tópicos por matéria",
                                           "Redação",
                                           "Mais informações",
                                           " "]
    
    // MARK: - Init methods
    required init(notice: Notice, controller: NoticeViewControllerProtocol) {
        self.data = notice
        self.viewController = controller
        super.init(frame: CGRect.zero)
        initFromNib()
        topicsArray = setupTopicsArrayKeys()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFromNib() {
        if let nib = Bundle.main.loadNibNamed("SchoolViewImplementation", owner: self, options: nil),
           let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    // MARK: - Private methods
    
    /**
     
     Método responsável por configurar a TableView.
     
     */
    
    private func setupTableView() {
        testTableView.delegate = self
        testTableView.dataSource = self
    }
    
    /**
     
     Método responsável por referenciar a XIB de uma determinada célula.
     
     - parameters nibName: nome do arquivo XIB da célula
     
     */
    
    private func referenceXib(nibName: String) {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        self.testTableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /**
     
     Método responsável de montar o array de seções a partir dos tópicos da prova.
     
     */
    private func setupTopicsArrayKeys() -> [String]{
        var resultArray: [String] = []
        
        for topic in data.topics {
            let key = topic.key
            
            if !resultArray.contains(key) {
                resultArray.append(key)
            }
        }
        
        return resultArray
    }
}

// MARK: - Extension Table View Data Source Methods
extension NoticeViewImplementation: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section{
        case 0: // tópicos por matéria
            numberOfRows = topicsArray.count
        case 1: // redação
            numberOfRows = 1
        case 2: // mais informações
            numberOfRows = 1
        case 3: // duração da prova
            numberOfRows = 1
        default:
            numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitleArray[section] as String
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoticeTopicTableViewCell"
        referenceXib(nibName: cellIdentifier)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NoticeTopicTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NoticeTopicTableViewCell.")
        }
        
        cell.durationLabel.isHidden = true
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 { // topicos por matéria
            let topic = topicsArray[indexPath.row]
            cell.titleLabel.text = topic
            cell.selectionStyle = .gray
            
        } else if indexPath.section == 1 { // redação
            cell.titleLabel.text = "Informações sobre a redação"
            cell.selectionStyle = .gray
            
        } else if indexPath.section == 2 { // mais informações
            cell.titleLabel.text = "Edital completo"
            cell.selectionStyle = .gray
            
        } else if indexPath.section == 3 { // duração da prova
            cell.accessoryType = .none
            cell.durationLabel.isHidden = false
            cell.titleLabel.text = "Duração da prova"
            cell.durationLabel.text = "\(data.durationTime) horas"
            cell.selectionStyle = .none
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0: // topicos
            let topic = topicsArray[indexPath.row]
            if let subTopicsArray = data.topics[topic],
               let numberOfQuestions = data.numberOfQuestionsPerTopic[topic] {
                viewController.topicWasSubmitted(subTopicsArray,
                                                 numberOfQuestions,
                                                 topic)
            }
            
        case 1: // redação
            viewController.essayWasSubmitted(data.essay)
        case 2: // mais informações
            viewController.moreInformationWasSubmitted(data.linkNotice)
        default:
            print("Other cell was selected")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.init(red: 242/255,
                                                          green: 242/255,
                                                          blue: 247/255,
                                                          alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16.0
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(red: 242/255,
                                            green: 242/255,
                                            blue: 247/255,
                                            alpha: 1.0)
    }
}

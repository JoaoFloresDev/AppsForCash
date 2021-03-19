//
//  NoticeInfoViewImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 26/10/20.
//

import Foundation
import UIKit

class NoticeInfoViewImplementation: UIView, NoticeInfoViewProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - Dependencies
    var viewController: NoticeInfoViewControllerProtocol
    
    // MARK: - Private attributes
    private var topic: [String]?
    private var numberOfQuestions: Int?
    private var nameOfThetopic: String?
    private var essay: [String : String]?
    private var isTopicInformationsView: Bool = false
    private var sectionHeaderTitleArray: [String] = []
    
    // MARK: - Init methods
    required init(_ topic: [String]?, _ numberOfQuestions: Int?, _ nameOfThetopic: String?,_ essay: [String : String]?, controller: NoticeInfoViewControllerProtocol) {
        self.topic = topic
        self.numberOfQuestions = numberOfQuestions
        self.nameOfThetopic = nameOfThetopic
        self.essay = essay
        self.viewController = controller
        super.init(frame: CGRect.zero)
        initFromNib()
        isTopicInformationsView = determineTypeOfView(topic, numberOfQuestions, essay)
        setNavigationtitle()
        setupSectionHeaderTitleArray()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFromNib() {
        if let nib = Bundle.main.loadNibNamed("NoticeInfoViewImplementation", owner: self, options: nil),
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
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    /**
     
     Método responsável por referenciar a XIB de uma determinada célula.
     
     - parameters nibName: nome do arquivo XIB da célula
     
     */
    
    private func referenceXib(nibName: String) {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        self.myTableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /**
     
     Método se determina se a tela está em um tópico ou na redação.
     
     - parameter topic: um vetor com o que cai em um determinado tópico
     - parameter numberOfQuestions: número de questões de um tópico
     - parameter essay: um dicionário com as informações da redação
     
     */
    
    private func determineTypeOfView(_ topic: [String]?, _ numberOfQuestions: Int?, _ essay: [String : String]?) -> Bool {
        var res = false
        
        if topic != nil && numberOfQuestions != nil && essay == nil {
            res = true
        } else {
            res = false
        }
        
        return res
    }
    
    /**
     
     Método responsável de montar o array de seções a partir dos dados que vierem da view do edital.
     
     */
    
    private func setupSectionHeaderTitleArray() {
        if isTopicInformationsView{
            sectionHeaderTitleArray = ["Número de questões",
                                       "Conteúdo programado"]
        } else {
            sectionHeaderTitleArray = setupEssayKeys()
        }
        
    }
    
    /**
     
     Método responsável de montar o array de seções a partir da estrutura de uma redação
     
     */
    private func setupEssayKeys() -> [String]{
        
        guard let essay = self.essay else { return [""]}
        
        var resultArray: [String] = []
        for topic in essay {
            let key = topic.key
            
            if !resultArray.contains(key) {
                resultArray.append(key)
            }
        }
        
        return resultArray
    }
    
    /**
     
     Método responsável de definir o title da View na NavigationBar
     
     */
    private func setNavigationtitle() {
        if let viewController = self.viewController as? UIViewController {
            if isTopicInformationsView {
                guard let nameOfThetopic = self.nameOfThetopic else {return}
                viewController.navigationItem.title = "\(nameOfThetopic)"
            } else {
                viewController.navigationItem.title = "Redação"
            }
        }
    }
}

// MARK: - Extension Table View Data Source Methods
extension NoticeInfoViewImplementation: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if isTopicInformationsView {
            switch section {
            case 0: // número de questões
                numberOfRows = 1
            case 1: // conteúdo programado
                guard let topic = self.topic else { return 0 }
                numberOfRows = topic.count
            default:
                numberOfRows = 0
            }
            
        } else {
            numberOfRows = 1 
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitleArray[section] as String
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        if isTopicInformationsView {
            switch indexPath.section {
            case 0: // número de questões
                guard let numberOfQuestions = self.numberOfQuestions else { return cell }
                guard let nameOfThetopic = self.nameOfThetopic else { return cell }

                cell.textLabel?.text = "A prova contém \(String(describing: numberOfQuestions)) questões de \(nameOfThetopic)"
            case 1: // conteúdo programado
                guard let topic = self.topic else { return cell }
                cell.textLabel?.text = topic[indexPath.row]
            default:
                break
            }
            
        } else {
            guard let essay = self.essay else { return cell }
            cell.textLabel?.text = essay[sectionHeaderTitleArray[indexPath.section]]
        }
        
        return cell
    }
}

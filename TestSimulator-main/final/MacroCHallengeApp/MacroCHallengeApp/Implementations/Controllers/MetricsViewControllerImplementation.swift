//
//  MetricsViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import UIKit
import SwiftyJSON

class MetricsViewControllerImplementation: UIViewController, MetricsViewControllerProtocol {
    // MARK: - Dependencies
    /*
     
     Nota: como este View Controller é um item da tab bar a ser instanciado no Storyboard, ele é o único que possuirá
     dependências opcionais que não são a sua view. Para contornarmos isso, existem métodos de setup que são responsáveis
     por popular essas variáveis com suas implementações padrões. Para os demais controllers, as implementações padrões de
     suas dependências (exceto pela view) são passadas em seu inicializador (veja o método schoolWasSubmitted, por exemplo).
     
     */
    var myView: MetricsViewProtocol?
    var metrics: MetricsProtocol?
    
    // MARK: - Lifecycle methods
    override func loadView() {
        super.loadView()
        setupDefaultMetricsImplementation()
        setupDefaultViewImplementation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Métricas Gerais"
    }
    
    // MARK: - Setup methods
    private func setupDefaultMetricsImplementation() {
        self.metrics = MockMetricsImplementation()
    }
    
    private func setupDefaultViewImplementation() {
        if let generalResults = metrics?.getGeneralResults(), let topicsResults = metrics?.getTopicsResults(){
            let defaultView = MetricsViewImplementation(generalResults: generalResults, topicsResults: topicsResults, controller: self)
            self.myView = defaultView
            self.view = defaultView
        }
    }
}

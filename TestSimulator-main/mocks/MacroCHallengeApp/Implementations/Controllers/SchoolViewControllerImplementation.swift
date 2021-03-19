//
//  SchoolViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import UIKit

class SchoolViewControllerImplementation: UIViewController, SchoolViewControllerProtocol {
    // MARK: - Dependencies
    var myView: SchoolViewProtocol?
    
    // MARK: - Private attributes
    private var data: School
    
    // MARK: - Init methods
    required init(data: School) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func loadView() {
        super.loadView()
        setupDefaultView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = data.name
    }
    
    // MARK: - Setup methods
    private func setupDefaultView() {
        let defaultView = SchoolViewImplementation(data: self.data, controller: self)
        self.myView = defaultView
        self.view = defaultView
    }
    
    // MARK: - SchoolViewControllerProtocol methods
    func testWasSubmitted(_ test: Test) {
        if let navController = self.navigationController {
            let overviewViewController = OverviewViewControllerImplementation(data: test)
            navController.pushViewController(overviewViewController, animated: true)
        }
    }
    
    func noticeWasSubmitted(_ notice: Notice) {
        if let navController = self.navigationController {
            let overviewViewController = NoticeViewControllerImplementation(data: notice)
            navController.pushViewController(overviewViewController, animated: true)
        }
    }
}

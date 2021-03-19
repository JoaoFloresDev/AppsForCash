//
//  NoticeInfoViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 26/10/20.
//

import Foundation
import UIKit

class NoticeInfoViewControllerImplementation: UIViewController, NoticeInfoViewControllerProtocol {
    // MARK: - Dependencies
    var myView: NoticeInfoViewProtocol?
    
    // MARK: - Private attributes
    private var topic: [String]?
    private var numberOfQuestions: Int?
    private var nameOfThetopic: String?
    private var essay: [String : String]?
    
    // MARK: - Init methods
    required init(_ topic: [String]?, _ numberOfQuestions: Int?, _ nameOfThetopic: String? ,_ essay: [String : String]?) {
        self.topic = topic
        self.numberOfQuestions = numberOfQuestions
        self.nameOfThetopic = nameOfThetopic
        self.essay = essay
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
    }
    
    // MARK: - Setup methods
    private func setupDefaultView() {
        let defaultView = NoticeInfoViewImplementation(self.topic,
                                                       self.numberOfQuestions,
                                                       self.nameOfThetopic,
                                                       self.essay,
                                                       controller: self)
        self.myView = defaultView
        self.view = defaultView
    }
}

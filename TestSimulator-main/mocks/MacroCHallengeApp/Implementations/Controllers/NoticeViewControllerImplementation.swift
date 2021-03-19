//
//  NoticeViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 22/10/20.
//

import Foundation
import UIKit
import SafariServices

class NoticeViewControllerImplementation: UIViewController, NoticeViewControllerProtocol {
    
    // MARK: - Dependencies
    var myView: NoticeViewProtocol?
    
    // MARK: - Private attributes
    private var data: Notice
    
    // MARK: - Init methods
    required init(data: Notice) {
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
    }
    
    // MARK: - Setup methods
    private func setupDefaultView() {
        let defaultView = NoticeViewImplementation(notice: self.data, controller: self)
        self.myView = defaultView
        self.view = defaultView
    }
    
    // MARK: - NoticeViewControllerProtocol methods
    
    func topicWasSubmitted(_ topic: [String], _ numberOfQuestions: Int, _ nameOfThetopic: String) {
        if let navController = self.navigationController {
            let noticeInfoViewController = NoticeInfoViewControllerImplementation(topic, numberOfQuestions, nameOfThetopic, nil)
            navController.pushViewController(noticeInfoViewController, animated: true)
        }
    }
    
    func essayWasSubmitted(_ essay: [String : String]) {
        if let navController = self.navigationController {
            let noticeInfoViewController = NoticeInfoViewControllerImplementation(nil, nil, nil, essay)
            navController.pushViewController(noticeInfoViewController, animated: true)
        }
    }
    
    func moreInformationWasSubmitted(_ linkNotice: String) {
        if let url = URL(string: linkNotice) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}

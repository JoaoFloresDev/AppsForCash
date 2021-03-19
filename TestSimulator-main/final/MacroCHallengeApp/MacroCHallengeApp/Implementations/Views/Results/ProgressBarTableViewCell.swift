//
//  ProgressBarTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 14/10/20.
//

import UIKit

class ProgressBarTableViewCell: UITableViewCell {
    
    // MARK: -IBOutlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var finalGradeLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    // MARK: - Private attributes
    private var topic = String()
    private var numberOfRightAnswers: Int = 0
    private var totalNumberOfQuestions: Int = 0
    private var percentage: Double = 0.0
    
    // MARK: -Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    
    func updateView(topic: String, numberOfRightAnswers: Int, totalNumberOfQuestions: Int, percetage: Double){
        self.topic = topic
        self.numberOfRightAnswers = numberOfRightAnswers
        self.totalNumberOfQuestions = totalNumberOfQuestions
        self.percentage = percetage
        
        settingCornerRadiusOnView(view: barView)
        setProgress()
        settingTextLabels()
    }
    
    // MARK: - Private Methods
    
    /**
     
     Método responsável por acrescentar corner radius em uma view.
     
     - parameters view: view no qual será acrescentado corner radius.
     
     */
    
    private func settingCornerRadiusOnView(view: UIView) {
        view.layer.cornerRadius = 8
    }
    
    /**
     
     Método responsável por colocar porcetagem na barra de progresso.
     
     */
    
    private func setProgress() {
        
        for view in barView.subviews { // Limpa subviews anteriores
            view.removeFromSuperview()
        }
        
        let currentProgress = UIView(frame: CGRect.zero)
        currentProgress.translatesAutoresizingMaskIntoConstraints = false
        
        
        let topConstraint = NSLayoutConstraint(item: currentProgress,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: barView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: currentProgress,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: barView,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: currentProgress,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: barView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 0)
        let widthConstraint = NSLayoutConstraint(item: currentProgress,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: barView,
                                                 attribute: .width,
                                                 multiplier: CGFloat(percentage) * 0.01,
                                                 constant: 0)
        let heightConstraint = NSLayoutConstraint(item: currentProgress,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: barView,
                                                 attribute: .height,
                                                 multiplier: 1.0,
                                                 constant: 0)
        
        settingCornerRadiusOnView(view: currentProgress)
        currentProgress.backgroundColor = UIColor.init(red: 14/255,
                                                       green: 173/255,
                                                       blue: 0/255,
                                                       alpha: 1.0)
        barView.addSubview(currentProgress)
        barView.addConstraints([topConstraint,
                                        bottomConstraint,
                                        leadingConstraint,
                                        widthConstraint,
                                        heightConstraint])
    }
    
    /**
     
     Método responsável por mudar o texto das labels.
     
     */
    
    private func settingTextLabels() {
        topicLabel.text = topic
        finalGradeLabel.text = "\(numberOfRightAnswers)/\(totalNumberOfQuestions)"
    }
}

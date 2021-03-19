//
//  Question.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 05/10/20.
//

import Foundation
import UIKit

class Question {
    private(set) var number: String
    private(set) var text: String
    private(set) var initialText: String?
    private(set) var images: [UIImage]?
    private(set) var subtitle: String?
    private(set) var options: [String:String]
    private(set) var answer: String
    private(set) var topic: String
	private(set) var imagesURL: [String]?
    
    init(number: String, text: String, initialText: String?, images: [UIImage]?, subtitle: String?, options: [String : String], answer: String, topic: String) {
        self.number = number
        self.text = text
        self.initialText = initialText
        self.images = images
        self.subtitle = subtitle
        self.options = options
        self.answer = answer
        self.topic = topic
    }

	func updateImagesURL(imagesURL: [String]) {
		self.imagesURL = imagesURL
	}
    
}

//
//  AddNoteViewController.swift
//  App
//
//  Created by Pietro Pugliesi on 11/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol AddNoteVCDelegate {
    func didFinishEditingNote(_ note: String?)
}

class AddNoteViewController: UIViewController {

	@IBOutlet var textField: UITextField!
    
    var delegate: AddNoteVCDelegate?
    var note: String?
    
	override func viewDidLoad() {
        super.viewDidLoad()

		textField.delegate = self
        textField.text = note
    }
	
	@IBAction func NoteDescriptionEnded(_ sender: Any) {
		
	}
	
	@IBAction func cancelTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveTapped(_ sender: Any) {
        delegate?.didFinishEditingNote(textField.text)
		self.dismiss(animated: true, completion: nil)
	}
}

extension AddNoteViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

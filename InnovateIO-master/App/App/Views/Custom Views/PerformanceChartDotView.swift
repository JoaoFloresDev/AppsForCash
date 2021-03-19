//
//  PerformanceChartDotView.swift
//  App
//
//  Created by Pietro Pugliesi on 02/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class PerformanceChartDotView: UIView {
	
	var contentView : UIView?
	
	var color:UIColor?{
		didSet{
			self.backgroundColor = color
			self.contentView?.backgroundColor = color
		}
	}
	
	@IBInspectable var qualityText:String?{
		didSet{
			qualityLabel.text = qualityText
		}
	}
	
	@IBInspectable var cornerRadius:CGFloat = 0{
		didSet{
			layer.cornerRadius = cornerRadius
			layer.masksToBounds = true
		}
	}
	
	@IBOutlet var qualityLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		xibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}
	
	func activate(){
		self.alpha = 1
	}
	func deactivate(){
		self.alpha = 0
	}
	
	func xibSetup() {
		contentView = loadViewFromNib()
		
		// use bounds not frame or it'll be offset
		contentView!.frame = bounds
		
		// Make the view stretch with containing view
		contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
		
		// Adding custom subview on top of our view (over any custom drawing > see note below)
		
		addSubview(contentView!)
		
	}
	
	func loadViewFromNib() -> UIView! {
		
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
		
		return view
	}
}

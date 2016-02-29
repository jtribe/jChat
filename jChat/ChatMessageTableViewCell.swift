//
//  ChatMessageTableViewCell.swift
//  jChat
//
//  Created by Ben on 24/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
	
	@IBOutlet weak var chatLabel: InsetLabel?
	@IBOutlet weak var leadingConstraint: NSLayoutConstraint?
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint?
	@IBOutlet weak var widthConstraint: NSLayoutConstraint?
	
	func setIncoming(incoming: Bool) {
		if incoming {
			leadingConstraint?.priority = UILayoutPriorityDefaultHigh
			trailingConstraint?.priority = UILayoutPriorityDefaultLow
			widthConstraint?.constant = UIScreen.mainScreen().bounds.size.width-Buffer.ScreenEdge.rawValue
			chatLabel?.textAlignment = .Left
			
			//layoutIfNeeded()
			
			paint(isIncoming: true)
		} else {
			leadingConstraint?.priority = UILayoutPriorityDefaultLow
			trailingConstraint?.priority = UILayoutPriorityDefaultHigh
			widthConstraint?.constant = UIScreen.mainScreen().bounds.size.width-Buffer.ScreenEdge.rawValue
			chatLabel?.textAlignment = .Right
			
			//layoutIfNeeded()
			
			paint(isIncoming: false)
		}
	}
	
	private func paint(isIncoming incoming: Bool) {
		chatLabel?.backgroundColor = incoming ? UIColor(hex: "#eeeeee") : UIColor(hex: "#0061e6")
		chatLabel?.textColor = incoming ? .blackColor() : .whiteColor()
		chatLabel?.layer.cornerRadius = 12.0
		chatLabel?.layer.masksToBounds = true
	}
	
}

enum Buffer: CGFloat {
	case ScreenEdge = 40.0
}

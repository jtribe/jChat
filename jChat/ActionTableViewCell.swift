//
//  ActionTableViewCell.swift
//  jChat
//
//  Created by Mark Robinson on 23/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit
import SwiftFlow

class ActionTableViewCell: UITableViewCell {

	@IBOutlet weak var stateView: UIView!
	@IBOutlet weak var actionTitle: UILabel!
	@IBOutlet weak var payloadLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func setUpWithAction<T: Action where T : StatefulAction>(action: T) {
		actionTitle.text = action.name
		switch action.actionState {
		case .InProgress:
			stateView.backgroundColor = UIColor.yellowColor()
			payloadLabel.text = " "
		case .Success(let result):
			stateView.backgroundColor = UIColor.greenColor()
			payloadLabel.text = "\(result)"
		case .Error(let error):
			stateView.backgroundColor = UIColor.redColor()
			payloadLabel.text = "\(error)"
		}
	}
	
}

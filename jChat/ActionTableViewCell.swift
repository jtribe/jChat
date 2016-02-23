//
//  ActionTableViewCell.swift
//  jChat
//
//  Created by Mark Robinson on 23/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit
import SwiftFlow
import Colours

class ActionTableViewCell: UITableViewCell {

	@IBOutlet weak var stateView: UIView!
	@IBOutlet weak var actionTitle: UILabel!
	@IBOutlet weak var payloadLabel: UILabel!
	
	func setUpWithAction<T: Action where T : StatefulAction>(action: T) {
		actionTitle.text = action.name
		switch action.actionState {
		case .InProgress:
			stateView.backgroundColor = UIColor.mandarinColor()
			payloadLabel.text = " "
		case .Success(let result):
			stateView.backgroundColor = UIColor.successColor()
			payloadLabel.text = "\(result)"
		case .Error(let error):
			stateView.backgroundColor = UIColor.dangerColor()
			payloadLabel.text = "\(error)"
		}
	}
	
}

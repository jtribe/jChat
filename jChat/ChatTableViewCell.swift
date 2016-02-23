//
//  AssociatedObject.swift
//  jChat
//
//  Created by Ben on 23/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation
import UIKit

class ChatTableViewCell: UITableViewCell {
//	override func layoutSubviews() {
//		//super.layoutSubviews()
//		
//	}
	
	func setChatText(text: String) {
		textLabel?.text = text
		textLabel?.sizeToFit()
	}
}

//
//  ChatService.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation
import PromiseKit

protocol ChatInterface {
	func postMessageToChatroom(message: String) -> Promise<NSData>
}

struct ChatService : ChatInterface {
	
	func postMessageToChatroom(message: String) -> Promise<NSData> {
		return Promise(NSData())
	}
	
}
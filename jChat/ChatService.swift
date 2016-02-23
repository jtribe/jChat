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
	func postMessageToChatroom(chatMessage: ChatMessage) -> Promise<NSData>
}

struct ChatService : ChatInterface {
	
	func postMessageToChatroom(chatMessage: ChatMessage) -> Promise<NSData> {
		return Promise(NSData())
	}
	
}
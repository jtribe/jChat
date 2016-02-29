//
//  ChatActions.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftyJSON

struct ChatActions {
	
	static func postMessageToChatroom(message: String, isIncoming: Bool) -> AsyncActionCreator {
		return { _, store, dispatchCallback in
			(store as! MainStore<AppState>).dispatch(PostMessageToChatroomAction(actionState: .InProgress))
			
			let chatMessage = ChatMessage(messageText: message, isIncoming: isIncoming)
			
			Registry.instance.chatService.postMessageToChatroom(chatMessage).then { _ in
				dispatchCallback(postMessageSuccess(chatMessage))
			}.error { error in
				dispatchCallback(postMessageError(error))
			}
		}
	}
	
	private static func postMessageSuccess(chatMessage: ChatMessage) -> ActionCreator {
		return { _, _ in
			PostMessageToChatroomAction(actionState: .Success(chatMessage))
		}
	}
	
	private static func postMessageError(error: ErrorType) -> ActionCreator {
		return { _, _ in
			PostMessageToChatroomAction(actionState: .Error(error))
		}
	}
}

protocol StatefulAction : Action {
	typealias T
	var actionState: ActionState<T> { get }
	var name: String { get }
}

struct ChatMessage {
	var messageText: String
	var isIncoming: Bool
	
	init(messageText: String, isIncoming: Bool) {
		self.messageText = messageText
		self.isIncoming = isIncoming
	}
}

struct PostMessageToChatroomAction: Action, StatefulAction {
	let actionState: ActionState<ChatMessage>
	let name = "PostMessageToChatroomAction"
	
	init(actionState: ActionState<ChatMessage>) {
		self.actionState = actionState
	}
}

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
	
	static func postMessageToChatroom(message: String) -> AsyncActionCreator {
		return { _, store, dispatchCallback in
			(store as! MainStore<AppState>).dispatch(PostMessageToChatroomAction(actionState: .InProgress))
			
			Registry.instance.chatService.postMessageToChatroom(message).then { _ in
				dispatchCallback(postMessageSuccess(message))
			}.error { error in
				dispatchCallback(postMessageError(error))
			}
		}
	}
	
	private static func postMessageSuccess(message: String) -> ActionCreator {
		return { _, _ in
			PostMessageToChatroomAction(actionState: .Success(message))
		}
	}
	
	private static func postMessageError(error: ErrorType) -> ActionCreator {
		return { _, _ in
			PostMessageToChatroomAction(actionState: .Error(error))
		}
	}
}

struct PostMessageToChatroomAction: Action {
	let actionState: ActionState<String>
	init(actionState: ActionState<String>) {
		self.actionState = actionState
	}
}

//
//  ChatReducer.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation
import SwiftFlow

struct ChatReducer : Reducer {
	
	func handleAction(state: AppState, action: Action) -> AppState {
		switch action {
		case let action as PostMessageToChatroomAction:
			return postMessageToChatroomReducer(state, actionState: action.actionState)
		default: return state
		}
	}
	
	private func postMessageToChatroomReducer(var state: AppState,
		actionState: ActionState<ChatMessage>) -> AppState
	{
		switch actionState {
		case .InProgress: 
			state.isBusy = true
		case .Success(let message):
			state.isBusy = false
			state.messages.append(message)
		case .Error(let error):
			state.isBusy = false
			state.messageError = error
		}
		
		return state
	}
}
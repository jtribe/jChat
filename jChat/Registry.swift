//
//  Registry.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import SwiftFlow

struct RegistryInstance {
	var store = MainStore(reducer: CombinedReducer([ChatReducer()]), state: AppState(), middleware: [ ])
	var chatService: ChatInterface
	
	init(isTestMode: Bool = false) {
		chatService = ChatService()
	}
}

struct Registry {
	static var instance = RegistryInstance()
	static func testReset() {
		instance = RegistryInstance(isTestMode: true)
	}
}
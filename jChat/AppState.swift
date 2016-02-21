//
//  AppState.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation
import SwiftFlow

struct AppState : StateType {
	
	var isBusy = false
	var messages: [String] = [ ]
	var messageError: ErrorType? = nil
	
}

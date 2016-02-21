//
//  ActionState.swift
//  jChat
//
//  Created by Mark Robinson on 19/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import Foundation

enum ActionState<Result> {
	case InProgress
	case Success(Result)
	case Error(ErrorType)
}

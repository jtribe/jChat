//
//  MainStore.swift
//  SwiftFlow
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

/**
 This class is the default implementation of the `Store` protocol. You will use this store in most
 of your applications. You shouldn't need to implement your own store.
 You initialize the store with a reducer and an initial application state. If your app has multiple
 reducers you can combine them by initializng a `MainReducer` with all of your reducers as an
 argument.
 */
public class MainStore<State: StateType>: Store {
	
	public typealias TimeSlice = (state: State, action: Action)
	public var history: [TimeSlice] = [ ] {
		didSet {
			devToolsSubscribers.forEach { $0.newActionHistory(history.map({ $0.action })) }
		}
	}
    var devToolsSubscribers: [DevToolsSubscriber] = [ ]
	
    public func devToolsSubscribe(subscriber: DevToolsSubscriber) {
        guard devToolsSubscribers.indexOf({ $0 === subscriber }) == nil else {
            print("Store subscriber is already added, ignoring.")
            return
        }

        devToolsSubscribers.append(subscriber)
		subscriber.newActionHistory(history.map({ $0.action }))
    }

    public func devToolsUnsubscribe(subscriber: DevToolsSubscriber) {
        let index = devToolsSubscribers.indexOf { return $0 === subscriber }

        if let index = index {
            devToolsSubscribers.removeAtIndex(index)
        }
    }

    public var state: State {
        didSet {
            subscribers.forEach { $0._newState(state) }
        }
    }
	
	private let initialState: State

    public var dispatchFunction: DispatchFunction!

    private var reducer: AnyReducer
    var subscribers: [AnyStoreSubscriber] = []
    private var isDispatching = false

    public required convenience init(reducer: AnyReducer, state: State) {
        self.init(reducer: reducer, state: state, middleware: [])
    }

    public required init(reducer: AnyReducer, state: State, middleware: [Middleware]) {
        self.reducer = reducer
        self.state = state
		initialState = state

        // Wrap the dispatch function with all middlewares
        self.dispatchFunction = middleware.reverse().reduce(self._defaultDispatch) {
            dispatchFunction, middleware in
                return middleware(self.dispatch, { self.state })(dispatchFunction)
        }
    }

    public func subscribe(subscriber: AnyStoreSubscriber) {
        guard subscribers.indexOf({ $0 === subscriber }) == nil else {
            print("Store subscriber is already added, ignoring.")
            return
        }

        subscribers.append(subscriber)
        subscriber._newState(state)
    }

    public func unsubscribe(subscriber: AnyStoreSubscriber) {
        let index = subscribers.indexOf { return $0 === subscriber }

        if let index = index {
            subscribers.removeAtIndex(index)
        }
    }

    public func _defaultDispatch(action: Action) -> Any {
        if isDispatching {
            // Use Obj-C exception since throwing of exceptions can be verified through tests
            NSException.raise("SwiftFlow:IllegalDispatchFromReducer", format: "Reducers may not " +
                "dispatch actions.", arguments: getVaList(["nil"]))
        }

        isDispatching = true
        let newState = self.reducer._handleAction(self.state, action: action)
        isDispatching = false

        self.state = newState as! State

        return action
    }
	
	public func deleteAction(atIndex index: Int) {
		var newHistory = history
		newHistory.removeAtIndex(index)
		state = initialState
		history = [ ]
		
		newHistory.map({ $0.action }).forEach({ action in
			dispatch(action, callback: nil)
		})
	}

    public func dispatch(action: Action) -> Any {
        return dispatch(action, callback: nil)
    }

    public func dispatch(actionCreatorProvider: ActionCreator) -> Any {
        return dispatch(actionCreatorProvider, callback: nil)
    }

    public func dispatch(asyncActionCreatorProvider: AsyncActionCreator) {
        dispatch(asyncActionCreatorProvider, callback: nil)
    }

    public func dispatch(action: Action, callback: DispatchCallback?) -> Any {
		
		history.append(TimeSlice(state, action))
        let returnValue = self.dispatchFunction(action)
        callback?(self.state)

        return returnValue
    }

    public func dispatch(actionCreatorProvider: ActionCreator, callback: DispatchCallback?) -> Any {
        let action = actionCreatorProvider(state: self.state, store: self)
        if let action = action {
            dispatch(action, callback: callback)
        }

        return action
    }

    public func dispatch(actionCreatorProvider: AsyncActionCreator, callback: DispatchCallback?) {
        actionCreatorProvider(state: self.state, store: self) { actionProvider in
            let action = actionProvider(state: self.state, store: self)
            if let action = action {
                self.dispatch(action, callback: callback)
            }
        }
    }

}

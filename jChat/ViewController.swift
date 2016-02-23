//
//  ViewController.swift
//  jChat
//
//  Created by Mark Robinson on 18/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit
import SwiftFlow

class ViewController: UIViewController, StoreSubscriber {
	
	@IBOutlet weak var chatTable: UITableView!
	@IBOutlet weak var messageField: UITextField!
	private var messages: [ChatMessage] {
		return Registry.instance.store.state.messages
	}
	
	private var timer: NSTimer {
		return NSTimer(timeInterval: 1.0, target: self, selector: "adele", userInfo: nil, repeats: false)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.subscribe(self)
		chatTable.rowHeight = UITableViewAutomaticDimension
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		Registry.instance.store.unsubscribe(self)
	}
	
	func newState(state: AppState) {
		chatTable.reloadData()
	}
	
	@objc func adele() {
		let message = "Who is this?"
		
		func clearMessageBox() { messageField.text = "" }
		
		let action = ChatActions.postMessageToChatroom(message, isIncoming: true)
		Registry.instance.store.dispatch(action)
		clearMessageBox()
	}

	@IBAction private func sendMessage() {
		guard let message = messageField.text
			where message.characters.count > 0 else {
				return
		}
		
		func clearMessageBox() { messageField.text = "" }
		
		let action = ChatActions.postMessageToChatroom(message, isIncoming: false)
		Registry.instance.store.dispatch(action)
		NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
		clearMessageBox()
	}
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ChatTableViewCell
		let messageObject = messages[indexPath.row]
		
		cell?.textLabel?.numberOfLines = 0
		cell?.textLabel?.text = messageObject.messageText
		cell?.textLabel?.sizeToFit()
		cell?.textLabel?.setInsets(topInset: 5, left: 5, bottom: 5, right: 5, forRect: cell!.textLabel!.frame)
		cell?.textLabel?.textAlignment = messageObject.isIncoming ? .Left : .Right
		cell?.textLabel?.backgroundColor = messageObject.isIncoming ? .lightGrayColor() : .redColor()
		
		return cell!
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
}
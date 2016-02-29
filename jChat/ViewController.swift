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
	@IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpKeyboardMoveOnTap()
		messageField.delegate = self
	}
	
	private var timer: NSTimer {
		return NSTimer(timeInterval: 1.0, target: self, selector: "adele", userInfo: nil, repeats: false)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.subscribe(self)
		
		navigationItem.title = "HelloChat"
		
		chatTable.rowHeight = UITableViewAutomaticDimension
		chatTable.registerNib(UINib(nibName: "ChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		dismissKeyboard()
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

	func sendMessage() {
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
	
	// MARK: Keyboard Setup
	func setUpKeyboardMoveOnTap() {
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: Selector("keyboardWillShow:"),
			name: UIKeyboardWillShowNotification,
			object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: Selector("keyboardWillHide:"),
			name: UIKeyboardWillHideNotification,
			object: nil);
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
	}
	
	func toggleKeyboard(offset offset: CGFloat = 0) {
		let marginBottom: CGFloat = 20
		messageBottomConstraint.constant = offset + marginBottom
		UIView.animateWithDuration(0.5, animations: { [weak self] in
			self?.view.layoutIfNeeded()
		})
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardHeight = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size.height {
			toggleKeyboard(offset: keyboardHeight)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		toggleKeyboard()
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ChatMessageTableViewCell
		let messageObject = messages[indexPath.row]
		
		cell?.chatLabel?.numberOfLines = 0
		cell?.chatLabel?.text = messageObject.messageText
		cell?.setIncoming(messageObject.isIncoming)
		
		return cell!
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 30
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
}

extension ViewController : UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		guard textField.returnKeyType == .Send else {
			return false
		}
		sendMessage()
		return true
	}
}

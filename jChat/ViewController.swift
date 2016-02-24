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
	var messages: [String] {
		return Registry.instance.store.state.messages
	}
	@IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpKeyboardMoveOnTap()
		messageField.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.subscribe(self)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		dismissKeyboard()
		Registry.instance.store.unsubscribe(self)
	}
	
	func newState(state: AppState) {
		chatTable.reloadData()
	}

	func sendMessage() {
		guard let message = messageField.text
			where message.characters.count > 0 else {
				return
		}
		
		func clearMessageBox() { messageField.text = "" }
		
		let action = ChatActions.postMessageToChatroom(message)
		Registry.instance.store.dispatch(action)
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

extension ViewController : UITableViewDataSource {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		cell.textLabel?.text = messages[indexPath.row]
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
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
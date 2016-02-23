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
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.subscribe(self)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		Registry.instance.store.unsubscribe(self)
	}
	
	func newState(state: AppState) {
		chatTable.reloadData()
	}

	@IBAction func sendMessage() {
		guard let message = messageField.text
			where messageField.text?.characters.count > 0 else {
				return
		}
		
		let action = ChatActions.postMessageToChatroom(message)
		Registry.instance.store.dispatch(action)
		clearMessageBox()
	}
	
	func clearMessageBox() {
		messageField.text = ""
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
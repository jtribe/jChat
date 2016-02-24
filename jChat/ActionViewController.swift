//
//  ActionViewController.swift
//  jChat
//
//  Created by Mark Robinson on 22/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit
import SwiftFlow

class ActionViewController: UIViewController, DevToolsSubscriber {
	
	var actions: [Action] = [ ]
	
	@IBOutlet weak var actionTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.devToolsSubscribe(self)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		Registry.instance.store.devToolsUnsubscribe(self)
	}
	
	func newActionHistory(actions: [Action]) {
		self.actions = actions
		actionTable.reloadData()
	}
	
}

extension ActionViewController : UITableViewDataSource {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		guard let actionCell = cell as? ActionTableViewCell,
			action = actions[indexPath.row] as? PostMessageToChatroomAction else {
			return cell
		}
		
		actionCell.setUpWithAction(action)
		return actionCell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actions.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
		forRowAtIndexPath indexPath: NSIndexPath) {
			
		if editingStyle == .Delete {
			Registry.instance.store.deleteAction(atIndex: indexPath.row)
		}
	}
	
}

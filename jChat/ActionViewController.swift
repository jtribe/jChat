//
//  ActionViewController.swift
//  jChat
//
//  Created by Mark Robinson on 22/02/2016.
//  Copyright © 2016 mrrobinson. All rights reserved.
//

import UIKit
import SwiftFlow

class ActionViewController: UIViewController, StoreSubscriber {
	
	var history: [Action] {
		return Registry.instance.store.history
	}
	
	@IBOutlet weak var actionTable: UITableView!
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Registry.instance.store.subscribe(self)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		Registry.instance.store.unsubscribe(self)
	}
	
	func newState(state: AppState) {
		actionTable.reloadData()
	}
}

extension ActionViewController : UITableViewDataSource {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ActionTableViewCell,
			action = history[indexPath.row] as? PostMessageToChatroomAction else {
				return UITableViewCell()
		}
		
		cell.setUpWithAction(action)
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return history.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
}

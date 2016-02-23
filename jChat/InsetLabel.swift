//
//  M7_InsetLabel.swift
//  Muzik7
//
//  Created by Ben Deckys on 7/11/2015.
//  Copyright (c) 2015 Ben Deckys. All rights reserved.
//

import Foundation
import UIKit

var topInset: CGFloat = 0
var leftInset: CGFloat = 0
var rightInset: CGFloat = 0
var bottomInset: CGFloat = 0

extension UILabel {
	
	func setInsets(topInset top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, forRect rect: CGRect) {
		topInset = top
		leftInset = left
		rightInset = right
		bottomInset = bottom
		
		drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(top, left, bottom, right)))
	}
	
	override public func intrinsicContentSize() -> CGSize {
		var parentSize: CGSize = super.intrinsicContentSize()
		parentSize.width += leftInset+rightInset
		parentSize.height += topInset+bottomInset
		return parentSize
	}
	
	override public func sizeThatFits(size: CGSize) -> CGSize {
		var parentSize: CGSize = super.sizeThatFits(size)
		parentSize.width += leftInset+rightInset
		parentSize.height += topInset+bottomInset
		return parentSize
	}
	
}

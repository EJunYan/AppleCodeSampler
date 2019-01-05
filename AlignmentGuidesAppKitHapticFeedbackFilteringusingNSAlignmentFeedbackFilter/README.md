# AlignmentGuides: AppKit Haptic Feedback Filtering using NSAlignmentFeedbackFilter

Shows how to provide haptic feedback in your app for hardware that supports Force Click. Haptic feedback is useful for many tasks, such as dragging shapes on a canvas. For example, your app could provide haptic feedback to let the user know when the shape is properly aligned. This sample demonstrates how to provide enough information to the system so that extraneous feedback can be suppressed, creating a better user experience.

The feedback filter uses a prepare and commit model. The app will feed the object events so that it can track cursor state. The app will then ask for alignments to be prepared, and when it has chosen one or more alignments it an ask the object to perform feedback for those alignments.

The prepare methods take 3 locations. Feedback should be performed when the item jumps on screen due to alignment, so the filter has to take the previous location and the proposed alignment location. If the filter only took these two though, an item would get "stuck" as soon as it hit a guide -- how would the controller know when to release it? So, it takes a third "default" location which will be used if the item should become un-stuck from the guide as the user drags away.

The prepare methods come in 3 variants. Some alignments only affect the x or y coordinates, and some affect both. As such, for any given movement a controller could have multiple prepared alignments.

Below is a pseudocode controller implementation. Most alignment controllers should boil down to something like this.

``
For every relevant event (tracking loop matching +inputEventMask), or action from gesture recognizer:
	Inform the filter of the current event (-updateWithEvent: or -updateWithPanRecognizer:)
	Store where the item currently is ("previousPoint")
	Move the item by the appropriate delta for the mouse movement - this may be 0.0pt or several pt, depending on image space transformations.
	Store where the item currently is ("defaultPoint")
	Determine the distance you'd like to align the item (for example, 5px up to match a horizontal guide), "alignedPoint"
	If alignment filter says you may move by that distance (-alignmentFeedbackTokenFor[Horizontal|Vertical]MovementInView:previousPoint:alignedPoint:defaultPoint:)
		Perform the feedback (performFeedback:performanceTime:)
	    Move the item to "alignedPoint"
	Else
	    Move the item to "defaultPoint"
``

## Requirements

### Build

Xcode 8.0, macOS 10.12 SDK

### Runtime

macOS 10.11

Copyright (C) 2015 - 2017 Apple Inc. All rights reserved.

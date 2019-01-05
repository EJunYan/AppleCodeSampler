/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    `AlignmentGuidesView` shows how to use `NSAlignmentFeedbackFilter` to align a box to the edges of its container and the container's center.
    
                The sample shows how to feed the filter using both a tracking loop (see `mouseDown()`) and a gesture recognizer (see `panGestureUpdated()`). These two methods feed the filter the latest event information, and then call into the appropriate handler for mouse down/dragged/up.
*/

import Cocoa

class AlignmentGuidesView: DrawingView, NSGestureRecognizerDelegate {
    // MARK: Properties
    
    @IBOutlet weak var eventHandlingButton: NSPopUpButton!
    @IBOutlet weak var useGridButton: NSButton!
    
    let feedbackFilter = NSAlignmentFeedbackFilter()
    
    var boxFrame = NSRect(x: 180, y: 210, width: 200, height: 200)
    var dragOriginOffset = NSPoint.zero
    
    var drawCenterXAsHoldingItem = false
    var drawCenterYAsHoldingItem = false
    
    // MARK: Initialisers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
        Updating the filter using a tracking loop. mouseDown tracks the entire mouse
        drag, updating the alignment filter with each event.
    */
    override func mouseDown(with event: NSEvent) {
        // If we aren't using the tracking loop, bail here.
        guard eventHandlingButton.indexOfSelectedItem == 0 else { return }
        
        let point = convert(event.locationInWindow, from: nil)
        guard handleMouseDown(point) else { return }
        
        feedbackFilter.update(with: event)
        
        let mask: NSEventMask = [NSAlignmentFeedbackFilter.inputEventMask(), .leftMouseUp, .leftMouseDragged]

        window!.trackEvents(matching: mask, timeout: NSEventDurationForever, mode: RunLoopMode.eventTrackingRunLoopMode) { event, stop in
            self.feedbackFilter.update(with: event)
            
            // Store the last frame shown to the user
            let fromFrame = self.boxFrame
            
            // Handle different event types
            switch event.type {
                case .leftMouseUp:
                    self.handleMouseUp()
                    stop.pointee = true
                
                case .leftMouseDragged:
                    let point = self.convert(event.locationInWindow, from: nil)
                    self.handleMouseDragged(point)
                
                default: ()
            }
            
            /*
                Now perform alignment. It's important to do this for every event
                so that periodic events can cause alignment to happen (consider 
                case of fast-moving cursor stopping over a guide).
            */
            self.boxFrame = self.performAlignment(fromFrame, draggedTo: self.boxFrame)
            
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    /**
        Updating the filter using a pan gesture recognizer. `panGestureUpdated`
        updates the alignment filter for each movement.
    */
    @objc func gestureRecognizerShouldBegin(_ recognizer: NSGestureRecognizer) -> Bool {
        /*
            If we aren't using the gesture recogniaed, bail here since `mouseDown()` 
            will handle it.
        */
        guard eventHandlingButton.indexOfSelectedItem == 1 else { return false }
        
        let locationInView = recognizer.location(in: self)
        
        // Return whether or not a draggable object was clicked.
        return handleMouseDown(locationInView)
    }
    
    @IBAction func magnificationChanged(_ slider: NSSlider) {
        enclosingScrollView!.magnification = CGFloat(slider.doubleValue)
    }
    
    @IBAction func panGestureUpdated(_ recognizer: NSPanGestureRecognizer) {
        // Store the last frame shown to the user
        let fromFrame = boxFrame
        
        switch recognizer.state {
            case .began:
                feedbackFilter.update(withPanRecognizer: recognizer)
            
            case .changed:
                feedbackFilter.update(withPanRecognizer: recognizer)
                handleMouseDragged(recognizer.location(in: self))
            
            case .ended, .cancelled:
                handleMouseUp()
            
            default: ()
        }
        
        /*
            Now perform alignment. It's important to do this for every action so
            that periodic events can cause alignment to happen (consider case 
            of fast-moving cursor stopping over a guide).
        */
        boxFrame = performAlignment(fromFrame, draggedTo:boxFrame)
        
        setNeedsDisplay(bounds)
    }
    
    // MARK: Mouse Down / Dragged / Up Handling.
    
    /*
        On drag update where the item would be without any alignment (its offset), 
        and then call into `performAlignment`.
    */
    
    /// Generic handler for starting drag. Returns whether or not a draggable object was clicked
    func handleMouseDown(_ location: NSPoint) -> Bool {
        dragOriginOffset = NSPoint(x: location.x - boxFrame.origin.x, y: location.y - boxFrame.origin.y)
        
        if !NSPointInRect(location, boxFrame) {
            return false
        }
        
        // Start a drag.
        return true
    }
    
    /// Generic handler for moving a drag
    func handleMouseDragged(_ location: NSPoint) {
        boxFrame.origin = NSPoint(x: location.x - dragOriginOffset.x, y: location.y - dragOriginOffset.y)

        boxFrame = constrainRectToBounds(boxFrame)
        
        if useGridButton.state == NSOnState {
            boxFrame.origin.x = round(boxFrame.origin.x / 10.0) * 10.0
            boxFrame.origin.y = round(boxFrame.origin.y / 10.0) * 10.0
        }
        
        let visibleRect = NSRect(x: location.x, y: location.y, width: 1.0, height: 1.0)
        
        scrollToVisible(visibleRect)
    }
    
    /// Generic handler for stopping a drag.
    func handleMouseUp() { }
    
    func performAlignment(_ movedFrom: NSRect, draggedTo: NSRect) -> NSRect {
        var newRect = draggedTo
        
        // Align the edges of the box to the edges of the container.
        var preparedAlignments = [NSAlignmentFeedbackToken]()
        
        if let token = feedbackFilter.alignmentFeedbackTokenForHorizontalMovement(in: self, previousX: movedFrom.minX, alignedX: 0.0, defaultX: draggedTo.minX) {
            newRect.origin.x = 0.0

            preparedAlignments += [token]
        }
        
        if let token = feedbackFilter.alignmentFeedbackTokenForHorizontalMovement(in: self, previousX: movedFrom.maxX, alignedX: bounds.width, defaultX: draggedTo.maxX) {
            newRect.origin.x = bounds.width - newRect.width

            preparedAlignments += [token]
        }
        
        if let token = feedbackFilter.alignmentFeedbackTokenForVerticalMovement(in: self, previousY: movedFrom.minY, alignedY: 0.0, defaultY: draggedTo.minY) {
            newRect.origin.y = 0.0

            preparedAlignments += [token]
        }
        
        if let token = feedbackFilter.alignmentFeedbackTokenForVerticalMovement(in: self, previousY: movedFrom.maxY, alignedY: bounds.height, defaultY: draggedTo.maxY) {
            newRect.origin.y = bounds.height - newRect.height

            preparedAlignments += [token]
        }
        
        // Align the centers of the box to the centers of the container.
        
        if let token = feedbackFilter.alignmentFeedbackTokenForHorizontalMovement(in: self, previousX: movedFrom.midX, alignedX: bounds.midX, defaultX: draggedTo.midX) {
            newRect.origin.x = bounds.midX - newRect.width / 2.0

            drawCenterXAsHoldingItem = true

            preparedAlignments += [token]
        }
        else {
            drawCenterXAsHoldingItem = false
        }
        
        if let token = feedbackFilter.alignmentFeedbackTokenForVerticalMovement(in: self, previousY: movedFrom.midY, alignedY: bounds.midY, defaultY: draggedTo.midY) {
            newRect.origin.y = bounds.midY - newRect.size.height / 2.0
            drawCenterYAsHoldingItem = true

            preparedAlignments += [token]
        }
        else {
            drawCenterYAsHoldingItem = false
        }
        
        feedbackFilter.performFeedback(preparedAlignments, performanceTime: .drawCompleted)
        
        return newRect
    }
    
    override func draw(_ dirtyRect: NSRect) {
        /*
            Your app can draw however it wants. The box could be a subview, or 
            anything really. Here we're drawing using bezier paths.
        */
        super.draw(dirtyRect)
        
        drawHorizontalGuide(bounds.midY, holdingItem: drawCenterYAsHoldingItem)
        drawVerticalGuide(bounds.midX, holdingItem: drawCenterXAsHoldingItem)

        drawBox(boxFrame, drawCenterAlignmentGuides: true)
    }
}

/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	AlignmentGuidesView shows how to use NSAlignmentFeedbackFilter to align a box to the edges of its container and the container's center.
	
	            The sample shows how to feed the filter using both a tracking loop (see mouseDown) and a gesture recognizer (see panGestureUpdated). These two methods feed the filter the latest event information, and then call into the appropriate handler for mouse down/dragged/up.
*/

#import "AAPLAlignmentGuidesView.h"

@implementation AAPLAlignmentGuidesView

- (id)initWithCoder:(nonnull NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        self.feedbackFilter = [NSAlignmentFeedbackFilter new];
        self.boxFrame = NSMakeRect(180.0, 210.0, 200.0, 200.0);
        
        self.dragOriginOffset = NSZeroPoint;
        
        self.drawCenterXAsHoldingItem = NO;
        self.drawCenterYAsHoldingItem = NO;
    }
    
    return self;
}

// *** Updating the filter using a tracking loop. mouseDown tracks the entire mouse drag, updating the alignment filter with each event.

- (void)mouseDown:(nonnull NSEvent *)theEvent {
    if (self.eventHandlingButton.indexOfSelectedItem != 0) {
        return;
    }
    
    if (![self handleMouseDown:[self convertPoint:theEvent.locationInWindow fromView:nil]]) {
        return;
    }
    
    [self.feedbackFilter updateWithEvent:theEvent];
    
    const NSEventMask mask = [NSAlignmentFeedbackFilter inputEventMask]|NSEventMaskLeftMouseUp;

    [self.window trackEventsMatchingMask:mask timeout:NSEventDurationForever mode:NSEventTrackingRunLoopMode handler:^(NSEvent *event, BOOL *stop) {
        [self.feedbackFilter updateWithEvent:event];
        
        NSRect fromFrame = self.boxFrame;
        
        switch (event.type) {
            case NSEventTypeLeftMouseUp:
                [self handleMouseUp];
                (*stop) = YES;
                break;
            case NSEventTypeLeftMouseDragged:
                [self handleMouseDragged:[self convertPoint:event.locationInWindow fromView:nil]];
                break;
            default:
                break;
        }
        
        self.boxFrame = [self performAlignmentFrom:fromFrame draggedTo:self.boxFrame];
        [self setNeedsDisplay:YES];
    }];
}

// *** Updating the filter using a pan gesture recognizer. panGestureUpdated updates the alignment filter for each movement.

- (BOOL)gestureRecognizerShouldBegin:(NSGestureRecognizer *)recognizer {
    // If we aren't using the gesture recognizer, bail here since mouseDown will handle it.
    if ([self.eventHandlingButton indexOfSelectedItem] != 1) {
        return NO;
    }
    
    // Return whether or not a draggable object was clicked
    return [self handleMouseDown:[recognizer locationInView:self]];
}

- (IBAction)magnificationChanged:(NSSlider *)slider {
    self.enclosingScrollView.magnification = slider.doubleValue;
}

- (IBAction)panGestureUpdated:(NSPanGestureRecognizer *)recognizer {
    // Store the last frame shown to the user
    NSRect fromFrame = self.boxFrame;
    
    switch (recognizer.state) {
        case NSGestureRecognizerStateBegan:
            [self.feedbackFilter updateWithPanRecognizer:recognizer];
            break;
        
        case NSGestureRecognizerStateChanged:
            [self.feedbackFilter updateWithPanRecognizer:recognizer];
            [self handleMouseDragged:[recognizer locationInView:self]];
            break;

        case NSGestureRecognizerStateEnded:
        case NSGestureRecognizerStateCancelled:
            [self handleMouseUp];
            break;

        default:
            break;
    }
    
    // Now perform alignment
    // It's important to do this for every action so that periodic events can cause alignment to happen (consider case of fast-moving cursor stopping over a guide)
    self.boxFrame = [self performAlignmentFrom:fromFrame draggedTo:self.boxFrame];
    
    [self setNeedsDisplay:YES];
}

// *** Mouse down/dragged/up handling. On drag update where the item would be without any alignment (its offset), and then call into performAlignment.

// Generic handler for starting drag. Returns whether or not a draggable object was clicked
- (BOOL)handleMouseDown:(NSPoint)location {
    self.dragOriginOffset = NSMakePoint(location.x-self.boxFrame.origin.x, location.y-self.boxFrame.origin.y);
    
    if (!NSPointInRect(location, self.boxFrame)) {
        return NO;
    }
    
    // Start a drag
    return YES;
}

// Generic handler for moving a drag
- (void)handleMouseDragged:(NSPoint)location {
    self.boxFrame = NSMakeRect(location.x-self.dragOriginOffset.x, location.y-self.dragOriginOffset.y, self.boxFrame.size.width, self.boxFrame.size.height);
    self.boxFrame = [self constrainRectToBounds:self.boxFrame];
    
    if (self.useGridButton.state == NSOnState) {
        NSPoint origin;
        origin.x = round(self.boxFrame.origin.x/10.0) * 10.0;
        origin.y = round(self.boxFrame.origin.y/10.0) * 10.0;
        self.boxFrame = NSMakeRect(origin.x, origin.y, self.boxFrame.size.width, self.boxFrame.size.height);
    }
    
    [self scrollRectToVisible:NSMakeRect(location.x, location.y, 1.0, 1.0)];
}

// Generic handler for stopping a drag
- (void)handleMouseUp { }

- (NSRect)performAlignmentFrom:(NSRect)movedFrom draggedTo:(NSRect)draggedTo {
    NSRect newRect = draggedTo;
    
    // *** Align the edges of the box to the edges of the container
    
    NSMutableArray<id<NSAlignmentFeedbackToken>> *preparedAlignments = [NSMutableArray array];
    id<NSAlignmentFeedbackToken> token;
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForHorizontalMovementInView:self previousX:NSMinX(movedFrom) alignedX:0.0 defaultX:NSMinX(draggedTo)])) {
        newRect.origin.x = 0.0;
        [preparedAlignments addObject:token];
    }
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForHorizontalMovementInView:self previousX:NSMaxX(movedFrom) alignedX:self.bounds.size.width defaultX:NSMaxX(draggedTo)])) {
        newRect.origin.x = self.bounds.size.width-newRect.size.width;
        [preparedAlignments addObject:token];
    }
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForVerticalMovementInView:self previousY:NSMinY(movedFrom) alignedY:0.0 defaultY:NSMinY(draggedTo)])) {
        newRect.origin.y = 0.0;
        [preparedAlignments addObject:token];
    }
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForVerticalMovementInView:self previousY:NSMaxY(movedFrom) alignedY:self.bounds.size.height defaultY:NSMaxY(draggedTo)])) {
        newRect.origin.y = self.bounds.size.height-newRect.size.height;
        [preparedAlignments addObject:token];
    }
    
    // *** Align the centers of the box to the centers of the container
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForHorizontalMovementInView:self previousX:NSMidX(movedFrom) alignedX:NSMidX(self.bounds) defaultX:NSMidX(draggedTo)])) {
        newRect.origin.x = NSMidX(self.bounds)-newRect.size.width/2.0;
        [preparedAlignments addObject:token];
        self.drawCenterXAsHoldingItem = YES;
    }
    else {
        self.drawCenterXAsHoldingItem = NO;
    }
    
    if ((token = [self.feedbackFilter alignmentFeedbackTokenForVerticalMovementInView:self previousY:NSMidY(movedFrom) alignedY:NSMidY(self.bounds) defaultY:NSMidY(draggedTo)])) {
        newRect.origin.y = NSMidY(self.bounds)-newRect.size.height/2.0;
        [preparedAlignments addObject:token];
        self.drawCenterYAsHoldingItem = YES;
    }
    else {
        self.drawCenterYAsHoldingItem = NO;
    }
    
    [self.feedbackFilter performFeedback:preparedAlignments performanceTime: NSHapticFeedbackPerformanceTimeDrawCompleted];
    
    return newRect;
}

// *** Your app can draw however it wants. The box could be a subview, or anything really. Here we're drawing using bezier paths.

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self drawHorizontalGuide:NSMidY(self.bounds) holdingItem:self.drawCenterYAsHoldingItem];
    [self drawVerticalGuide:NSMidX(self.bounds) holdingItem:self.drawCenterXAsHoldingItem];
    
    [self drawBox:self.boxFrame drawCenterAlignmentGuides:true];
}

@end

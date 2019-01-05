/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AlignmentGuidesView shows how to use NSAlignmentFeedbackFilter to align a box to the edges of its container and the container's center.
    
                The sample shows how to feed the filter using both a tracking loop (see mouseDown) and a gesture recognizer (see panGestureUpdated). These two methods feed the filter the latest event information, and then call into the appropriate handler for mouse down/dragged/up.
*/

@import Cocoa;

#import "AAPLDrawingView.h"

@interface AAPLAlignmentGuidesView : AAPLDrawingView

@property (weak) IBOutlet NSPopUpButton *eventHandlingButton;
@property (weak) IBOutlet NSButton *useGridButton;

@property (strong) NSAlignmentFeedbackFilter *feedbackFilter;

@property NSRect boxFrame;
@property NSPoint dragOriginOffset;

@property BOOL drawCenterXAsHoldingItem;
@property BOOL drawCenterYAsHoldingItem;

@end

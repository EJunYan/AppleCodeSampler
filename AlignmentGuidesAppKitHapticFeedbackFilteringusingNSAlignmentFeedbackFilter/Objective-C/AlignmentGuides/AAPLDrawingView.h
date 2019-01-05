/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AAPLDrawingView is a helper for the sample code. Your app can draw however it wants since alignment is independent of the view hierarchy. Here, we're using bezier paths.
*/

@import Cocoa;

@interface AAPLDrawingView : NSView

- (void)drawBox:(NSRect)frame drawCenterAlignmentGuides:(BOOL)drawCenterAlignmentGuides;

- (void)drawHorizontalGuide:(CGFloat)yCoordinate holdingItem:(BOOL)holdingItem;

- (void)drawVerticalGuide:(CGFloat)xCoordinate holdingItem:(BOOL)holdingItem;

- (NSRect)constrainRectToBounds:(NSRect)rect;

@end

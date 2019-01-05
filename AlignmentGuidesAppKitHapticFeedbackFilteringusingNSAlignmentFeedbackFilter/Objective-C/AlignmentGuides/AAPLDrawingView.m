/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	AAPLDrawingView is a helper for the sample code. Your app can draw however it wants since alignment is independent of the view hierarchy. Here, we're using bezier paths.
*/

#import "AAPLDrawingView.h"

@implementation AAPLDrawingView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithDeviceRed:0.95 green:0.95 blue:0.9 alpha:1.0] set];
    NSRectFill(self.bounds);
    
    [[NSColor blackColor] set];
    NSFrameRect(self.bounds);
}

- (void)drawBox:(NSRect)frame drawCenterAlignmentGuides:(BOOL)drawCenterAlignmentGuides {
    [[NSColor colorWithDeviceRed:0.78 green:0.78 blue:0.78 alpha:1.0] set];
    NSRectFill(frame);
    
    [[NSColor blackColor] set];
    NSFrameRectWithWidth(frame, 1.0);
    
    if (drawCenterAlignmentGuides) {
        NSBezierPath *path = [NSBezierPath new];
        [path moveToPoint:NSMakePoint(NSMinX(frame), NSMidY(frame))];
        [path lineToPoint:NSMakePoint(NSMaxX(frame), NSMidY(frame))];
        [path moveToPoint:NSMakePoint(NSMidX(frame), NSMinY(frame))];
        [path lineToPoint:NSMakePoint(NSMidX(frame), NSMaxY(frame))];
        [path stroke];
    }
}

- (void)drawHorizontalGuide:(CGFloat)yCoordinate holdingItem:(BOOL)holdingItem {
    NSBezierPath *path = [NSBezierPath new];
    [[NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:(holdingItem ? 0.8 : 0.2)] set];
    [path moveToPoint:NSMakePoint(0.0, yCoordinate)];
    [path lineToPoint:NSMakePoint(self.bounds.size.width, yCoordinate)];
    [path stroke];
}

- (void)drawVerticalGuide:(CGFloat)xCoordinate holdingItem:(BOOL)holdingItem {
    NSBezierPath *path = [NSBezierPath new];
    [[NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:(holdingItem ? 0.8 : 0.2)] set];
    [path moveToPoint:NSMakePoint(xCoordinate, 0.0)];
    [path lineToPoint:NSMakePoint(xCoordinate, self.bounds.size.height)];
    [path stroke];
}

- (NSRect)constrainRectToBounds:(NSRect)rect {
    if (rect.origin.x < 0.0) {
        rect.origin.x = 0.0;
    }
    
    if (rect.origin.y < 0.0) {
        rect.origin.y = 0.0;
    }
    
    if (NSMaxX(rect) > self.bounds.size.width) {
        rect.origin.x = self.bounds.size.width-rect.size.width;
    }
    
    if (NSMaxY(rect) > self.bounds.size.height) {
        rect.origin.y = self.bounds.size.height-rect.size.height;
    }
    
    return rect;
}

@end

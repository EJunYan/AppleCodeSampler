/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    DrawingView is a helper for the sample code. Your app can draw however it wants since alignment is independent of the view hierarchy. Here, we're using bezier paths.
*/

import Cocoa

class DrawingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor(deviceRed: 0.95, green: 0.95, blue: 0.9, alpha: 1.0).set()

        NSRectFill(bounds)
        
        NSColor.black.set()
        NSFrameRect(bounds)
    }
    
    func drawBox(_ frame: NSRect, drawCenterAlignmentGuides: Bool) {
        NSColor(deviceRed: 0.78, green: 0.78, blue: 0.78, alpha: 1.0).set()
        NSRectFill(frame)
        
        NSColor.black.set()
        NSFrameRectWithWidth(frame, 1.0)
        
        if drawCenterAlignmentGuides {
            let path = NSBezierPath()
            
            path.move(to: NSPoint(x: frame.minX, y: frame.midY))
            
            path.line(to: NSPoint(x: frame.maxX, y: frame.midY))
            
            path.move(to: NSPoint(x: frame.midX, y: frame.minY))
            
            path.line(to: NSPoint(x: frame.midX, y: frame.maxY))
            
            path.stroke()
        }
    }
    
    func drawHorizontalGuide(_ yCoordinate: CGFloat, holdingItem: Bool) {
        let path = NSBezierPath()

        NSColor(deviceRed: 0.0, green: 0.0, blue: 1.0, alpha: (holdingItem ? 0.8 : 0.2)).set()
        
        path.move(to: NSPoint(x: 0.0, y: yCoordinate))
        
        path.line(to: NSPoint(x: bounds.width, y: yCoordinate))
        
        path.stroke()
    }
    
    func drawVerticalGuide(_ xCoordinate: CGFloat, holdingItem: Bool) {
        let path = NSBezierPath()

        NSColor(deviceRed: 0.0, green: 0.0, blue: 1.0, alpha: (holdingItem ? 0.8 : 0.2)).set()
        
        path.move(to: NSPoint(x: xCoordinate, y: 0.0))
        
        path.line(to: NSPoint(x: xCoordinate, y: bounds.height))
        path.stroke()
    }
    
    func constrainRectToBounds(_ rect: NSRect) -> NSRect {
        var result = rect
        
        if rect.origin.x < 0.0 {
            result.origin.x = 0.0
        }
        
        if rect.origin.y < 0.0 {
            result.origin.y = 0.0
        }
        
        if rect.maxX > bounds.width {
            result.origin.x = bounds.width - rect.width
        }

        if rect.maxY > bounds.height {
            result.origin.y = bounds.height - rect.height
        }
        
        return result
    }
}

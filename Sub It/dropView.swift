//
//  dropView.swift
//  Sub It
//
//  Created by Kevin De Koninck on 12/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    var filePath: String?
    let expectedExt = ["AVI","FLV","WMV","MP4","MOV","MKV","QT","HEVC","DIVX","XVID"]  //file extensions allowed for Drag&Drop
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05).cgColor
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//        // Drawing code here.
//    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        // dash customization parameters
        let dashHeight: CGFloat = 5
        let dashLength: CGFloat = 10
        let dashColor = NSColor.gray
        
        // setup the context
        let currentContext = NSGraphicsContext.current()!.cgContext
        currentContext.setLineWidth(dashHeight)
        currentContext.setLineDash(phase: 0, lengths: [dashLength])
        currentContext.setStrokeColor(dashColor.cgColor)
        
        // draw the dashed path
        currentContext.addRect(bounds.insetBy(dx: dashHeight-dashHeight/2, dy: dashHeight-dashHeight/2))
        currentContext.strokePath()
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!
        self.filePath = path
        
        //post notification
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "somethingWasDropped"), object: nil) as Notification)
        
        return true
    }
}

//
//  dropView.swift
//  Sub It
//
//  Created by Kevin De Koninck on 12/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    //TODO expand with dropping multiple files 
    /*
 
     if let boards = board as? [String]{
        for brd in boards {
        }
     }
     
     
     in the 'performDragOperation' function fill array filepaths IF it is an allowed filetype or folder
     to check: use the 'checkExtension' to make a private array so you can cross reference the arrays
     
     in the checkExtension function, we must check: if one of the files is allowed, return true, but keep an array which files are allowed
 
 */
    
    
    var filePath: String? // TODO make array
    let expectedExt = ["AVI","FLV","WMV","MP4","MOV","MKV","QT","HEVC","DIVX","XVID"]  // file extensions allowed for Drag&Drop
    let backgroundColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05).cgColor
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = backgroundColor

        
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
            self.layer?.backgroundColor = NSColor(red: 50.0/255, green: 140.0/255, blue: 255.0/255, alpha: 0.2).cgColor
            return .copy
        } else {
            self.layer?.backgroundColor = NSColor(red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.2).cgColor
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        var isDir: ObjCBool = false
        let fm = FileManager()
        if fm.fileExists(atPath: path, isDirectory: &isDir) {
            if(isDir.boolValue){
                return true
            } else {
                let suffix = URL(fileURLWithPath: path).pathExtension
                for ext in self.expectedExt {
                    if ext.lowercased() == suffix {
                        return true
                    }
                }
            }
        }

        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = backgroundColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = backgroundColor
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

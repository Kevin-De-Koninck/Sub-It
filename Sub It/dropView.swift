//
//  dropView.swift
//  Sub It
//
//  Created by Kevin De Koninck on 12/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class DropView: NSView {
    

    var filePaths = [String]()
    let expectedExt = ["AVI","FLV","WMV","MP4","MOV","MKV","QT","HEVC","DIVX","XVID"]  // file extensions allowed fornDropping
    let backgroundColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05).cgColor
    
    private var allowedArray = [Bool]()
    
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
        
        //Reset on new drag
        self.allowedArray = [Bool]()
        self.filePaths = [String]()
        
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
            let paths = board as? [String]
            else { return false }

        for path in paths {
            var isAllowed = false
            var isDir: ObjCBool = false
            let fm = FileManager()
            if fm.fileExists(atPath: path, isDirectory: &isDir) {
                if(isDir.boolValue){
                    isAllowed = true
                } else {
                    let suffix = URL(fileURLWithPath: path).pathExtension
                    for ext in self.expectedExt {
                        if ext.lowercased() == suffix {
                            isAllowed = true
                        }
                    }
                }
            }
            allowedArray.append(isAllowed)
        }
        
        //If one element is allowed, pass everything (we'll handle this un-allowed file later)
        for check in allowedArray { if check { return true } }
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
            let paths = pasteboard as? [String]
            else { return false }
        
        var index = 0
        for path in paths {
            
            //Append path to array if the file type was allowed
            if allowedArray[index] {
                self.filePaths.append(path)
            }
            index = index + 1
        }
        
        //post notification
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "somethingWasDropped"), object: nil) as Notification)
        
        return true
    }
}

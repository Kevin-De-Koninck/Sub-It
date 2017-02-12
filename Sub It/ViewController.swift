//
//  ViewController.swift
//  Sub It
//
//  Created by Kevin De Koninck on 23/05/16.
//  Copyright © 2016 Kevin De Koninck. All rights reserved.
//

//TODO: regex check for urls in input field


import Cocoa
import DJProgressHUD_OSX

class ViewController: NSViewController {

    @IBOutlet weak var settingsBtn: NSButton!
    @IBOutlet weak var installationGuideBtn: NSButton!
    @IBOutlet weak var refreshInstallationBtn: NSButton!
    @IBOutlet weak var drop: DropView!

    
    
    //global variables
    var subIt = SubIt()
    
    
    
    
    


    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openSettingsView), name: NSNotification.Name(rawValue: "openSettingsView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(somethingWasDropped), name: NSNotification.Name(rawValue: "somethingWasDropped"), object: nil)

    }
    func openSettingsView(notif: AnyObject) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    func somethingWasDropped(notif: AnyObject) {
        print(drop.filePath!)
        print(subIt.getCommand())
        
        execute(commmandAsynchronous: subIt.getCommand() + "'" + drop.filePath! + "'" )
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        subIt.checkIfSoftwareIsInstalled()
        installationGuideViewSetUp(activate: !subIt.isSubliminalInstalled)
//        installationGuideViewSetUp(activate: true)  //TODO - remove (is for testing purposes)
    }
    
    func installationGuideViewSetUp(activate: Bool) {
        settingsBtn.isEnabled = !activate
        drop.isHidden = activate
        installationGuideBtn.isEnabled = activate
        installationGuideBtn.isHidden = !activate
        refreshInstallationBtn.isEnabled = activate
        refreshInstallationBtn.isHidden = !activate
    }
    
    @IBAction func refreshInstallationBtnClicked(_ sender: Any) {
        subIt.checkIfSoftwareIsInstalled()
        installationGuideViewSetUp(activate: !subIt.isSubliminalInstalled)
//        installationGuideViewSetUp(activate: true)  //TODO - remove (is for testing purposes)
    }
    
    
    
    func execute(commmandAsynchronous: String){
        
        //Prepare command
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( commmandAsynchronous  )
        print( commmandAsynchronous  )
        
        //Start execution of command
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {  notification -> Void in
            let data = outHandle.availableData
            if data.count > 0 {
                if let s = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    //RECEIVED OUTPUT
                    let receivedStr = s.components(separatedBy: "\n")[0]
                    var str = receivedStr.replacingOccurrences(of: "/ ", with: "\n")
                    
                    //After we receive "1 video collected / 0 video ignored / 0 error" we start downloading
                    if(receivedStr != str){ str = "Downloading subtitles" }

                    //After we receive something that starts with "downloaded" then we 'freeze' the output for a couple of seconds
                    if(String(str.characters.prefix(10)) == "Downloaded"){
                        DJProgressHUD.showStatus(str, from: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            DJProgressHUD.dismiss()
                        })
                    //otherwise we just output the received text
                    } else {
                        DJProgressHUD.showStatus(str, from: self.view)
                    }
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                //EOF ON STDOUT FROM PROCESS
                NotificationCenter.default.removeObserver(obs1)
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) { notification -> Void in
            NotificationCenter.default.removeObserver(obs2)
        }
        
        task.launch()
    }

}

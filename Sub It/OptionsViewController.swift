//
//  OptionsViewController.swift
//  Sub It
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa
import ITSwitch

class OptionsViewController: NSViewController {

    //Subtitles tab
    @IBOutlet weak var languageSubs1: NSPopUpButton!
    @IBOutlet weak var languageSubs2: NSPopUpButton!
    @IBOutlet weak var singleFile: ITSwitch!
    @IBOutlet weak var forceDownload: ITSwitch!
    @IBOutlet weak var preferHearingImpaired: ITSwitch!
    
    //Others  tab
    @IBOutlet weak var useFilter: ITSwitch!
    @IBOutlet weak var seperateDownloadsFolder: ITSwitch!
    @IBOutlet weak var selectedPath: NSTextField!
    @IBOutlet weak var folderIcon: NSButton!
    
    //SubIt
    var subIt = SubIt()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        //Switch color
        singleFile.tintColor = blueColor
        forceDownload.tintColor = blueColor
        preferHearingImpaired.tintColor = blueColor
        useFilter.tintColor = blueColor
        seperateDownloadsFolder.tintColor = blueColor
        
        loadSettingsAndSetElements()
    }
    
    @IBAction func seperateDownloadFolderSwitchClicked(_ sender: Any) {
        selectedPath.isHidden = !seperateDownloadsFolder.checked
        folderIcon.isHidden = !seperateDownloadsFolder.checked
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        //we want to save the settings
        saveSettings()
        
        //Save the command
        UserDefaults.standard.setValue(createCommand(), forKey: SAVED_COMMAND)
        UserDefaults.standard.synchronize()
    }

    
    @IBAction func loadDefaultsBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
        UserDefaults.standard.setValue(DEFAULT_SETTINGS["selectedPath"]!, forKey: OUTPUT_PATH)
        UserDefaults.standard.synchronize()
        loadSettingsAndSetElements()
    }
    
    
    func saveSettings() {
        var settingsDict = [String: String]()

        settingsDict["singleFile"] = String(singleFile.checked) == "true" ? "1" : "0"
        settingsDict["forceDownload"] = String(forceDownload.checked) == "true" ? "1" : "0"
        settingsDict["preferHearingImpaired"] = String(preferHearingImpaired.checked) == "true" ? "1" : "0"
        settingsDict["useFilter"] = String(useFilter.checked) == "true" ? "1" : "0"
        settingsDict["seperateDownloadsFolder"] = String(seperateDownloadsFolder.checked) == "true" ? "1" : "0"
        settingsDict["languageSubs1"] = String(languageSubs1.indexOfSelectedItem)
        settingsDict["languageSubs2"] = String(languageSubs2.indexOfSelectedItem)
        settingsDict["selectedPath"] = UserDefaults.standard.value(forKey: OUTPUT_PATH) as? String
        
        UserDefaults.standard.set(settingsDict, forKey: SETTINGS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    
    func loadSettingsAndSetElements() {
        
        if let arr = UserDefaults.standard.value(forKey: SETTINGS_KEY) as? [String:String] {

            
            //Get and set all saved settings
            
            if arr["selectedPath"] != nil {
                if let temp = UserDefaults.standard.value(forKey: OUTPUT_PATH) as? String {
                selectedPath.stringValue = NSURL(fileURLWithPath: temp).lastPathComponent!
                } else { // BUG FIX
                    UserDefaults.standard.setValue(DEFAULT_OUTPUTPATH, forKey: OUTPUT_PATH)
                    UserDefaults.standard.synchronize()
                    selectedPath.stringValue = NSURL(fileURLWithPath: DEFAULT_OUTPUTPATH).lastPathComponent!
                }
            }
            else { selectedPath.stringValue = DEFAULT_SETTINGS["selectedPath"]! }
            
            if let val = arr["singleFile"] { singleFile.checked = val == "1" ? true : false }
            else { singleFile.checked = DEFAULT_SETTINGS["singleFile"]! == "1" ? true : false }
            
            if let val = arr["forceDownload"] { forceDownload.checked = val == "1" ? true : false }
            else { forceDownload.checked = DEFAULT_SETTINGS["forceDownload"]! == "1" ? true : false }
            
            if let val = arr["preferHearingImpaired"] { preferHearingImpaired.checked = val == "1" ? true : false }
            else { preferHearingImpaired.checked = DEFAULT_SETTINGS["preferHearingImpaired"]! == "1" ? true : false }
            
            if let val = arr["useFilter"] { useFilter.checked = val == "1" ? true : false }
            else { useFilter.checked = DEFAULT_SETTINGS["useFilter"]! == "1" ? true : false }
            
            if let val = arr["seperateDownloadsFolder"] { seperateDownloadsFolder.checked = val == "1" ? true : false }
            else { seperateDownloadsFolder.checked = DEFAULT_SETTINGS["seperateDownloadsFolder"]! == "1" ? true : false }
   
            if let val = arr["languageSubs1"] { languageSubs1.selectItem(at: Int(val)!) }
            else { languageSubs1.selectItem(at: Int(DEFAULT_SETTINGS["languageSubs1"]!)!) }
            
            if let val = arr["languageSubs2"] { languageSubs2.selectItem(at: Int(val)!) }
            else { languageSubs2.selectItem(at: Int(DEFAULT_SETTINGS["languageSubs2"]!)!) }
            
        } else {
            // No saved settings?, save the defaults and retry
            UserDefaults.standard.setValue(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
            UserDefaults.standard.setValue(DEFAULT_OUTPUTPATH, forKey: OUTPUT_PATH)
            UserDefaults.standard.synchronize()
            loadSettingsAndSetElements()
        }
        
        selectedPath.isHidden = !seperateDownloadsFolder.checked
        folderIcon.isHidden = !seperateDownloadsFolder.checked
    }
    
    
    
    func createCommand() -> String {
        //Start of creating the command
        var command = "export PATH=$PATH:/usr/local/bin && subliminal download";
        

        //Creating the command
        if singleFile.checked { command += " -s" }
        if forceDownload.checked { command += " -f" }
        if preferHearingImpaired.checked { command += " --hearing-impaired" }

        
        
        //TODO use filter
        
        //sed -i “regex” file.srt ?
        
        

        //seperate downloadsfolder
        if(seperateDownloadsFolder.checked){ command += " -d " + subIt.getOutputPath() }
        
        
    
        //languages
        if languageSubs1.selectedItem!.tag > 0 {
            var subLanguage = ""
            switch languageSubs1.selectedItem!.tag {
            case 1: subLanguage = "en"
            case 2: subLanguage = "gr"
            case 3: subLanguage = "pt"
            case 4: subLanguage = "fr"
            case 5: subLanguage = "it"
            case 6: subLanguage = "ru"
            case 7: subLanguage = "es"
            case 8: subLanguage = "de"
            case 9: subLanguage = "nl"
            default: subLanguage = "en"
            }
            command += " -l \(subLanguage)"
        }
        if languageSubs2.selectedItem!.tag > 0 {
            var subLanguage = ""
            switch languageSubs2.selectedItem!.tag {
            case 1: subLanguage = "en"
            case 2: subLanguage = "gr"
            case 3: subLanguage = "pt"
            case 4: subLanguage = "fr"
            case 5: subLanguage = "it"
            case 6: subLanguage = "ru"
            case 7: subLanguage = "es"
            case 8: subLanguage = "de"
            case 9: subLanguage = "nl"
            default: subLanguage = "en"
            }
            command += " -l \(subLanguage)"
        }
        
        return command
    }
    
    @IBAction func folderIconClicked(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a folder"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseFiles          = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url
            if (result != nil) {
                let path = result!.path
                UserDefaults.standard.setValue(path, forKey: OUTPUT_PATH)
                UserDefaults.standard.synchronize()

                selectedPath.stringValue = NSURL(fileURLWithPath: path).lastPathComponent!
            }
        }
        
        //post notification to viewcontroller.swift to open the settingsview again (segue)
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "openSettingsView"), object: nil) as Notification)
        
    }
    
    
    
    @IBAction func clearCacheBtnClicked(_ sender: Any) {
        _ = subIt.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && subliminal cache --clear-subliminal")
    }

 
}

//
//  Constants.swift
//  Sub It
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation
import Cocoa

// Command
let DEFAULT_COMMAND = "export PATH=$PATH:/usr/local/bin && subliminal download -s -l en"
let DEFAULT_OUTPUTPATH = "~/Downloads/"
let REGEX_PATTERN = ".+?(?=\\[)" //matches anything before the [

//Color
var blueColor = NSColor.init(red: 45.0/255, green: 135.0/255, blue: 250.0/255, alpha: 1)


// Settings
let DEFAULT_SETTINGS = [    "selectedPath"           :   "~/Downloads/",
                            "singleFile"             :   "1", //bool
                            "forceDownload"          :   "1", //bool
                            "preferHearingImpaired"  :   "0", //bool
                            "useFilter"              :   "0", //bool
                            "seperateDownloadsFolder":   "0", //bool
                            "languageSubs1"          :   "0", //index
                            "languageSubs2"          :   "0" //index
                        ]

// User Defaults - keys
let SAVED_COMMAND = "savedCommand"
let SETTINGS_KEY = "settings"
let SUBLIMINAL = "isYTDLInstalled"
let BREW = "isBrewInstalled"
let PYTHON = "isPythonInstalled"
let XCODE = "isXcodeInstalled"
let OUTPUT_PATH = "outputPath"

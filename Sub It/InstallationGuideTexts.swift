//
//  InstallationGuideTexts.swift
//  Sub It
//
//  Created by Kevin De Koninck on 05/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation

let PAGES = ["intro","xcode","brew","python","sub","finish"]

let TITLE:[String:String] = ["intro":"Introduction",
                             "xcode":"Xcode Command Line Tools",
                             "brew":"Homebrew",
                             "python":"Python interpreter",
                             "sub":"Subliminal",
                             "finish":"It's over now. It's done."]

let BODY:[String:String] = ["intro":"Before you can use Sub It, we must install some dependencies. This guide will assist you with installing these dependencies.\n\nThe dependencies that we will install (if not already installed) are:\n   - Homebrew\n   - Python 3\n   - Subliminal.",
                            "xcode":"Xcode development tools are some handy tools that are always nice to have on your system. Xcode is a large suite of software development tools and libraries from Apple.\nInstallation of many common Unix-based tools requires the GCC compiler. The Xcode Command Line Tools include a GCC compiler.\n\nTo install the Xcode command line tools, just press the 'Install' button below and follow the guide that will pop up.",
                            "brew":"Homebrew is the missing package manager for macOS which we'll be using Homebrew to install all the software that is needed for Get It.\n\nTo install brew, copy the following command (green text), press the button 'Open the Terminal app' and paste the command in the terminal app. Then press enter, wait a bit and press enter again. Enter your password when the installer asks for it.\nWhen the installation has finished, you may close the Terminal app.",
                            "python":"Our core program requires the python 3 interpreter to operate.\n\nTo install Python 3, just press the 'Install' button below.",
                            "sub":"Subliminal is the core program of Sub It. It's an open-source command line tool that handles the downloading of our subtitles.\n\nTo install Subliminal, just press the 'Install' button below.",
                            "finish":"If you executed eveything correctly, then your installation is completed. \n\nYou may close this window (and the Terminal app) now and click on the little blue refresh icon (like the one below) to reload all software.\n\nThen you're good to go!"]

let INSTALLATION_COMMANDS:[String:String] = ["intro":"",
                                             "xcode":"xcode-select --install",
                                             "brew":"/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"",
                                             "python":"brew install python3",
                                             "sub":"brew install subliminal", //TODO install Sven zijn repo
                                             "finish":""]

//
//  ViewController.swift
//  Update Roles
//
//  Created by s3cy on 3/12/15.
//  Copyright (c) 2015 s3cy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var didChoose: Bool = false
    var avatarArr = [String]()
    struct Role {
        var name: String
        var imgURL: String
        init (name: String, imgURL: String) {
            self.name = name
            self.imgURL = imgURL
        }
    }
    var roles = [Role]()
    
    func writeFile() {
        var s = ",{\"name\":\"\(rolesTitleLabel.stringValue)\",\"roles\":["
        for role in roles {
            s += "{\"name\":\"\(role.name)\",\"imgURL\":\"\(role.imgURL)\"},"
        }
        s.substringToIndex(s.endIndex.predecessor())
        s += "]}]"
        var path = pathLabel.stringValue
        if let fileHandle = NSFileHandle(forUpdatingAtPath: path) {
            let size = fileHandle.seekToEndOfFile()
            fileHandle.seekToFileOffset(size - sizeof(UInt64)/4)
            let data = (s as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            fileHandle.writeData(data!)
            didChoose = false
            rolesLabel.stringValue = ""
            rolesTitleLabel.stringValue = ""
            warningLabel.stringValue = "Added Successfully!"
        } else {
            warningLabel.stringValue = "⚠️ Warning: This is not a qualified path."
        }
    }
    
    @IBAction func button(sender: NSButton) {
        avatarArr.removeAll()
        roles.removeAll()
        
        var panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        var clicked = panel.runModal()
        if (clicked == NSFileHandlingPanelOKButton) {
            let fileManager = NSFileManager()
            print(panel.URL!)
            let folderName = panel.URL!.lastPathComponent!
            var rolesTitle = folderName.stringByReplacingOccurrencesOfString("-", withString: " ")
            if let range = rolesTitle.rangeOfString("Avatar") {
                rolesTitle = rolesTitle.substringToIndex(range.startIndex)
            }
            rolesTitleLabel.stringValue = rolesTitle
            
            let urlPath = panel.URL!.path!  //convert url to string
            var urlArr = fileManager.contentsOfDirectoryAtPath(urlPath, error: nil)!
            for url in urlArr {
                avatarArr.append(url.lastPathComponent!)
            }
            rolesLabel.stringValue = ""
            rolesLabel.stringValue = "The following Roles are going to be added:\n\n"
            for (var i = 0; i < avatarArr.count; i++) {
                let name = avatarArr[i].stringByDeletingPathExtension
                let avatar = avatarArr[i].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                let ghUrlPath = "https://raw.githubusercontent.com/s3cy/Pictures/master/\(folderName)/\(avatar)"
                var role = Role(name: name, imgURL: ghUrlPath)
                rolesLabel.stringValue += "\"\(name)\" "
                if i%4 == 0 && i != 0 {
                    rolesLabel.stringValue += "\n"
                }
                roles.append(role)
            }
            didChoose = true
        }
    }
    
    @IBOutlet weak var rolesTitleLabel: NSTextField!
    
    @IBOutlet weak var rolesLabel: NSTextField!
    
    @IBOutlet weak var pathLabel: NSTextField!
    
    @IBOutlet weak var warningLabel: NSTextField!
    
    @IBAction func updateButton(sender: NSButton) {
        if didChoose {
            writeFile()
        } else {
            warningLabel.stringValue = "⚠️ Warning: Please select a folder first."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


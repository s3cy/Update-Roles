//
//  ViewController.swift
//  Update Roles
//
//  Created by s3cy on 3/12/15.
//  Copyright (c) 2015 s3cy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var folderName: String = ""
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
    
    func writeJSONString() {
        var s = ",{\"name\":\"\(folderName)\",\"roles\":["
        for role in roles {
            s += "{\"name\":\"\(role.name)\",\"imgURL\":\"\(role.imgURL)\"},"
        }
        s.substringToIndex(s.endIndex.predecessor())
        s += "]}]"
        var path = "/Users/apple/Development/GitHub/Chat-App/data.json"
        var fileHandle = NSFileHandle(forUpdatingAtPath: path)!
        var size = fileHandle.seekToEndOfFile()
        fileHandle.seekToFileOffset(size - sizeof(UInt64)/4)
        let data = (s as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        fileHandle.writeData(data!)
    }
    
    @IBAction func button(sender: NSButton) {
        var panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        var clicked = panel.runModal()
        if (clicked == NSFileHandlingPanelOKButton) {
            let fileManager = NSFileManager()
            print(panel.URL!)
            folderName = panel.URL!.lastPathComponent!
            let urlPath = panel.URL!.path!  //convert url to string
            var urlArr = fileManager.contentsOfDirectoryAtPath(urlPath, error: nil)!
            for url in urlArr {
                avatarArr.append(url.lastPathComponent!)
            }
            for (var i = 0; i < avatarArr.count; i++) {
                let name = avatarArr[i].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                let ghUrlPath = "https://raw.githubusercontent.com/s3cy/Pictures/master/\(folderName)/\(name)"
                var role = Role(name: name, imgURL: ghUrlPath)
                roles.append(role)
            }
            writeJSONString()
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


//
//  MetaFile.swift
//  MetaMerge
//
//  Created by Dan Hushon on 9/6/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation

extension URL {
    var isDirectory: Bool {
        let values = try? resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory ?? false
    }
}

extension URL {
    var isRegularFile: Bool {
        let values = try? resourceValues(forKeys: [.isRegularFileKey])
        return values?.isRegularFile ?? false
    }
}

/*class FileBroawser: NSBrowserDelegate {

    
}*/

/// Logs messages about unexpected behavior.
public protocol MLogger {
    
    /// Logs provided message.
    ///
    /// - Parameter message: Message.
    func log(message: String)
    
}

/// Gloss Logger.
public struct MetaLogger: MLogger {
    
    public func log(message: String) {
        print("[Meta] \(message)")
    }
    
}

class MetaFile {
    // class definition
    
    //different representations of meta information on rectangularly boxed visual objects
    enum VOCtype {
        case pascalvoc,json
    }
    
    var metaURI: URL
    
    init(metaURI: URL) {
        self.metaURI = metaURI
        print("\(metaURI) original URL")
        if ( metaURI.isDirectory ) {
            print("\(metaURI) is a directory")
        } else {
            print("\(metaURI) is a file")
            if ( metaURI.isRegularFile) {
                print ("\(metaURI) file exists")
            }
        }
    }
    
    // determine if the directory provided is a file or a directory
    func isDirectory() -> Bool {
        return metaURI.isDirectory
    }
    
    // expect that image directory is likely given, so find annotation directory for images
    /**func findAnnotations() -> URL {
        return URL: nil
    }*/
    

    
    
    
    
}

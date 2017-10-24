//
//  VOCJSONParser.swift
//  MetaMerge
//
//  Created by Dan Hushon on 9/24/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation
import Gloss

/*
 {
 "filename" : "lepage-170604-DGP-9916.jpg",
 "folder" : "images",
 "image_w_h" : [
 4928,
 3280
 ],
 "objects" : [
 {
 "label" : "carconenumber-1",
 "x_y_w_h" : [
 2287,
 1865,
 391,
 235
 ]
 },
 {
 "label" : "camera-camera",
 "x_y_w_h" : [
 2304,
 788,
 377,
 322
 ]
 },
 {
 "label" : "car-bottom-front-1",
 "x_y_w_h" : [
 570,
 770,
 3782,
 2347
 ]
 }
 ]
 }
*/


// as JSON elements may be changed/added, wanted to use enumerated types to help manage decoding
enum VOCJSONElements: String {
    case folder = "folder"
    case separator = "["
    case filename = "filename"
    case size = "image_w_h"
    case objects = "objects"
    case label = "label"
    case bndbox = "x_y_w_h"
}

/**enum SerializationError: Error {
    case missing(String)
}*/

extension Dimensions {
    // do i need to guard for safety?
    init ?(dimensions: [Int]) {
        if (dimensions.count == 2) {
            self.width = dimensions[0]
            self.height = dimensions[1]
        } else {
            self.width = 0
            self.height = 0
        }
    }
}

extension BoundingBox {
    
    init ?(xywh: [Int]) {
        if (xywh.count == 4) {
            self.xmin = xywh[0]
            self.ymin = xywh[1]
            self.xmax = xywh[2] + self.xmin
            self.ymax = xywh[3] + self.ymin
        } else {
            self.xmin = 0
            self.ymin = 0
            self.xmax = 0
            self.ymax = 0
        }
    }
    
}

extension vObject {
    init?(json: [String:Any]) {
        guard let name: String = VOCJSONElements.label.rawValue <~~ json else {
            print("failed to parse label")
            return nil
        }
        self.name = name
        guard let bbox: [Int] = VOCJSONElements.bndbox.rawValue <~~ json else {
            print("failed to parse bounding box")
            return nil
        }
        self.box = BoundingBox(xywh: bbox)
        print("done with vobject \(self)")
    }
}

extension VOCElement: Gloss.Decodable {
    
    public init?(json: JSON) {
        guard let filename: String = VOCJSONElements.filename.rawValue <~~ json else {
            print("failed parsing filename")
            return nil
        }
        self.filename = filename
        guard let folder: String = VOCJSONElements.folder.rawValue <~~ json else {
            print("failed parsing folder")
            return nil
        }
        self.folder = folder
        guard let dims: [Int] = VOCJSONElements.size.rawValue <~~ json else {
            print("failed parsing dimensions")
            return nil
        }
        
        self.dimensions = Dimensions(dimensions: dims)!
        self.segmented = 0

        guard let objectJSONArray:[[String:Any]] = VOCJSONElements.objects.rawValue <~~ json else {
            print("failed decoding objects")
            return nil
        }
        self.vobjects = []
        for object in objectJSONArray {
            self.vobjects.append(vObject(json: object))
        }
    }
    
    init?(decode: [String: Any]) {
        self.vobjects = [vObject?]()
        // unroll the filename
        guard let filename = decode[VOCJSONElements.filename.rawValue] as? String else {
            return nil
        }
        self.filename = filename
        
        // unroll the folder iD
        guard let folder = decode[VOCJSONElements.folder.rawValue] as? String else {
            return nil
        }
        self.folder = folder
        
        // unroll the image dimensions
        guard let dimensionsJSON = decode[VOCJSONElements.size.rawValue] as? [Int] else {
            return nil
        }
        self.dimensions = Dimensions(dimensions: dimensionsJSON)!
        
        // unroll the individual boxes: "label" and "dimensions"
        guard let objectJSONArray = decode[VOCJSONElements.objects.rawValue] as? [[String:Any]] else {
            return nil
        }
        for object in objectJSONArray {
            self.vobjects.append(vObject(json: object))
        }
        return nil
    }
}

enum VOCParserError: Error {
    case parsingError
}

public class VOCJSONParser: VOCParser {
    
    var vo : VOCElement? = nil
    
    //public static var logger: Logger = MetaLogger()
    
    public func decode(url: URL) -> VOCElement? {
        var json : JSON
        if url.isFileURL {
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                json = (try JSONSerialization.jsonObject(with: data) as? JSON)!
            } catch {
                print("Couldn't parse file")
                return nil
            }
            
            guard let vo = VOCElement(json: json) else {
                print("Gloss JSON dictionary parsing error")
                return nil
            }
            return vo
        }
        return vo
    }
}

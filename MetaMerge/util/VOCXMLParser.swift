//
//  VOCXMLParser.swift
//  MetaMerge
//  Created by Dan Hushon on 9/7/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation

/**
 sample vocxml file form containing 3 named bounding boxes
 <annotation>
 <folder>images</folder>
 <filename>lepage-170604-DGP-9916.jpg</filename>
 <size>
 <width>4928</width>
 <height>3280</height>
 </size>
 <segmented>0</segmented>
 <object>
 <name>carconenumber-1</name>
 <bndbox>
 <xmin>2287</xmin>
 <ymin>1865</ymin>
 <xmax>2677</xmax>
 <ymax>2099</ymax>
 </bndbox>
 </object>
 <object>
 <name>camera-camera</name>
 <bndbox>
 <xmin>2304</xmin>
 <ymin>788</ymin>
 <xmax>2680</xmax>
 <ymax>1109</ymax>
 </bndbox>
 </object>
 <object>
 <name>car-bottom-front-1</name>
 <bndbox>
 <xmin>570</xmin>
 <ymin>770</ymin>
 <xmax>4351</xmax>
 <ymax>3116</ymax>
 </bndbox>
 </object>
 </annotation>
 */
enum VOCXMLelements: String {
    case annotation = "annotation"
    case folder = "folder"
    case filename = "filename"
    case size = "size"
    case width = "width"
    case height = "height"
    case segmented = "segmented"
    case object = "object"
    case name = "name"
    case bndbox = "bndbox"
    case xmin = "xmin"
    case ymin = "ymin"
    case xmax = "xmax"
    case ymax = "ymax"
}

protocol VOCParser {
    func decode(url:URL) -> VOCElement?
}

extension VOCElement {
    
    init?(xml: Any) {
        self.filename = ""
        self.folder = ""
        self.dimensions = Dimensions(dimensions: [0,0])!
        self.segmented = 0
        self.vobjects = [vObject?]()
    }
}

extension BoundingBox {
    
    init ?(xyxy: [Int]) {
        if (xyxy.count == 4) {
            self.xmin = xyxy[0]
            self.ymin = xyxy[1]
            self.xmax = xyxy[2]
            self.ymax = xyxy[3]
        } else {
            self.xmin = 0
            self.ymin = 0
            self.xmax = 0
            self.ymax = 0
        }
    }
}

extension vObject {
    init?(name: String, box: BoundingBox) {
        self.name = name
        self.box = box
    }
}

class VOCXMLParser: NSObject, XMLParserDelegate, VOCParser {
    
    var parser = XMLParser()
    var tle = false // top level element found
    
    var parsingDoc = false
    var parsingTag: VOCXMLelements = VOCXMLelements.annotation
    var visualobjects: [vObject?] = []
    var vo: VOCElement?
    
    //vobjects
    var name: String = ""
    var box: [Int] = [0,0,0,0]

    public func decode(url: URL) -> VOCElement?
    {
        // initializer for next document?
        parser = XMLParser(contentsOf:(url) as URL)!
        parser.delegate = self
        parser.parse()
        return vo;
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        //new document
        parsingDoc = true
        vo = VOCElement(xml: "")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // end of document
        parsingDoc = false
    }
 
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        if (parsingDoc){
            parsingTag = VOCXMLelements(rawValue:elementName)!
            switch(parsingTag) { // there should be a way to do an enum match....
            case .object: // new element in array
                name = ""
                box = [0,0,0,0]
                return
            default:
                return
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parsingTag = VOCXMLelements(rawValue:elementName)!
        switch(parsingTag) {
        case .object: // end of object in array
            vo?.vobjects.append(vObject(name: name, box: BoundingBox(xyxy:box)))
            return
        default:
            return
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (string.contains("\n")) { return } // remove carriage returns from parsed strings - hygiene
        
        // find appropriate tag and assign value, cases are elaborated to support all "known" tags, recognizing that 
        // other tags may need to be added later - at least we can see the missing tags for now
        switch parsingTag {
        case .folder:
            vo?.folder = string
            break
        case .filename:
            vo?.filename.append(_: string)
            break
        case .size:
            break
        case .width:
            vo?.dimensions.width = Int(string)!
            break
        case .height:
            vo?.dimensions.height = Int(string)!
            break
        case .segmented:
            vo?.segmented = Int(string)!
            break
        case .object:
            // hit a new object flag --
            break
        case .name:
            name = string
            break
        case .bndbox:
            break
        case .xmin:
            box[0] = Int(string)!
            break
        case .xmax:
            box[1] = Int(string)!
            break
        case .ymin:
            box[2] = Int(string)!
            break
        case .ymax:
            box[3] = Int(string)!
            break
        default:
            print("found unknown: \(string) for \(parsingTag)")
            break
        }
    }
}

//
//  VisualObject.swift
//  MetaMerge
//
//  Created by Dan Hushon on 9/7/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation

public struct Dimensions {
    public var width: Int
    public var height: Int
}

public struct BoundingBox {
    public var xmin: Int
    public var xmax: Int
    public var ymin: Int
    public var ymax: Int
}

public struct vObject {
    public let name: String
    public var box: BoundingBox?
}

public struct VOCElement {
    public var folder: String
    public var filename: String
    public var dimensions: Dimensions
    public var segmented: Int
    public var vobjects: [vObject?]
    
}

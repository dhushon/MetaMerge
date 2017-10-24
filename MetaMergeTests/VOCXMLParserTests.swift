//
//  VOCXMLParserTests.swift
//  MetaMergeTests
//
//  Created by Dan Hushon on 10/18/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//
import Foundation
import XCTest

@testable import MetaMerge

class VOCXMLDecoderTest: XCTestCase {

    let file = ["lepage-170604-DGP-9916"]
    let type = "xml"

    override func setUp() {
        super.setUp()
    }

    func testXMLParser() {
        let url = Resource(name: file[0], type: type).url
        try XCTAssertTrue(url.checkResourceIsReachable())
        print("XMLURL: \(String(describing: url)) is reachable")
        
        let voc :VOCElement? = VOCXMLParser().beginParsing(url: url)
        XCTAssertTrue(voc?.vobjects.count == 3)
        print("XMLParse: successfully parsed objects")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

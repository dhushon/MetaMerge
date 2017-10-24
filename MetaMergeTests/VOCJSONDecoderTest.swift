//
//  TestVOCJSONDecoder.swift
//  MetaMergeTests
//
//  Created by Dan Hushon on 9/26/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation
import XCTest

@testable import MetaMerge

class VOCJSONDecoderTest: XCTestCase {
    
    let file = ["lepage-170604-DGP-9916"]
    let type = "json"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONParser() {
        // get url (check that bundle includes necessary JSON)
        let jsonURL = Resource(name: file[0], type: type).url
        try XCTAssertTrue((jsonURL.checkResourceIsReachable()))
        print("JSONURL: \(String(describing: jsonURL)) is reachable")
        
        // parse json file identified
        let voc :VOCElement? = VOCJSONParser().decode(url: jsonURL)
        XCTAssertTrue(voc?.vobjects.count == 3)
        print("JSONParse: successfully parsed objects")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}




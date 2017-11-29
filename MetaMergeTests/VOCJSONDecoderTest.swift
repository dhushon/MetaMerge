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
    var vocs : VOCElementSet? = nil
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONDecoder() {
        // get url (check that bundle includes necessary JSON)
        let jsonURL = Resource(name: file[0], type: type).url
        try XCTAssertTrue((jsonURL.checkResourceIsReachable()))
        print("JSONURL: \(String(describing: jsonURL)) is reachable")
        
        // parse json file identified
        let parser = VOCJSONParser()
        do {
            let _ = try parser.decode(url: jsonURL)
            let voc: VOCElementSet? = parser.getParsed()
            XCTAssertNotNil(voc)
            self.vocs = voc
            let image = voc!.images[0]
            XCTAssertTrue(image.objects.count == 3)
        } catch {
            print("Caught Error: \(error)")
        }
        print("JSONParse: successfully parsed objects")
    }
    
    func testJSONEncoder() {
        testJSONDecoder()
        let jsonURL = Resource(name: file[0], type: type).url
        do {
            let tbp = VOCJSONParser()
            try tbp.encode(url: jsonURL,voc: vocs)
            XCTAssertTrue(true)
            print("JSONParser.encoder successfully encoded objects")
        } catch {
            print("VOCJSONDecoderTest.testJSONEncoder: \(error)")
            XCTAssertFalse(true)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getVOCElementSet() -> VOCElementSet? {
        return vocs
    }
    
}




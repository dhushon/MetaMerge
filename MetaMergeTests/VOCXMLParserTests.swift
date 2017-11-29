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
        
        do {
            let parser : VOCXMLParser = VOCXMLParser()
            try parser.decode(url: url)
            let voc: VOCElementSet? = parser.getParsed()
            XCTAssertNotNil(voc)
            let image = voc!.images[0]
            XCTAssertTrue(image.objects.count == 3)
        } catch {
            print("Caught Error: \(error)")
        }
        print("XMLParse: successfully parsed objects")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

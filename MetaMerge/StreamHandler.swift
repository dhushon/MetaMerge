//
//  StreamHandler.swift
//  MetaMerge
//
//  Created by Dan Hushon on 10/25/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//

import Foundation

class StreamHandler: NSObject, StreamDelegate {
    var outStream: OutputStream?
    var inStream: InputStream?
    
    func openWrite(url: URL) {
        // open the file for write
        outStream!.delegate = self
        outStream!.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func openRead(url: URL) {
        // open the file for read
        inStream!.delegate = self
        inStream!.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func isOpenRead() -> Bool {
        return false
    }
    
    func isOpenWrite() -> Bool {
        return false
        
    }
    
    func stream(aStream: Stream, handleEvent eventCode: Stream.Event) {
        if aStream === inStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("input: ErrorOccurred: \(aStream.streamError.debugDescription)")
            case Stream.Event.openCompleted:
                print("input: OpenCompleted")
            case Stream.Event.hasBytesAvailable:
                print("input: HasBytesAvailable")
                
                readStream(inStream: inStream)
                
            default:
                break
            }
        }
        else if aStream === outStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("output: errorOccurred: \(aStream.streamError.debugDescription)")
            case Stream.Event.openCompleted:
                print("output: openCompleted")
            case Stream.Event.hasSpaceAvailable:
                print("output: hasSpaceAvailable")
                
                // Here you can write() to `outputStream`
                
            default:
                break
            }
        }
    }
    
    func readStream(inStream: InputStream?) {
        if inStream != nil{
            let input = inStream!
            var readBuffer: String = ""
            var readByte = [UInt8](repeating:0, count: 512)
            while input.hasBytesAvailable{
                input.read(&readByte, maxLength: readByte.count)
                let tempString = NSString(bytes: readByte, length: readByte.count, encoding: String.Encoding.utf8.rawValue)
                if tempString?.length != nil{
                    readBuffer = (readBuffer as String) + (tempString! as String) as String
                }
            }
        }
    }
    
    //func write(
    
    
    
}

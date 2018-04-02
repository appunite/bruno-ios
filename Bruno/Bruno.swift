//
//  Bruno.swift
//  Bruno
//
//  Created by Emil Wojtaszek on 03/04/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import UIKit
import Accelerate

public protocol Bufferable {
    var buffer: vImage_Buffer { get }
    var height: Int { get }
    var width: Int { get }
}

public extension Bufferable {
    var height: Int {
        return Int(buffer.height)
    }
    var width: Int {
        return Int(buffer.width)
    }
}

internal class RawBuffer: Bufferable {
    var buffer: vImage_Buffer
    
    init(sourceData: Data, width: Int, height: Int, rowBytes: Int) {
        // save data
        self._data = sourceData
        
        // get bytes pointer
        let ptr = _data.withUnsafeBytes {
            return UnsafeMutablePointer<UInt8>.init(mutating: $0)
        }
        
        // create vImage_Buffer
        self.buffer = vImage_Buffer(data: ptr, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)
    }
    
    private let _data: Data
}

internal class ImageBuffer: Bufferable {
    var buffer: vImage_Buffer
    
    init?(sourceImage: UIImage) {
        guard let image = sourceImage.cgImage
            else { return nil }
        
        //
        var format = vImage_CGImageFormat(bitsPerComponent: UInt32(image.bitsPerComponent), bitsPerPixel: UInt32(image.bitsPerPixel), colorSpace: nil, bitmapInfo: image.bitmapInfo, version: 0, decode: nil, renderingIntent: .defaultIntent)
        
        // init buffer
        self.buffer = vImage_Buffer()
        let error = vImageBuffer_InitWithCGImage(&buffer, &format, nil, image, vImage_Flags(kvImageNoFlags))
        
        // check if error
        guard error == kvImageNoError
            else { return nil }
    }
    
    deinit {
        free(buffer.data)
    }
}

public struct Bruno {
    public static func decode(srcBuffer: Bufferable) -> Bufferable? {
        let width = srcBuffer.width
        let height = srcBuffer.height
        
        // create empty data with proper count of bytes
        let rowBytes = width * 3
        let dstData = Data(count: height * rowBytes)
        let dstBuffer = RawBuffer(sourceData: dstData, width: width, height: height, rowBytes: rowBytes)
        
        // mutate buffer
        var buffer565 = srcBuffer.buffer
        var buffer888 = dstBuffer.buffer
        
        // convert
        let error = vImageConvert_RGB565toRGB888(&buffer565, &buffer888, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        //
        return dstBuffer
    }
    
    public static func encode(srcBuffer: Bufferable) -> Bufferable? {
        let width = srcBuffer.width
        let height = srcBuffer.height
        
        // create empty data with proper count of bytes
        let rowBytes = width * 2
        let dstData = Data(count: height * rowBytes)
        let dstBuffer = RawBuffer(sourceData: dstData, width: width, height: height, rowBytes: rowBytes)
        
        // mutate buffer
        var buffer565 = dstBuffer.buffer
        var buffer8888 = srcBuffer.buffer
        
        // convert
        let error = vImageConvert_RGBA8888toRGB565(&buffer8888, &buffer565, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        //
        return dstBuffer
    }
}

extension UIImage {
    public func encodeRGB565(width: Int, height: Int) -> Data? {
        // resize image
        guard let resizedImage = self.resize(width: width, height: height)
            else { return nil }
        
        // create source buffer
        guard let srcBuffer = ImageBuffer(sourceImage: resizedImage)
            else { return nil }
        
        // encode
        guard let dstBuffer = Bruno.encode(srcBuffer: srcBuffer)
            else { return nil }
        
        // get data
        return Data(bytes: dstBuffer.buffer.data, count: dstBuffer.buffer.rowBytes * Int(dstBuffer.buffer.height))
    }
}

extension Data {
    public func decodeRGB565(width: Int, height: Int) -> UIImage? {
        // create source buffer
        let srcBuffer = RawBuffer(sourceData: self, width: width, height: height, rowBytes: width * 2)
        
        // decode
        guard let dstBuffer = Bruno.decode(srcBuffer: srcBuffer)
            else { return nil }
        
        //
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 24, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue), version: 0, decode: nil, renderingIntent: .defaultIntent)
        
        //
        var buffer888 = dstBuffer.buffer
        var error: vImage_Error = 0
        let vImage = vImageCreateCGImageFromBuffer(&buffer888, &format, nil, nil, vImage_Flags(kvImageNoFlags), &error)
        guard error == kvImageNoError else { return nil }
        
        // create an UIImage
        return vImage.flatMap {
            UIImage(cgImage: $0.takeRetainedValue(), scale: 1.0, orientation: .up)
        }
    }
}

private extension UIImage {
    func resize(width: Int, height: Int) -> UIImage? {
        guard let cgImage = self.cgImage
            else { return nil }
        
        // create context for resized image
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        // draw resized image
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // get resized image from context
        return context?.makeImage()
            .flatMap { UIImage(cgImage: $0) }
    }
}


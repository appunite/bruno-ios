//
//  BrunoTests.swift
//  BrunoTests
//
//  Created by Emil Wojtaszek on 03/04/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import XCTest
@testable import Bruno

class BrunoTests: XCTestCase {

    func test_generate_example_blured_images() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 250, height: 250)

        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "kingfisher-3.jpg", in: bundle, compatibleWith: nil)

        let dimentsion = [250, 128, 64, 32, 16, 14, 12, 10, 8, 4, 2]
        for d in dimentsion {
            // encode image into RGB565
            let data = sourceImage?.encodeRGB565(width: d, height: d)

            // decode image into RGB888
            let image = data?.decodeRGB565(width: d, height: d)

            guard let cgImage = image?.cgImage
                else { fatalError() }

            // create context for resized image
            let context = CGContext(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(rect.width), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)

            // draw resized image
            context?.interpolationQuality = .high
            context?.draw(cgImage, in: rect)

            // get resized image from context
            let resizedImage = context?.makeImage()
                .flatMap { UIImage(cgImage: $0) }

            // apply Apple Blure Light Effect (radius 30)
            if let bluredImage = resizedImage?.applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8) {
                let url = URL(fileURLWithPath: "/tmp/image_blur_\(d)_r30.jpg")
                try? UIImagePNGRepresentation(bluredImage)?.write(to: url)
            }

            // apply Apple Blure Light Effect (radius 10)
            if let bluredImage = resizedImage?.applyBlurWithRadius(10, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8) {
                let url = URL(fileURLWithPath: "/tmp/image_blur_\(d)_r10.jpg")
                try? UIImagePNGRepresentation(bluredImage)?.write(to: url)
            }
        }
    }

    func test_encoding_rgb565() {
        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "pixels.png", in: bundle, compatibleWith: nil)

        // get RGB565 bytes
        let rgb565 = sourceImage!.encodeRGB565(width: 3, height: 1)!

        // get pixels
        let array = rgb565.withUnsafeBytes { (pointer: UnsafePointer<UInt16>) -> [UInt16] in
            let buffer = UnsafeBufferPointer(start: pointer,
                                             count: 3)
            return Array<UInt16>(buffer)
        }

        XCTAssertEqual(array[0], 0xF800) // test that first 2 bytes should represent RED pixel encoded in RGB565
        XCTAssertEqual(array[1], 0x07E0) // test that second 2 bytes should represent GREEN pixel encoded in RGB565
        XCTAssertEqual(array[2], 0x001F) // test that third 2 bytes should represent BLUE pixel encoded in RGB565
    }

    func test_decoding_rgb565() {
        // load data of random image (3x1)
        let base64Image = "APjgBx8A"
        let data = Data(base64Encoded: base64Image)!

        // get RGB8888 bytes
        let rgb888 = data
            .decodeRGB565(width: 3, height: 1)!
            .buffer(width: 3, height: 1)!

        // get pixels
        let array = rgb888.bytes.withUnsafeBytes { (pointer: UnsafePointer<UInt32>) -> [UInt32] in
            let buffer = UnsafeBufferPointer(start: pointer,
                                             count: 3)
            return Array<UInt32>(buffer)
        }

        XCTAssertEqual(array[0], 0xFF0000FF) // test that first 4 bytes should represent RED pixel encoded in RGB8888
        XCTAssertEqual(array[1], 0xFF00FF00) // test that second 4 bytes should represent GREEN pixel encoded in RGB8888
        XCTAssertEqual(array[2], 0xFFFF0000) // test that third 4 bytes should represent BLUE pixel encoded in RGB8888
    }

    func test_rgb565_bytes_count() {
        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "kingfisher-1.jpg", in: bundle, compatibleWith: nil)

        // encode image
        let encodeImage = sourceImage?.encodeRGB565(width: 10, height: 10)

        // image in encoded in RGB565, so each 2 bytes represents 1 pixel
        XCTAssertEqual(encodeImage?.count, 10 * 10 * 2)
    }
    
    func test_rgb565_encoding_performance() {
        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "kingfisher-1.jpg", in: bundle, compatibleWith: nil)
        
        // encode image
        self.measure {
            _ = sourceImage?.encodeRGB565(width: 10, height: 10)
        }
    }

    func test_rgb565_decoding_performance() {
        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "kingfisher-1.jpg", in: bundle, compatibleWith: nil)

        // encode image
        let encodeImage = sourceImage?.encodeRGB565(width: 10, height: 10)

        // decode image
        self.measure {
            _ = encodeImage?.decodeRGB565(width: 10, height: 10)
        }
    }

}

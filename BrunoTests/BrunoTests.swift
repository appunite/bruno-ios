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
    
    func test_encoding_and_decoding_image_should_be_equal() {
        // load data of random image (8x8)
        let base64Image = "oRFBEcEZIjMiMwIzxUwkTeQx5jEnMklD6EuuKukyAzOpWqxi7DFxKpZk90OKOqIqIiJiIUMZSypuKu8ZTDIlOmIigRlCKqlCZlPGGcgxiVpCIsEZIyoDM0Q8oirBIaIZoyqhGWMqgyLCIuIZYRFhEeMyYirjOsIqAjNiKsEZwRk="
        let data = Data(base64Encoded: base64Image)
        
        // decode image
        let decodeImage = data?.decodeRGB565(width: 8, height: 8)
        
        // encode image
        let encodeImage = decodeImage?.encodeRGB565(width: 8, height: 8)
        
        // check if transformation goes ok
        XCTAssertEqual(encodeImage, data)
    }
    
    func test_bytes_count() {
        // laod image
        let bundle = Bundle.init(for: BrunoTests.self)
        let sourceImage = UIImage.init(named: "kingfisher-1.jpg", in: bundle, compatibleWith: nil)
        
        // encode image
        let encodeImage = sourceImage?.encodeRGB565(width: 10, height: 10)
        
        // image in encoded in RGB565, so each 2 bytes represents 1 pixel
        XCTAssertEqual(encodeImage?.count, 10 * 10 * 2)
    }
}


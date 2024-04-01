//
//  ImageHelperTests.swift
//  HearthstoneTests
//
//  Created by Jarede Lima on 31/03/24.
//

import XCTest
@testable import Hearthstone

final class ImageHelperTests: XCTestCase {
    
    func testImageForURL_WhenNoImageCached_ShouldReturnNotNil() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        
        // When
        let image = ImageHelper.shared.image(for: url)
        
        // Then
        XCTAssertNotNil(image)
    }
    
    func testCacheImageForURL_WhenImageCached_ShouldReturnCachedImage() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        let testImage = UIImage(named: "testImage")
        ImageHelper.shared.cache(image: testImage ?? UIImage(), for: url)
        
        // When
        let cachedImage = ImageHelper.shared.image(for: url)
        
        // Then
        if let cachedImage = cachedImage {
            XCTAssertEqual(testImage?.pngData(), cachedImage.pngData(), "Cached image should be equal to test image")
        } else {
            let systemImage = UIImage(systemName: "photo.artframe.circle.fill")?.withTintColor(.systemGray)
            XCTAssertEqual(cachedImage, systemImage, "Cached image should be system image when nil")
        }
    }
    
    func testLoadImageFromURL_WhenValidURL_ShouldLoadImage() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        let expectation = XCTestExpectation(description: "Load image from URL")
        
        // When
        ImageHelper.shared.loadImage(from: url) { (image) in
            // Then
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        // Wait for expectation
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadImageFromURL_WhenInvalidURL_ShouldNotLoadImage() {
        // Given
        let url = URL(string: "https://example.com/invalid-url")!
        let expectation = XCTestExpectation(description: "Attempt to load image from invalid URL")
        
        // When
        ImageHelper.shared.loadImage(from: url) { (image) in
            // Then
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        // Wait for expectation
        wait(for: [expectation], timeout: 5.0)
    }
}

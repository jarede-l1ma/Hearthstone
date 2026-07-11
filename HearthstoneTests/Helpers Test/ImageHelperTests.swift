import Testing
import UIKit
@testable import Hearthstone

struct ImageHelperTests {
    
    @Test func imageForURL_WhenNoImageCached_ShouldReturnNil() {
        // Given
        let url = URL(string: "https://example.com/no-image-cached-\(UUID().uuidString).png")!
        
        // When
        let image = ImageHelper.shared.image(for: url)
        
        // Then
        #expect(image == nil)
    }
    
    @Test func cacheImageForURL_WhenImageCached_ShouldReturnCachedImage() {
        // Given
        let url = URL(string: "https://example.com/cached-image-\(UUID().uuidString).png")!
        let testImage = UIImage(systemName: "camera") ?? UIImage()
        
        ImageHelper.shared.cache(image: testImage, for: url)
        
        // When
        let cachedImage = ImageHelper.shared.image(for: url)
        
        // Then
        #expect(cachedImage != nil)
        #expect(testImage.pngData() == cachedImage?.pngData())
    }
    
    @Test func loadImageFromURL_WhenValidURL_ShouldLoadImage() async {
        // Given
        let url = URL(string: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_298.png")!
        
        // When
        let image: UIImage? = await withCheckedContinuation { continuation in
            ImageHelper.shared.loadImage(from: url) { img in
                continuation.resume(returning: img)
            }
        }
        
        // Then
        #expect(image != nil)
    }
    
    @Test func loadImageFromURL_WhenInvalidURL_ShouldNotLoadImage() async {
        // Given
        let url = URL(string: "https://invalid-url-that-does-not-exist-\(UUID().uuidString).com/img.png")!
        
        // When
        let image: UIImage? = await withCheckedContinuation { continuation in
            ImageHelper.shared.loadImage(from: url) { img in
                continuation.resume(returning: img)
            }
        }
        
        // Then
        #expect(image == nil)
    }
}

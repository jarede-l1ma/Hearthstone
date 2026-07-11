import Testing
@testable import Hearthstone

struct StringHTMLTests {
    
    @Test func htmlToAttributedString_WithBoldTags_ShouldReturnAttributedStringWithBoldStyle() {
        // Given
        let htmlString = "This is <b>bold</b> text."
        
        // When
        let attrString = htmlString.htmlToAttributedString(fontSize: 16, color: .black)
        
        // Then
        #expect(attrString != nil)
        let stringValue = attrString?.string ?? ""
        #expect(stringValue.contains("This is bold text."))
    }
    
    @Test func htmlToAttributedString_WithItalicTags_ShouldReturnAttributedStringWithItalicStyle() {
        // Given
        let htmlString = "This is <i>italic</i> text."
        
        // When
        let attrString = htmlString.htmlToAttributedString(fontSize: 16, color: .black)
        
        // Then
        #expect(attrString != nil)
        let stringValue = attrString?.string ?? ""
        #expect(stringValue.contains("This is italic text."))
    }
    
    @Test func htmlToAttributedString_WithEmptyString_ShouldReturnEmptyAttributedString() {
        // Given
        let htmlString = ""
        
        // When
        let attrString = htmlString.htmlToAttributedString()
        
        // Then
        #expect(attrString != nil)
        #expect(attrString?.string.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    }
}

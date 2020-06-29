import XCTest
@testable import BuGuaKit

final class BuGuaKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BuGuaKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

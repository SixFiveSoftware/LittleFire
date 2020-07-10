import XCTest
@testable import LittleFire

final class LittleFireTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LittleFire().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

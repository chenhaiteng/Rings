import XCTest

@testable import Rings
@testable import CoreGraphicsExtension

final class RingTextTests: XCTestCase {
    func testCGAngleExt() {
        let zeroAngle = CGAngle.zero.toAngle()
        let rightAngle = CGAngle.degrees(90.0).toAngle()
        XCTAssertEqual(zeroAngle.degrees, 0)
        XCTAssertEqual(rightAngle.degrees, 90)
    }

    static var allTests = [
        ("testCGAngleExt", testCGAngleExt),
    ]
}

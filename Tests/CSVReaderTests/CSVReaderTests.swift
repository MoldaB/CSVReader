import XCTest
@testable import CSVReader

final class CSVReaderTests: XCTestCase {
    
    func testStringCSV() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let value = "letter,number\r\na,1\r\nb,2\r\nc,3"
        let expected = ["letter":["a","b","c"],
                        "number":["1","2","3",]]
        let reader = CSVReader()
        XCTAssertEqual(reader.parseCSV(value),expected)
    }


    static var allTests = [
        ("string test", testStringCSV),
    ]
}

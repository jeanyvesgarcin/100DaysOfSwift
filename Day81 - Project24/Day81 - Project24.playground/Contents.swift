//  Day81 - Project23
//
//  Created by Jean-Yves Garcin on 27/06/2023.
//

import UIKit

// Challenge part 1


extension String {
    func withPrefix(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else { return self }
        return String("\(prefix)\(self)")
    }
}

let test = "pet"
let test2 = "carpet"
let test3 = "pet2"
let test4 = "car"

test.withPrefix("car")
test2.withPrefix("car")
test3.withPrefix("car")
test4.withPrefix("car")

// Challenge part 2


extension String {
    func isNumeric() -> Bool {
        guard (Double(self) != nil) else { return false }
        return true
    }
}

let number = "123"
let number2 = "A123"
let number3 = "1.23"
let number4 = "1"

number.isNumeric()
number2.isNumeric()
number3.isNumeric()
number4.isNumeric()

// Challenge part  3


extension String {
    func lines() -> [String] {
        return self.components(separatedBy: "\n")
    }
}

let line = ""
let line2 = "hello\nworld"
let line3 = "1"
let line4 = "hello\nworld\nthere"

line.lines()
line2.lines()
line3.lines()
line4.lines()

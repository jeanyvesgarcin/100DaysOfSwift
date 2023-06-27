//  Day82 - Milestone - Project22-23-24
//
//  Created by Jean-Yves Garcin on 27/06/2023.
//

import UIKit

// Challenge part 1


extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let testView = UIView()
testView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
print("size width=\(testView.frame.width)")
testView.bounceOut(duration: 10)
print("size width=\(testView.frame.width)")


// Challenge part 2


extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

5.times { print("Hello!") }
0.times { print("Hello!") }
10.times { print("Hello!") }


// Challenge part 3


extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

var arr = ["gray", "yellow", "white"]
arr.remove(item: "gray")
arr.remove(item: "white")

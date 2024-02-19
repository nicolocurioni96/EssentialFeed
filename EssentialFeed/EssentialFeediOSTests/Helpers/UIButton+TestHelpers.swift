//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 19/02/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

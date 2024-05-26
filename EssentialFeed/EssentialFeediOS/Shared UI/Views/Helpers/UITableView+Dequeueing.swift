//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 17/02/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

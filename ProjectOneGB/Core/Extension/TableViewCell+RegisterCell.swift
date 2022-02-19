//
//  TableViewCell+RegisterCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 02.02.2022.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension UITableView {
    
    func registerWithNib<T: UITableViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        let nib = UINib(nibName: String(describing: registerClass.self), bundle: nil)
        register(nib, forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        register(registerClass, forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

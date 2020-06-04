//
//  UIViewExtension.swift
//  OpenWeather
//
//  Created by Nuno Simões on 02/06/2020.
//  Copyright © 2020 Nuno Simões. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

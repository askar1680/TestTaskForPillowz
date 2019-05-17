//
//  UIImage+Extensions.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let renderingMode = self.renderingMode
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result?.withRenderingMode(renderingMode)
    }
}

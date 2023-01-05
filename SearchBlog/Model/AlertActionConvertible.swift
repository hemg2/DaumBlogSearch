//
//  AlertActionConvertible.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import UIKit


protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

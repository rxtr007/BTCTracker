//
//  Utils.swift
//  BTCTracker
//
//  Created by Sachin Ambegave on 26/10/21.
//

import Foundation

func threadOnMain(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
}

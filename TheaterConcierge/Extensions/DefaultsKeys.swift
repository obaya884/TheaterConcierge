//
//  DefaultsKeys.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/09.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    public static let movieListOrder = DefaultsKey<Int>("movieListOrder", defaultValue: 0)
    public static let currentAddress = DefaultsKey<String>("cuurentAddress", defaultValue: "")
}

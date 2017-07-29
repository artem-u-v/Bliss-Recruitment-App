//
//  GlobalFunctions.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation

func loc(_ localizedString:String) -> String{
    let text = Bundle.main.localizedString(forKey: localizedString, value: nil, table: nil)
    return text
}

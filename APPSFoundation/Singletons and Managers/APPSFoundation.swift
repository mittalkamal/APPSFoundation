//
//  APPSFoundation.swift
//  APPSFoundation
//
//  Created by Ken Grigsby on 1/10/17.
//  Copyright © 2017 Appstronomy, LLC. All rights reserved.
//

import UIKit

/**
 Provides some class method conveniences related to dealing with resources and queries
 about this Appstronomy Foundation framework.
 */
open class APPSFoundation: NSObject {
    
    /**
     @return A reference to the bundle for this Appstronomy Foundation framework.
     */
    open static var bundle: Bundle {
        return Bundle(for: self)
    }
}

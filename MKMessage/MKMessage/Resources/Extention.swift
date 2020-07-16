//
//  Extention.swift
//  MKMessage
//
//  Created by Upetch Ventures on 16/07/20.
//  Copyright © 2020 Upetch Ventures. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    public var Width: CGFloat {
        return self.frame.size.width
    }
    
    public var Height: CGFloat {
        return self.frame.size.height
    }
    
    public var Top: CGFloat {
        return self.frame.origin.y
    }
    
    public var Bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var Left: CGFloat {
        return self.frame.origin.x
    }
    
    public var Right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
    
}

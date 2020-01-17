//
//  Combinable.swift
//  swiftgen
//
//  Created by Harikrishnan Manmadhan Sreelatha on 21.01.20.
//  Copyright © 2020 AliSoftware. All rights reserved.
//

import Foundation

private protocol Combinable {
  func combining<T>(_ right: T) -> Self?
}

public extension Dictionary {

  /**
   Merge Dictionaries

   - Parameter left: Dictionary to update
   - Parameter right:  Source dictionary with values to be merged

   - Returns: Merged dictionay
   */


  func merge(_ right: Dictionary) -> Dictionary {
    var merged = self
    for (key, rhs) in right {
      // case of existing left value
      if let lhs = self[key] {
        if let lhs = lhs as? Combinable {
          let modified = lhs.combining(rhs)
          merged[key] = modified as? Value
        } else if !(lhs is Combinable ), let _ = lhs as? NSArray {
          assert(false, "Dictionary literals use incompatible Foundation Types")
        } else if !(lhs is Combinable ), let _ = lhs as? NSDictionary {
          assert(false, "Dictionary literals use incompatible Foundation Types")
        } else {
          merged[key] = rhs
        }
      }
        // case of no existing value
      else {
        merged[key] = rhs
      }
    }

    return merged
  }
}

extension Array: Combinable {
  func combining<T>(_ right: T) -> Self? {
    if let right = right as? Array {
      return (self + right)
    } else if let right = right as? Element {
      return self + [right]
    }
    assert(false)
    return nil
  }
}


extension Dictionary: Combinable {
  func combining<T>(_ right: T) -> Self? {
    if let right = right as? Dictionary {
      return self.merge(right)
    }
    assert(false)
    return nil
  }
}


extension Set: Combinable {
  func combining<T>(_ right: T) -> Self? {
    if let right = right as? Set {
      return self.union(right)
    }
    assert(false)
    return nil
  }
}

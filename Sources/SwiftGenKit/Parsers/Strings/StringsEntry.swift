//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  struct Entry {
    let key: String
    let translation: String
    let types: [PlaceholderType]
    let keyStructure: [String]
    private static var keysToFilterOut: [String] = []
    private static var separator = CharacterSet(charactersIn: "_")

    init(key: String,
         translation: String,
         types: [PlaceholderType],
         keysToFilterOut: [String],
         separator: String) {
      self.key = key
      self.translation = translation
      self.types = types
      Entry.keysToFilterOut = keysToFilterOut
      Entry.separator = CharacterSet(charactersIn: separator)
      self.keyStructure = Entry.split(key: key)
    }

    init(key: String, translation: String, keysToFilterOut: [String], separator: String, types: PlaceholderType...) {
      self.init(key: key, translation: translation, types: types, keysToFilterOut: keysToFilterOut, separator: separator)
    }

    init(key: String, translation: String, keysToFilterOut: [String], separator: String) throws {
      let types = try PlaceholderType.placeholders(fromFormat: translation)
      self.init(key: key, translation: translation, types: types, keysToFilterOut: keysToFilterOut, separator: separator)
    }

    // MARK: - Structured keys

    private static func split(key: String) -> [String] {
      return key
        .components(separatedBy: Entry.separator)
        .filter { !$0.isEmpty && !Entry.mustExclude(key: $0) }
    }

    private static func mustExclude(key string: String) -> Bool {
      for key in Entry.keysToFilterOut where key == string {
        return true
      }
      return false
    }
  }
}

//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Strings {
  public enum ParserError: Error, CustomStringConvertible {
    case duplicateTable(name: String)
    case failureOnLoading(path: String)
    case invalidFormat
    case invalidPlaceholder(previous: Strings.PlaceholderType, new: Strings.PlaceholderType)
    case dependenciesNotInjected

    public var description: String {
      switch self {
      case .duplicateTable(let name):
        return "Table \"\(name)\" already loaded, cannot add it again"
      case .failureOnLoading(let path):
        return "Failed to load a file at \"\(path)\""
      case .invalidFormat:
        return "Invalid strings file"
      case .invalidPlaceholder(let previous, let new):
        return "Invalid placeholder type \(new) (previous: \(previous))"
      case .dependenciesNotInjected:
        return "Separator and Keys to filter out are not injected"
      }
    }
  }

  public final class Parser: SwiftGenKit.Parser {
    var tables = [String: [Entry]]()
    public var warningHandler: Parser.MessageHandler?
    public var keysToFilterOut: [String]?
    public var separator: String?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = "[^/]\\.strings$"

    // Localizable.strings files are generally UTF16, not UTF8!
    public func parse(path: Path, relativeTo parent: Path) throws {
      let name = path.lastComponentWithoutExtension

      guard let keysToFilterOut = keysToFilterOut, let separator = separator  else {
        throw ParserError.dependenciesNotInjected
      }

      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }
      let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
      guard let dict = plist as? [String: Any] else {
        throw ParserError.invalidFormat
      }

      let entries = try dict.map { key, value -> Entry in
        let translation = (value as? String) ?? "This is a `stringsdict` format"
        return try Entry(key: key, translation: translation, keysToFilterOut: keysToFilterOut, separator: separator)
      }

      if var existingEntries = tables[name] {
        existingEntries.append(contentsOf: entries)
        tables[name] = existingEntries
      } else {
        tables[name] = entries
      }
    }
  }
}

Pod::Spec.new do |s|
  s.name         = 'SwiftGenPlus'
  s.version      = '6.2.0'
  s.summary      = 'A collection of Swift tools to generate Swift code for your assets, storyboards, strings, …'

  s.description  = <<-DESC
                   A collection of Swift tools to generate Swift code constants (enums or static lets) for:
                   * asset catalogs,
                   * colors,
                   * fonts
                   * localized strings,
                   * storyboards,
                   * … and more
                   DESC

  s.homepage     = 'https://github.com/moia-hari/SwiftGenPlus'
  s.license      = 'MIT'
  s.author       = {
    'Olivier Halligon' => 'olivier@halligon.net'
  }
  s.social_media_url = 'https://twitter.com/aligatr'

  s.source = {
    http: "https://github.com/moia-hari/SwiftGenPlus/releases/download/#{s.version}/swiftgenplus-#{s.version}.zip"
  }
  s.preserve_paths = '*'
  s.exclude_files = '**/file.zip'
end

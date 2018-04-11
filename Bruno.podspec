Pod::Spec.new do |s|
  s.name = "Bruno"
  s.version = "0.0.1"
  s.summary = "This simple lib helps you to represent image in RGB565 format."

  s.description = <<-DESC
  This simple lib helps you to represent image in RGB565 format.
  DESC

  s.homepage = "https://github.com/appunite/bruno-ios"

  s.license = "MIT"
  s.authors = {
    "Emil Wojtaszek" => "emil@appunite.com"
  }
 
  s.platform = s.platform = :ios, "8.0"
  s.swift_version = "3.2"
  s.social_media_url = "https://www.appunite.com"

  s.source = {
    :git => "https://github.com/appunite/bruno-ios.git",
    :branch => "master"
  }

  s.source_files  = "Bruno/**/*.swift"
end

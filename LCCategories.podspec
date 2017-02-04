Pod::Spec.new do |s|
  s.name         = "LCCategories"
  s.version      = "0.0.2"
  s.summary      = "LCCategories is a Objective-C category set"
  s.homepage     = "https://github.com/Little-Captain/LCCategories"
  s.license      = "MIT"
  s.author       = { "Little-Captain" => "littlecaptain@foxmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/Little-Captain/LCCategories.git", :tag => s.version }
  s.source_files  = "LCCategories/*.{h,m}"
  s.requires_arc = true
end

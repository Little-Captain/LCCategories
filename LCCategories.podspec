Pod::Spec.new do |s|
  s.name         = "LCCategories"
  s.version      = "0.0.1"
  s.summary      = "iOS开发中常用的一些分类方法"
  s.homepage     = "https://github.com/Little-Captain/LCCategories"
  s.license      = "MIT"
  s.author       = { "Little-Captain" => "littlecaptain@foxmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/Little-Captain/LCCategories.git", :tag => s.version }
  s.source_files  = "LCCategories/*.{h,m}"
  s.requires_arc = true
end

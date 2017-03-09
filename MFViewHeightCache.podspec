Pod::Spec.new do |s|
  s.name         = "MFViewHeightCache"
  s.version      = "MFViewHeightCache-1.0.0"
  s.summary      = "Height calculate and cache for auto layout views."
  s.homepage     = "https://github.com/Tinghui/UITableView-CellHeightCalculation"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Tinghui" => "tinghui.zhang3@gmail.com" }
  s.source       = { :git => "https://github.com/Tinghui/UITableView-CellHeightCalculation.git", :tag => s.version }
  s.source_files = "Source/MFViewHeightCache/*.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, "6.0"
end

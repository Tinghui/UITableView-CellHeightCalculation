Pod::Spec.new do |s|
  s.name         = "UITableView+CellHeightCalculation"
  s.version      = "1.0.3"
  s.summary      = "Auto layout UITableViewCell height calculate and cache."
  s.homepage     = "https://github.com/Tinghui/UITableView-CellHeightCalculation"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Tinghui" => "tinghui.zhang3@gmail.com" }
  s.requires_arc = true
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/Tinghui/UITableView-CellHeightCalculation.git", :tag => s.version }
  s.source_files = "Source/UITableView+CellHeightCalculation.{h,m}"
  s.dependency "MFViewHeightCache", "~> 1.0.2"
end

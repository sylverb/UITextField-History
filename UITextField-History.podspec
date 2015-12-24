Pod::Spec.new do |s|
  s.name          = "UITextField-History"
  s.version       = "1.0.0"
  s.summary       = "A extension of UITextField that can automic record user's input history"
  s.homepage      = "https://github.com/Jameson-zxm/UITextField-History"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Jameson-zxm" => "morenotepad@163.com" }
  s.platform      = :ios, '8.0'
  s.source        = { :git => "https://github.com/Jameson-zxm/UITextField-History.git", :tag => "v#{s.version}" }
  s.source_files  = 'Source', 'Source/**/*.{swift}'
  s.requires_arc  = true
end


Pod::Spec.new do |s|

s.name         = "XBCustomPopView"
s.version      = "0.0.2"
s.summary      = "自定义各种弹窗，只需传入展示视图即可"
s.description  = "QQ624784368,博客http://www.cnblogs.com/xbios/"

s.homepage     = "https://github.com/xb901203//XBCustomPopView"
s.license      = "MIT"
s.author             = { "xubin" => "xb624784368@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/xb901203/XBCustomPopView.git", :tag => "0.0.2" }

s.source_files  = "XBCustomPopView/**/*"
s.frameworks    = "Foundation", "UIKit"
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }


s.requires_arc = true


end

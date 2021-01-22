
Pod::Spec.new do |s|
  s.name         = "JSLayoutSizeFit"
  s.version      = "0.2.7"
  s.summary      = "JSLayoutSizeFit"
  s.homepage     = "https://github.com/jiasongs/JSLayoutSizeFit"
  s.author       = { "jiasong" => "593908937@qq.com" }
  s.platform     = :ios, "10.0"
  s.swift_versions = ["4.2", "5.0"]
  s.source       = { :git => "https://github.com/jiasongs/JSLayoutSizeFit.git", :tag => "#{s.version}" }
  s.frameworks   = "Foundation", "UIKit"
  s.license      = "MIT"
  s.requires_arc = true
  s.source_files = "Sources/*.{h,m}"

  s.dependency "JSCoreKit"

  s.default_subspec = "Core"
  s.subspec "Core" do |ss|
    ss.source_files = "Sources/Core", "Sources/Core/Private/*.{h,m}"
    ss.private_header_files = "Sources/Core/Private/*.{h,m}"
  end

  s.subspec "ExtensionForSwift" do |ss|
    ss.source_files = "Sources/Swift/*.{swift,h,m}"
    ss.dependency "JSLayoutSizeFit/Core"
  end
end

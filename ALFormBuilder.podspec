Pod::Spec.new do |s|
    s.name                  = "ALFormBuilder"
    s.version               = "0.9"
    s.summary               = "Provides convenient work with TableView"
    s.description           = <<-DESC
    FormBuilder
    DESC

    s.homepage              = "https://github.com/alobanov/ALFormBuilder"
    s.license               = { :type => "MIT", :file => "LICENSE" }
    s.author                = { "Lobanov Aleksey" => "lobanov.aw@gmail.com" }
    s.source                = { :git => "git@github.com:alobanov/ALFormBuilder.git", :tag => s.version.to_s }
    s.social_media_url      = "https://twitter.com/alobanov"
    s.ios.deployment_target = '9.0'
    s.default_subspec = "Core"
    s.source_files = 'Sources/**/*'

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/FormBuilder/**/*"
    ss.dependency "SwiftyJSON"
    ss.dependency "ObjectMapper"
    ss.framework  = "Foundation"
    ss.framework  = "UIKit"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Sources/RxFormBuilder/**/*"
    ss.dependency "ALFormBuilder/Core"
    s.dependency 'RxSwift', '~> 3'
    s.dependency 'RxCocoa', '~> 3'
    s.dependency 'RxDataSources'
  end
end

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
    s.source_files = 'Sources/FormBuilder/**/*.swift'

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/FormBuilder/**/*.swift"
    ss.dependency "SwiftyJSON"
    ss.dependency "ObjectMapper"
    ss.framework  = "Foundation"
    ss.framework  = "UIKit"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Sources/RxFormBuilder/**/*.swift"
    ss.dependency "ALFormBuilder/Core"
    ss.resource_bundles = {'ALFormBuilder' => ['Sources/RxFormBuilder/Components/cells/*.xib']}
    ss.dependency 'RxSwift', '~> 4.0'
    ss.dependency 'RxCocoa', '~> 4.0'
    ss.dependency 'RxDataSources'
  end
end

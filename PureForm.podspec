Pod::Spec.new do |s|
    s.name                  = "PureForm"
    s.version               = "0.0.2"
    s.summary               = "Easy form creator based on JSON"
    s.homepage              = "https://github.com/unboxme/PureForm"
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { "Pavel Puzyrev" => "cannedapp@yahoo.com" }
    s.platform              = :ios, '8.0'
    s.source                = { :git => "https://github.com/unboxme/PureForm.git", :tag => s.version.to_s }

    s.source_files          = 'PureForm/**/*.{h,m}'
    s.public_header_files   = 'PureForm/**/*.h'

    s.framework             = 'Foundation'
    s.requires_arc          = true
end

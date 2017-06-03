Pod::Spec.new do |s|

  s.name         = "ViewComposer"
  s.version      = "0.1.2"
  s.summary      = "Compose views using enums swiftly"

  s.description  = <<-DESC
                  Declare Buttons, Labels, StackViews etc as a list of enums.
                   DESC

  s.homepage     = "https://github.com/sajjon/ViewComposer"
  s.license      = 'MIT'
  s.author       = { "Alexander Cyon" => "alex.cyon@gmail.com" }
  s.social_media_url = "https://twitter.com/Redrum_237"
  s.source = { :git => 'https://github.com/Sajjon/ViewComposer.git', :tag => s.version }
  s.source_files = 'ViewComposer/Source/**/*.swift', 'ViewComposer/Sourcery/Generated/*.swift'
  s.ios.deployment_target = '9.0'
end

Pod::Spec.new do |s|
  s.name             = 'DefectRecording'
  s.version          = '0.2.4'
  s.summary          = 'Defect reporting in app'
 
  s.description      = <<-DESC
Defect Reporting in App by screen capture or screen recording!
                       DESC
 
  s.homepage         = 'https://github.com/namthipip/DefectReporting'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'namthip silsuwan' => 'namthipip@gmail.com' }
  s.source           = { :git => 'https://github.com/namthipip/DefectReporting.git', :branch => 'master', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'DefectRecording/*'
  s.resource_bundles = {'DefectRecording' => ['DefectRecording/*.{lproj,storyboard}']}
 
end
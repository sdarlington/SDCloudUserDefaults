Pod::Spec.new do |s|

  s.name         = "SDCloudUserDefaults"
  s.version      = "1.0.2"
  s.summary      = "Store NSUserDefaults and iCloud data at the same time."

  s.description  = <<-DESC
                   Store NSUserDefaults and iCloud key-value store data at the same time.
                   
                   Only key-values that you specify are synced between the local
                   NSUserDefaults store and iCloud making it nice and simple
                   to use.
                   DESC

  s.homepage     = "https://github.com/sdarlington/SDCloudUserDefaults"
  s.license      = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author             = "Stephen Darlington"
  s.social_media_url = "http://twitter.com/sdarlington"
  s.platforms     =  { :ios => '6.0', :osx => '10.10' }
  s.source       = { :git => "https://github.com/sdarlington/SDCloudUserDefaults.git", :tag => s.version }
  s.source_files  = 'SDCloudUserDefaults/SDCloudUserDefaults.{h,m}'
  s.public_header_files = 'SDCloudUserDefaults/SDCloudUserDefaults.h'
  s.requires_arc  = false
end

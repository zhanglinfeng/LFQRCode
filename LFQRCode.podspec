Pod::Spec.new do |s|
s.name = 'LFQRCode'
s.version = '1.0'
s.license = { :type => "MIT", :file => "LICENSE" }
s.summary = '简单易用的扫二维码条形码控件，扫描界面可由使用者在自己控制器灵活定义'
s.homepage = 'https://github.com/zhanglinfeng/LFQRCode'
s.authors = { '张林峰' => '1051034428@qq.com' }
s.source = { :git => 'https://github.com/zhanglinfeng/LFQRCode.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'LFQRCode/LFQRCode/*.{h,m}'
end

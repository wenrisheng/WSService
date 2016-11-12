
workspace 'ServiceDemo'

platform :ios, '8.0'
inhibit_all_warnings!

project 'ServiceDemo/ServiceDemo'
project 'WSService/WSService'

# 项目
target :ServiceDemo do
    pod 'ASIHTTPRequest'
    pod 'AFNetworking'
    project 'ServiceDemo/ServiceDemo'
end

# service
target :WSService do
    pod 'AFNetworking'
     pod 'ASIHTTPRequest'
    project 'WSService/WSService'
end






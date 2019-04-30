#Interfacing

A layer collectively display classes that can be used to interface –configuring, customizing, message passing– with RxNetworking implementation level. Consists of the following classes

1. TargetType
2. PluginType

##TargetType
Like the Moya library, consumers are meant to describe HTTP target to tells RxNetworking the endpoint, method, path & parameters so on and so forth. That would give HTTPClient object enough information to work on the request and retrieve response accordingly

##PluginType
Like Moya again, consumers can describe their own plugin by conforming to this class to gain more granularity control over the request and/or response.  

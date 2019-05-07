#Interfacing

A layer collectively display classes that can be used to interface –configuring, customizing, message passing– with RxNetworking implementation level. Consists of the following classes

1. TargetType
2. AccessTokenAuthorizable
3. PluginType

##TargetType
Like the Moya library, consumers are meant to describe HTTP target to tells RxNetworking the endpoint, method, path & parameters so on and so forth. That would give HTTPClient object enough information to work on the request and retrieve response accordingly

##AccessTokenAuthorizable
Same as target type but provides one more interface property specifically for authentication. When HTTPClient found that target type is conforming to this class it will try to ask if API should be authenticated or not and set proper authentication headers necessary for the request.

##PluginType
Like Moya again, consumers can describe their own plugin by conforming to this class to gain more granularity control over the request and/or response.  

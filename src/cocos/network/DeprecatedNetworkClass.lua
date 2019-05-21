if nil == cc.XMLHttpRequest then
    return
end
-- This is the DeprecatedNetworkClass

DeprecatedNetworkClass = {} or DeprecatedNetworkClass

--WebSocket class will be Deprecated,begin
function DeprecatedNetworkClass.WebSocket()
    deprecatedTip("WebSocket","cc.WebSocket")
    return cc.WebSocket
end
_G["WebSocket"] = DeprecatedNetworkClass.WebSocket()
--WebSocket class will be Deprecated,end


local Event = class("Event")

local EXPORTED_METHODS = {
    "addEventListener",
    "dispatchEvent",
    "removeEventListener",
    "removeEventListenersByTag",
    "removeEventListenersByEvent",
    "removeAllEventListeners",
    "hasEventListener",
    "dumpAllEventListeners",
}

function Event:init_(target)
    target.listeners_ = {}
    target.nextListenerHandleIndex_ = 0
    self.target_ = target
    self.listeners_ = {}
    self.target_.nextListenerHandleIndex_ = 0
end

function Event:bind(target)
    self:init_(target)
    cc.setmethods(target, self, EXPORTED_METHODS)
    -- self.target_ = target
    -- self.target_.listeners_ = {}
end

function Event:unbind(target)
    cc.unsetmethods(target, EXPORTED_METHODS)
    self:init_()
end

function Event:on(eventName, listener, tag)
    assert(type(eventName) == "string" and eventName ~= "",
        "Event:addEventListener() - invalid eventName")
    eventName = string.upper(eventName)
    if self.target_.listeners_[eventName] == nil then
        self.target_.listeners_[eventName] = {}
    end

    self.target_.nextListenerHandleIndex_ = self.target_.nextListenerHandleIndex_ + 1
    local handle = tostring(self.target_.nextListenerHandleIndex_)
    tag = tag or ""
    self.target_.listeners_[eventName][handle] = {listener, tag}

    if DEBUG > 1 then
        printInfo("%s [Event] addEventListener() - event: %s, handle: %s, tag: \"%s\"",
                  tostring(self.target_), eventName, handle, tostring(tag))
    end

    return self.target_, handle
end

Event.addEventListener = Event.on

function Event:dispatchEvent(event)
    event.name = string.upper(tostring(event.name))
    local eventName = event.name
    if DEBUG > 1 then
        printInfo("%s [Event] dispatchEvent() - event %s", tostring(self.target_), eventName)
    end

    dump(self.target_.listeners_, '##')
    if self.target_.listeners_[eventName] == nil then return end
    event.target = self.target_
    event.stop_ = false
    event.stop = function(self)
        self.stop_ = true
    end

    for handle, listener in pairs(self.target_.listeners_[eventName]) do
        if DEBUG > 1 then
            printInfo("%s [Event] dispatchEvent() - dispatching event %s to listener %s", tostring(self.target_), eventName, handle)
        end
        -- listener[1] = listener
        -- listener[2] = tag
        event.tag = listener[2]
        listener[1](event)
        if event.stop_ then
            if DEBUG > 1 then
                printInfo("%s [Event] dispatchEvent() - break dispatching for event %s", tostring(self.target_), eventName)
            end
            break
        end
    end

    return self.target_
end

function Event:removeEventListener(handleToRemove)
    for eventName, listenersForEvent in pairs(self.target_.listeners_) do
        for handle, _ in pairs(listenersForEvent) do
            if handle == handleToRemove then
                listenersForEvent[handle] = nil
                if DEBUG > 1 then
                    printInfo("%s [Event] removeEventListener() - remove listener [%s] for event %s", tostring(self.target_), handle, eventName)
                end
                return self.target_
            end
        end
    end

    return self.target_
end

function Event:removeEventListenersByTag(tagToRemove)
    for eventName, listenersForEvent in pairs(self.target_.listeners_) do
        for handle, listener in pairs(listenersForEvent) do
            -- listener[1] = listener
            -- listener[2] = tag
            if listener[2] == tagToRemove then
                listenersForEvent[handle] = nil
                if DEBUG > 1 then
                    printInfo("%s [Event] removeEventListener() - remove listener [%s] for event %s", tostring(self.target_), handle, eventName)
                end
            end
        end
    end

    return self.target_
end

function Event:removeEventListenersByEvent(eventName)
    self.target_.listeners_[string.upper(eventName)] = nil
    if DEBUG > 1 then
        printInfo("%s [Event] removeAllEventListenersForEvent() - remove all listeners for event %s", tostring(self.target_), eventName)
    end
    return self.target_
end

function Event:removeAllEventListeners()
    self.target_.listeners_ = {}
    if DEBUG > 1 then
        printInfo("%s [Event] removeAllEventListeners() - remove all listeners", tostring(self.target_))
    end
    return self.target_
end

function Event:hasEventListener(eventName)
    eventName = string.upper(tostring(eventName))
    local t = self.target_.listeners_[eventName]
    for _, __ in pairs(t) do
        return true
    end
    return false
end

function Event:dumpAllEventListeners()
    print("---- Event:dumpAllEventListeners() ----")
    for name, listeners in pairs(self.target_.listeners_) do
        printf("-- event: %s", name)
        for handle, listener in pairs(listeners) do
            printf("--     listener: %s, handle: %s", tostring(listener[1]), tostring(handle))
        end
    end
    return self.target_
end

return Event

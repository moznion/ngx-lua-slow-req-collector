local ngx = ngx
local setmetatable = setmetatable

local _M = { _VERSION = '0.01' }
local mt = { __index = _M }

function _M.new(self, threshold_sec, ...)
    return setmetatable({
        _threshold_sec = threshold_sec,
        _callbacks = {...},
    }, mt)
end

function _M.collect(self)
    local request_time = tonumber(ngx.var.request_time)
    if request_time > self._threshold_sec then
        for i, cb in ipairs(self._callbacks) do
            cb:run(request_time)
        end
    end
end

return _M


local entitas = require("entitas")
local Components = require("room.Components")
local aoi = require("room.aoi")
local ReactiveSystem = entitas.ReactiveSystem
local Matcher = entitas.Matcher
local GroupEvent = entitas.GroupEvent

local M = class("UpdateSpeedSystem", ReactiveSystem)

function M:ctor(context)
    M.super.ctor(self, context.ecs_context)
    self.context = context
    self.idx = context.uid_index--用来根据id查询玩家entity
    self.cfg = context.conf
end

local trigger = {
    {
        Matcher({Components.Speed,Components.Mover}),
        GroupEvent.ADDED | GroupEvent.UPDATE
    }
}

function M:get_trigger()
    unused(self)
    return trigger
end

local all_comps = {Components.Speed,Components.Mover}

function M:filter(entity)
    unused(self)
    return entity:has_all(all_comps)
end

function M:execute(entites)
    entites:foreach(function(entity)
        local eid = entity:get(Components.BaseData).id
        local speedid = self.context.make_prefab(entity,Components.Speed)
        self.context.send_prefab(eid,speedid)
        aoi.fire_event(eid,aoi.EVENT_UPDATE_DIR,function (marker)
            local ne = self.idx:get_entity(marker)
            if ne and ne:has(Components.Mover) then
                self.context.send_prefab(marker,speedid)
            end
        end)
    end)
end

return M

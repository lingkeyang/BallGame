local MakeComponent = require("entitas").MakeComponent
local MSGID = require("game.MSGID")

local M = {
    CommandCreate = MakeComponent("CommandCreate","id","data"),
    CommandRemove = MakeComponent("CommandRemove","id"),
    CommandMove = MakeComponent("CommandMove","id","data"),
    CommandUpdate = MakeComponent("CommandUpdate","delta"),
    InputCreateFood = MakeComponent("InputCreateFood","count"),

    BaseData = MakeComponent("BaseData","id","name","spriteid"),
    Position = MakeComponent("Position","x","y"),
    Direction = MakeComponent("Direction","x","y"),
    Speed = MakeComponent("Speed","value"),
    Color = MakeComponent("Color","r","g","b"),
    Mover = MakeComponent("Mover"),
    Food = MakeComponent("Food"),
    Radius =  MakeComponent("Radius","value"),
    Dead =  MakeComponent("Dead"),
    Eat =  MakeComponent("Eat","weight")
}

--根据name映射组件和消息ID
local component_id_map = {}
local id_component_map = {}

for k,v in pairs(MSGID) do
    if type(v) == "number" then
        local m = M[k]
        if m then
            component_id_map[m] = v
            id_component_map[v] = m
        end
    end
end

local function  MapComponentWithID(comp,id)
    component_id_map[comp] = id
    id_component_map[id] = comp
end

MapComponentWithID(M.CommandUpdate,1)
MapComponentWithID(M.CommandRemove,2)

M.GetComponent = function(id)
    return id_component_map[id]
end

M.GetID = function(comp)
    return component_id_map[comp]
end

return M
ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for k, v in pairs(Config.Garages) do
            if #(pcoords - v.Spawn) < 10 then
		    wait = 0
                if ESX.PlayerData.job.name == "police" and not IsPedDeadOrDying(ped) then
		        DrawMarker(1, v.Spawn.x, v.Spawn.y, v.Spawn.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 0.05, 0, 0, 0, 0, 0, 0, 0)
                    if #(pcoords - v.Spawn) < 1.0 then
                        ESX.ShowHelpNotification("~INPUT_PICKUP~ Open garage")
                        if IsControlJustReleased(0, 38) then
                            local spawncoords = v.SpawnCoords
                            local heading = v.Heading
                            OpenGarage(spawncoords, heading)
                        end
                    end
                end
            end
        end
	Wait(wait)
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for k, v in pairs(Config.Garages) do
            if #(pcoords - v.Remove) < 10 and ESX.PlayerData.job.name == "police" then
                if not IsPedDeadOrDying(ped) and not IsPedInAnyVehicle(ped, true) then
		        wait = 0
                DrawMarker(1, v.Remove.x, v.Remove.y, v.Remove.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 0.05, 0, 0, 0, 0, 0, 0, 0)
                    if #(pcoords - v.Remove) < 1.0 then
                        ESX.ShowHelpNotification("~INPUT_PICKUP~ Remove vehicle")
                        if IsControlJustReleased(0, 38) then
                            RemoveVehicle()
                        end
                    end
                end
            end
        end
	Wait(wait)
    end
end)

function RemoveVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    ESX.Game.DeleteVehicle(vehicle)
end

function OpenGarage(spawncoords, heading)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "garagemenu",
        {
            title = "Police garage",
            align = "top-right",
            elements = Config.Vehicles
        },
        function(data, menu)
            ESX.UI.Menu.CloseAll()
            local model = data.current.value
            ESX.Game.SpawnVehicle(model, spawncoords, heading, function(vehicle)
            end)
        end,
        function(data, menu)
            menu.close()
        end,
        function(data, menu)
        end)
end


local newPlayer = false
local firstspawn = false

AddEventHandler('playerSpawned', function()
    if not firstspawn then
        TriggerServerEvent('byK3-spawnEvent')
        firstspawn = true
    end
end)


RegisterNetEvent('newPlayer')
AddEventHandler('newPlayer', function(bool)
    newPlayer = bool
    local ped = GetPlayerPed(-1)
end)



RegisterCommand('newPlayer', function(source, args, rawCommand)
    print(newPlayer)
    TriggerEvent('newPlayer', true)
    print (newPlayer)  
end, false)

CreateThread(function()
    while true do
        Wait(10000)
        if newPlayer then
           local ped = PlayerPedId()
           local coords = GetEntityCoords(ped)
           local distance = #(coords - Settings.Teleports.spawn.coords)

           if distance > 100 then
               SetEntityCoords(ped, Settings.Teleports.spawn.coords)
               SetEntityHeading(ped, Settings.Teleports.spawn.coords)
           end
        end
    end
end)


CreateThread(function()
    if Settings.SafeZone then
        while true do
            Wait(1)

            if newPlayer then
                local ped = PlayerPedId()
                if ped then
                    SetPedCanSwitchWeapon(ped, false)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                    SetPlayerInvincible(ped, true)
                    SetEntityInvincible(ped, true)
                    SetEntityCanBeDamaged(ped, false)
                    DisableControlAction(0, 24, true) -- attack
                    DisableControlAction(0, 25, true) -- aim
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - Settings.callCoords)

        if newPlayer then
            if distance < 15 then
                DrawMarker(1, Settings.callCoords.x, Settings.callCoords.y, Settings.callCoords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 255, 0, 0, 0, 0)	
                if distance < 2 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to call for admin help')
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('callAdmin')
                        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
                        Wait(Settings.callCooldown * 1000)
                    end
                end
            else
                Wait(1000)
            end
        end
    end
end)


showIds = false
RegisterNetEvent('byK3-showID')
AddEventHandler('byK3-showID', function (bool)
    showIds = bool

    if showIds then
        IDshow()
    end
end)


IDshow = function()
    CreateThread(function()
        while true do
            Wait(1)
            if showIds == true then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                    local players = GetActivePlayers()
                    for i = 1, #players do
                    local otherPlayer = GetPlayerPed(players[i])
                    local otherPlayerName = GetPlayerName(players[i])
                    local otherPlayerId = GetPlayerServerId(players[i])
                    local otherPlayerPed = GetPlayerPed(players[i])
                    local otherPlayerCoords = GetEntityCoords(otherPlayerPed)
                    local distance = #(coords - otherPlayerCoords)

                    if distance < Settings.idDistance then
                        if otherPlayerId ~= GetPlayerServerId(PlayerId()) then
                            DrawText3D(otherPlayerCoords.x, otherPlayerCoords.y, otherPlayerCoords.z + 1.0, otherPlayerName .. " | ID: " .. otherPlayerId)
                        end
                    end
                end 
            else
                return
            end
        end
    end)

end


DrawText3D = function (x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end
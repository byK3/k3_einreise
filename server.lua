RegisterNetEvent('byK3-spawnEvent')
AddEventHandler('byK3-spawnEvent', function()

    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetExtendedPlayers()
    local steamName = GetPlayerName(source)

    MySQL.Async.fetchAll('SELECT newPlayer FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
        if result[1] then
            local resultSQL = json.encode(result[1].newPlayer)
            local resultSQL2 = result[1].newPlayer

            if resultSQL2 == "1" then
                for i = 1, #xPlayers, 1 do
                    local xAdmins = ESX.GetPlayerFromId(xPlayers[i].source)
                    if Settings.Ranks[xAdmins.getGroup()] then
                        notify(xPlayers[i].source, (Locales.NewPlayerArrived):format(steamName))
                    end
                end
                newTP(src)
                TriggerClientEvent('newPlayer', src, true)
            else
                TriggerClientEvent('newPlayer', src, false)
            end
        end
    end)
end)


newTP = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local dim = Settings.Dimension
    SetEntityCoords(ped, Settings.Teleports.spawn.coords)
    SetEntityHeading(ped, Settings.Teleports.spawn.heading)
    SetPlayerRoutingBucket(source, dim)
end

welcomeTP = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    SetEntityCoords(GetPlayerPed(source), Settings.Teleports.leave.coords)
    SetEntityHeading(ped, Settings.Teleports.leave.heading)
    SetPlayerRoutingBucket(source, 0)
end


RegisterCommand(Settings.Commands.giveCitizenship, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if Settings.Ranks[group] then
        local target = tonumber(args[1])
        if target then
            local xTarget = ESX.GetPlayerFromId(target)
            if xTarget then
                MySQL.Async.execute('UPDATE users SET newPlayer = 0 WHERE identifier = @identifier', {
                    ['@identifier'] = xTarget.identifier
                }, function(rowsChanged)
                    if rowsChanged == 1 then
                        notify(source, (Locales.GiveCitizenship):format(xTarget.name))
                        notify(xTarget.source, Locales.GotCitizenship)
                        welcomeTP(xTarget.source)
                        TriggerClientEvent('newPlayer', target.source, false)
                    else
                        notify(source, 'Something went wrong')
                    end
                end)
            else
                notify(source, 'Player not found')
            end
        else
            notify(source, 'Invalid target')
        end
    else
        notify(source, 'You are not allowed to do this')
    end
end, false)

RegisterCommand(Settings.Commands.removeCitizenship, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    local steamName = GetPlayerName(source)
    local reason = args[2]
    if reason == nil then
        reason = 'For more information, contact the administration'
    end

    if Settings.Ranks[group] then
        local target = tonumber(args[1])
        if target then
            local xTarget = ESX.GetPlayerFromId(target)
            if xTarget then
                MySQL.Async.execute('UPDATE users SET newPlayer = 1 WHERE identifier = @identifier', {
                    ['@identifier'] = xTarget.identifier
                }, function(rowsChanged)
                    if rowsChanged == 1 then
                        notify(source, (Locales.RemoveCitizenship):format(xTarget.name))
                        notify(xTarget.source, (Locales.GotRemovedCitizenship):format(steamName, reason))
                        DropPlayer(xTarget.source, (Locales.KickMessage):format(steamName, reason))
                    else
                        notify(source, 'Something went wrong')
                    end
                end)
            else
                notify(source, 'Player not found')
            end
        else
            notify(source, 'Invalid target')
        end
    else
        notify(source, 'You are not allowed to do this')
    end
end, false)



local isInImmigration = false
RegisterCommand(Settings.Commands.enter, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    local ped = GetPlayerPed(source)

    if isInImmigration == false then
        isInImmigration = true
        if Settings.Ranks[group] then
            if xPlayer then
                if Settings.showID then
                    TriggerClientEvent('showID', source, true)
                end
                SetEntityCoords(ped, Settings.Teleports.enter.coords)
                SetEntityHeading(ped, Settings.Teleports.enter.heading)
                SetPlayerRoutingBucket(source, Settings.Dimension)
            end
        end
    else
        notify(source, Locales.AlreadyInImmigration)
    end
end, false)


RegisterCommand(Settings.Commands.exit, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    local ped = GetPlayerPed(source)

    if isInImmigration == true then
        if Settings.Ranks[group] then
            if xPlayer then
                TriggerClientEvent('byK3-showID', source, false)
                isInImmigration = false
                SetEntityCoords(ped, Settings.Teleports.leave.coords)
                SetEntityHeading(ped, Settings.Teleports.leave.heading)
                SetPlayerRoutingBucket(source, 0)
            end
        end
    else
        print ('you arent in immigraiton')
    end
end, false)



local button = 0
RegisterNetEvent('callAdmin')
AddEventHandler('callAdmin', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local steamName = GetPlayerName(source)
    local xPlayers = ESX.GetExtendedPlayers()

    buttonPress(source)

    for i=1, #xPlayers, 1 do
        local xTarget = xPlayers[i]
        if xTarget then
            local group = xTarget.getGroup()
            if Settings.Ranks[group] then
                notify(xTarget.source, (Locales.CallAdmin):format(steamName))
            end
        end
    end
end)

buttonPress = function(source)
    CreateThread(function()    
        local xPlayer = ESX.GetPlayerFromId(source)        
        button = button + 1
        Citizen.Wait(Settings.callCooldown * 1000)
        button = button - 1
    end)
end


RegisterCommand(Settings.Commands.resetplayer, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    local steamName = GetPlayerName(source)
    local type = args[1]
    local target = tonumber(args[2])
    local xTarget = ESX.GetPlayerFromId(target)
    local targetName = GetPlayerName(target)

    if Settings.Ranks[group] then
        if type == 'skin' then
            if xTarget then
                TriggerClientEvent(Settings.Triggers.skinOpen, xTarget.source)
                notify(source, (Locales.ResetSkin):format(xTarget.name))
                notify(xTarget.source, (Locales.GotResetSkin):format(steamName))
            else
                notify(source, 'Player not found')
            end
        elseif type == 'identity' then
            if xTarget then
                TriggerClientEvent(Settings.Triggers.identity, xTarget.source)
                notify(source, (Locales.ResetIdentity):format(xTarget.name))
                notify(xTarget.source, (Locales.GotResetIdentity):format(steamName))
            else
                notify(source, 'Player not found')
            end
        else
            notify(source, 'Invalid type given')
        end
    else
        notify(source, 'You are not allowed to do this')
    end
end, false)


function DiscordLog(msg)
    local embedMsg = {}
    timestamp = os.date("%c")


    embedMsg = {
        { -- color red = 16711680, green = 65280, blue = 255
            ["color"] = 65280,
            ["title"] = '** '..Settings.Discord.title..' **',  
            ["description"] =  msg,
            ["footer"] ={
                ["text"] = timestamp.." || Script written by: byK3#7147",
            },
        }
    }
    PerformHttpRequest(Settings.Discord.webhook, function(err, text, headers)end, 'POST', json.encode({username = 'CITIZENSHIP', avatar_url= Settings.Discord.avatar ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end



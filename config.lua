Settings = {}
Locales = {}

-- === GENERAL SETTINGS === --
Settings.callCooldown = 5 -- cooldown for the call admin button in seconds
Settings.callCoords = vec3(-1091.920898, -2829.797852, 27.695923)  -- coords for the call admin button
Settings.idDistance = 50 -- distance to see the id of the players
Settings.showID = true -- if true allows admins to see the id of the players in the spawn
Settings.Dimension = 28  -- to avoid cheating and exploits from new players to the normal world (0) where all the players are
Settings.SafeZone = true -- if true, the player cant combat there



-- === PERMISSIONS === --
Settings.Ranks = { -- if you want to add more ranks, just add them here and in the settings file

    ["superadmin"] = true,
    ["admin"] = true,
    ["mod"] = true,
    ["helper"] = true,
}


-- === TRIGGERS & FUNCTION === --
Settings.Triggers = { -- change the triggers to your own triggers

    skinOpen = 'esx_skin:openSaveableMenu',
    identity = 'esx_identity:showRegisterIdentity',

}

notify = function(source, msg)
    TriggerClientEvent('esx:showNotification', source, msg)
end


-- === COMMANDS === --
Settings.Commands = { -- you can change the commands if you want (just change the value, not the key)

    giveCitizenship = "givecitizenship",
    removeCitizenship = "removecitizenship",
    enter = "enter",
    exit = "exit",
    resetplayer = "reset",
    
}


-- === TELEPORTS & COORDS === --
Settings.Teleports = { 

    enter = {
        coords = vec3(-1079.129639, -2821.648438, 27.695923),
        heading = 0.0,
    },

    leave = {
        coords = vec3(-1066.417603, -2802.303223, 27.695923),
        heading = 0.0,
    },

    spawn = {
        coords = vec3(-1099.107666, -2825.446045, 27.695923),
        heading = 0.0,
    }

}


-- === DISCORD WEBHOOK === --
Settings.Discord = { -- if you dont want to use a webhook, just leave it blank and it will not send any message to discord

    -- The discord function is working, you need to implement it in the code yourself

    webhook = "",  -- your webhook here
    avatar = "https://i.imgur.com/1Z1Z1Z1.png", -- avatar for webhook
    title = "** CITIZENSHIP **", -- title for webhook

}


-- == LOCALES == --
Locales.CallAdmin = "Player: %s is calling for an admin"
Locales.NewPlayerArrived = "New Player: %s has arrived and is waiting for immigration"
Locales.GiveCitizenship = "You have been given citizenship to: %s"
Locales.GotCitizenship = "You are now a citizen! Enjoy your stay!"
Locales.RemoveCitizenship = "You removed the citizenship from: %s"
Locales.GotRemovedCitizenship = "You are no longer a citizen! Goodbye!"
Locales.KickMessage = "[CITIZENSHIP] Your citizenship has been removed by: %s | Reason: %s"
Locales.AlreadyInImmigration = "You are already entered the Immigration Center"
Locales.ResetSkin = "You have reseted the skin of: %s"
Locales.GotResetSkin = "Your skin has been reseted by: %s"
Locales.Locales.ResetIdentity = "You have reseted the identity of: %s"
Locales.GotResetIdentity = "Your identity has been reseted by: %s"
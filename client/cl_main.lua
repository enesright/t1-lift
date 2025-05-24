local QBCore = exports['qb-core']:GetCoreObject()
local elevatorState = {
    inUse = false,
    currentTransaction = nil
}

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    if Config.Target then
        for elevatorId, elevatorData in pairs(Config.Elevators) do
            for floorLevel, floorData in pairs(elevatorData.Floors) do
                exports['qb-target']:RemoveZone(string.format("Elevator:%s|Floor:%s", elevatorId, floorLevel))
            end
        end
    end
end)

local function renderWorldText(positionX, positionY, positionZ, displayText)
    local screenX, screenY, onScreen = World3dToScreen2d(positionX, positionY, positionZ)
    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(displayText)
    DrawText(screenX, screenY)
    
    local textWidth = (string.len(displayText)) / 370
    DrawRect(screenX, screenY + 0.0125, 0.015 + textWidth, 0.03, 41, 11, 41, 68)
end

local UI = Config.UI

local function showInteractionPrompt(interactionType, position)
    if interactionType == 'GTA-O' then
        AddTextEntry('ElevatorPrompt', UI.Interaction.Prompt)
        BeginTextCommandDisplayHelp('ElevatorPrompt')
        EndTextCommandDisplayHelp(0, false, true, -1)
    elseif interactionType == 'Modern-Draw-Text' then
        SetFloatingHelpTextWorldPosition(1, position.x, position.y, position.z + 0.8)
        SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(UI.Interaction.Prompt)
        EndTextCommandDisplayHelp(2, false, true, -1)
    end
end

CreateThread(function()
    if Config.Target then
        initializeTargetSystem()
    else
        initializeProximitySystem()
    end
end)

function initializeTargetSystem()
    for elevatorId, elevatorConfig in pairs(Config.Elevators) do
        for floorLevel, floorConfig in pairs(elevatorConfig.Floors) do
            local zoneName = string.format("Elevator:%s|Floor:%s", elevatorId, floorLevel)
            local zoneOptions = {
                {
                    name = zoneName,
                    icon = elevatorConfig.TargetIcon,
                    label = elevatorConfig.Target,
                    onSelect = function()
                        TriggerEvent('t1-elevators:client:useElevator', elevatorConfig, floorLevel, elevatorId)
                    end,
                    canInteract = function()
                        return not IsPedInAnyVehicle(PlayerPedId()) and not elevatorState.inUse
                    end,
                    job = elevatorConfig.Job
                }
            }

            if GetResourceState('qb-target') == 'started' then
                exports['qb-target']:AddBoxZone(
                    zoneName,
                    floorConfig.Coord,
                    floorConfig.Poly.Length,
                    floorConfig.Poly.Width,
                    {
                        name = zoneName,
                        heading = floorConfig.Poly.Heading,
                        debugPoly = false,
                        minZ = floorConfig.Poly.minZ,
                        maxZ = floorConfig.Poly.maxZ,
                    },
                    {
                        options = {
                            {
                                type = "client",
                                icon = elevatorConfig.TargetIcon,
                                label = elevatorConfig.Target,
                                action = function()
                                    TriggerEvent('t1-elevators:client:useElevator', elevatorConfig, floorLevel, elevatorId)
                                end,
                                canInteract = function()
                                    return not IsPedInAnyVehicle(PlayerPedId()) and not elevatorState.inUse
                                end,
                                job = elevatorConfig.Job,
                            }
                        },
                        distance = 2.5
                    }
                )
            end

            if GetResourceState('ox_target') == 'started' then
                exports.ox_target:addBoxZone({
                    coords = floorConfig.Coord,
                    size = vec3(floorConfig.Poly.Length, floorConfig.Poly.Width, floorConfig.Poly.maxZ - floorConfig.Poly.minZ),
                    rotation = floorConfig.Poly.Heading,
                    debug = false,
                    options = {
                        {
                            name = zoneName,
                            icon = elevatorConfig.TargetIcon,
                            label = elevatorConfig.Target,
                            onSelect = function()
                                TriggerEvent('t1-elevators:client:useElevator', elevatorConfig, floorLevel, elevatorId)
                            end,
                            canInteract = function()
                                return not IsPedInAnyVehicle(PlayerPedId()) and not elevatorState.inUse
                            end,
                            job = elevatorConfig.Job
                        }
                    },
                    distance = 2.5
                })
            end
        end
    end
end

function initializeProximitySystem()
    while true do
        local waitTime = 2000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for elevatorId, elevatorConfig in pairs(Config.Elevators) do
            for floorLevel, floorConfig in pairs(elevatorConfig.Floors) do
                local distance = #(playerCoords - floorConfig.Coord)
                
                if distance < 4 and not IsPedInAnyVehicle(playerPed) then
                    waitTime = 0
                    DrawMarker(2, floorConfig.Coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.3, 0.22, 255, 165, 0, 222, false, false, false, true, false, false, false)
                    
                    if distance < elevatorConfig.Distance then
                        showInteractionPrompt(UI.Interaction.Type, floorConfig.Coord)
                        
                        if IsControlJustPressed(0, 38) then
                            handleElevatorAccess(elevatorConfig, floorLevel, elevatorId)
                        end
                    end
                end
            end
        end
        
        Wait(waitTime)
    end
end

function handleElevatorAccess(elevatorConfig, floorLevel, elevatorId)
    local playerData = QBCore.Functions.GetPlayerData()
    
    if elevatorConfig.Job and playerData.job ~= elevatorConfig.Job then
        showNotification(Config.Lang.NotAllowed, 'error')
        return
    end
    
    TriggerEvent('t1-elevators:client:useElevator', elevatorConfig, floorLevel, elevatorId)
end

function showNotification(message, type)
    if Config.Notify == 'ox_lib' then
        lib.notify({
            title = "Elevator System",
            description = message,
            type = type,
            position = 'center-right'
        })
    else
        QBCore.Functions.Notify(message, type, 7500)
    end
end

RegisterNetEvent('t1-elevators:client:useElevator', function(elevatorData, currentFloor, elevatorId)
    if elevatorState.inUse then
        showNotification(Config.Lang.AlreadyInElevator, 'error')
        return
    end

    local menuOptions = generateFloorOptions(elevatorData, currentFloor)
    
    lib.registerContext({
        id = 'elevator_floor_selection',
        title = elevatorId,
        options = menuOptions
    })

    lib.showContext('elevator_floor_selection')
end)

function generateFloorOptions(elevatorData, currentFloor)
    local options = {}
    
    for floorLevel, floorConfig in pairs(elevatorData.Floors) do
        table.insert(options, {
            title = floorLevel == currentFloor and (floorConfig.Label .. " " .. Config.Lang.OnThisFloor) or floorConfig.Label,
            description = floorConfig.description,
            disabled = (floorLevel == currentFloor),
            icon = elevatorData.TargetIcon,
            onSelect = function()
                TriggerEvent("t1-elevators:client:elevatorUsed", {
                    Progressbar = elevatorData.Progressbar,
                    SoundEffect = elevatorData.SoundEffect,
                    GoTo = floorConfig.Spawn.PlayerSpawn,
                    GoToHeading = floorConfig.Spawn.PlayerHeading
                })
            end
        })
    end
    
    return options
end

RegisterNetEvent('t1-elevators:client:elevatorUsed', function(operationData)
    local playerPed = PlayerPedId()
    
    if operationData.SoundEffect.WhereToPlay == "OnStart" or operationData.SoundEffect.WhereToPlay == "Both" then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", operationData.SoundEffect.OnStartEffect, operationData.SoundEffect.Loudness)
    end

    elevatorState.inUse = true

    if Config.Fade then
        DoScreenFadeOut(1000)
    end

    if Config.Progressbar == 'ox_lib' then
        handleOxLibProgress(operationData, playerPed)
    else
        handleQBCoreProgress(operationData, playerPed)
    end
end)

function handleOxLibProgress(operationData, playerPed)
    local success = lib.progressCircle({
        duration = operationData.Progressbar.Duration,
        label = operationData.Progressbar.Label,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = Config.Anim.Dict,
            clip = Config.Anim.Name,
        },
    })

    if success then
        completeElevatorOperation(operationData, playerPed)
    else
        abortElevatorOperation(operationData)
    end
end

function handleQBCoreProgress(operationData, playerPed)
    QBCore.Functions.Progressbar('elevator_operation', 
        operationData.Progressbar.Label, 
        operationData.Progressbar.Duration, 
        false, 
        true, 
        {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, 
        {
            animDict = Config.Anim.Dict,
            anim = Config.Anim.Name,
            flags = Config.Anim.Flags,
        }, 
        {}, 
        {}, 
        function()
            completeElevatorOperation(operationData, playerPed)
        end, 
        function()
            abortElevatorOperation(operationData)
        end
    )
end

function completeElevatorOperation(operationData, playerPed)
    if operationData.SoundEffect.WhereToPlay == "OnFinish" or operationData.SoundEffect.WhereToPlay == "Both" then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", operationData.SoundEffect.OnFinishEffect, operationData.SoundEffect.Loudness)
    end

    if Config.SecondalFade then
        DoScreenFadeOut(2000)
        Wait(2000)
        SetEntityCoords(playerPed, operationData.GoTo.x, operationData.GoTo.y, operationData.GoTo.z)
        SetEntityHeading(playerPed, operationData.GoToHeading)
        Wait(1000)
        DoScreenFadeIn(2000)
    end

    if Config.Fade then
        Wait(500)
        DoScreenFadeIn(1000)
    end

    elevatorState.inUse = false
end

function abortElevatorOperation(operationData)
    if operationData.SoundEffect.WhereToPlay == "OnFinish" or operationData.SoundEffect.WhereToPlay == "Both" then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", operationData.SoundEffect.OnFinishEffect, operationData.SoundEffect.Loudness)
    end
    
    showNotification(Config.Lang.ChangedMind, 'error')
    DoScreenFadeIn(1000)
    elevatorState.inUse = false
end
ESX = nil
local show = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('akamis-camera:addBlipWhenWanted')
AddEventHandler('akamis-camera:addBlipWhenWanted', function(coords, name, lastname)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local name = '#'..name..' '..lastname
    SetBlipSprite (blip, 42)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.0)
    SetBlipColour (blip, 38)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    Citizen.Wait(12000)
    RemoveBlip(blip)
end)
Citizen.CreateThread(function()
  while true do
    Wait(1500)
    local coords = GetEntityCoords(GetPlayerPed(-1))

      for k,v in pairs(Config.Camera) do
        local radius = v.radius / 1.5

        if(GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < radius) then
          if show == false then
            show = true

            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsUsing(playerPed)
            local street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local streetName = GetStreetNameFromHashKey(street)
            if IsPedInVehicle(playerPed, vehicle, true) then
              local plate = GetVehicleNumberPlateText(vehicle)
              TriggerServerEvent('akamis-camera:searchcar', plate, streetName, coords)
            else

              TriggerServerEvent('akamis-camera:search', streetName, coords)

            end
            Citizen.Wait(20000)
            show = false
          end
          
        end
      end
   end
end)

Citizen.CreateThread(function()
  if Config.DevType then
    for k,v in pairs(Config.Camera) do
      local radius = v.radius / 1.5
        local blip = AddBlipForRadius(v.pos.x, v.pos.y, v.pos.z, radius)

        SetBlipColour(blip,38)
        SetBlipAlpha(blip,80)
        SetBlipSprite(blip,9)
    end
  end

end)
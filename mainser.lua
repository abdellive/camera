ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('platedelete', function(source, args)
  MySQL.Async.execute('DELETE FROM auta_search WHERE plate = @plate', {
    ['@plate']  = args[1]
  }, function(rowsChanged)

  end)
  TriggerClientEvent('chat:addMessage', source, { args = { '️✔️^1^*[SYSTEM]: Pomyślnie Usunąłeś/aś tablice rej. '..args[1]..' z poszukiwanych'}})
end)

RegisterCommand('plateadd', function(source, args)
  MySQL.Async.execute('INSERT INTO auta_search (plate) VALUES (@plate)', {
    ['@plate'] = args[1]
  }, function (rowsChanged)
  end)
  TriggerClientEvent('chat:addMessage', source, { args = { '️✔️^1^*[SYSTEM]: Pomyślnie dodałeś/aś tablice rej. '..args[1]..' Do poszukiwanych'}})
end)

RegisterServerEvent("akamis-camera:searchcar")
AddEventHandler("akamis-camera:searchcar", function(plate, streetName, coords)
  MySQL.Async.fetchAll('SELECT * FROM auta_search', {
  }, function (results)
    for i = 1, #results, 1 do
      print(results[i].plate)
      plate = string.gsub(plate, "%s+", "")
      local plate2 = string.gsub(results[i].plate, "%s+", "")
      
      if plate == plate2 then
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
          local policmen = ESX.GetPlayerFromId(xPlayers[i])

          if policmen.job.name == "police" then
            TriggerClientEvent('esx:showAdvancedNotification', policmen.source, '🔰 City Camera 🔰', '\nStreet: '..streetName, '\nplate: '..plate2, 'CHAR_CALL911', 8)
            TriggerClientEvent('akamis-camera:addBlipWhenWanted', policmen.source, coords, 'monitoring: ', plate2)
          end
        end
      end
    end
  end)
end)


RegisterServerEvent("akamis-camera:search")
AddEventHandler("akamis-camera:search", function(streetName, coords)
  local _source = source  
  local xPlayer  = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM user_poszukiwania WHERE identifier = @identifier', {
      ['@identifier'] = xPlayer.identifier,
    }, function (results)
      if results[1] ~= nil then

        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
          local policmen = ESX.GetPlayerFromId(xPlayers[i])

          if policmen.job.name == "police" then
            MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
              ['@identifier'] = xPlayer.identifier,
            }, function (result)

                TriggerClientEvent('esx:showAdvancedNotification', policmen.source, '🔰 City Camera 🔰', '\nStreet: '..streetName, '\n'..result[1].firstname..' '..result[1].lastname.. ' is wanted! He is on foot!', 'CHAR_CALL911', 8)
                TriggerClientEvent('akamis-camera:addBlipWhenWanted', policmen.source, coords, result[1].firstname, result[1].lastname)

            end)
          end
        end
      end
    end)
end)
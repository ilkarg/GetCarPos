messageColor = 0xFFad9332
car = nil
checkpointInGame = nil
checkpointOnMap = nil

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then
      return
  end

  while not isSampAvailable() do
    wait(0)
  end

  sampRegisterChatCommand("mark", getCarMarkerCommand)
  sampRegisterChatCommand("unmark", removeMarkerCommand)

  sampAddChatMessage("[GetCarPos.lua] started", messageColor)

  while true do
    wait(0)

    if checkpointInGame ~= nil then
      if isCharInCar(PLAYER_PED, car) then
        deleteCheckpoint(checkpointInGame)
        removeBlip(checkpointOnMap)

        checkpointInGame = nil
        checkpointOnMap = nil
      end
    end

    if isCharSittingInAnyCar(PLAYER_PED) then
      local currentCar = storeCarCharIsInNoSave(PLAYER_PED)
      if car == nil or car ~= currentCar then
        car = storeCarCharIsInNoSave(PLAYER_PED)
        sampAddChatMessage("[GetCarPos.lua] Car success saved", messageColor)
      end
    end
  end

  wait(-1)
end

function getCarMarkerCommand()
  if car == nil then
    sampAddChatMessage("[GetCarPos.lua] car is null", messageColor)
    return
  end

  sampAddChatMessage("[GetCarPos.lua] Marker setted on car position", messageColor)

  if checkpointInGame ~= nil then
    deleteCheckpoint(checkpointInGame)
    checkpointInGame = nil
  end
  if checkpointOnMap ~= nil then
    removeBlip(checkpointOnMap)
    checkpointOnMap = nil
  end

  local carX, carY, carZ = getCarCoordinates(car)
  checkpointInGame = createCheckpoint(1, carX, carY, carZ, 0, 0, 0, 3)
  checkpointOnMap = addSpriteBlipForCoord(carX, carY, carZ, 19)
end

function removeMarkerCommand()
  if checkpointOnMap ~= nil then
    sampAddChatMessage("[GetCarPos.lua] Marker success removed", messageColor)

    deleteCheckpoint(checkpointInGame)
    removeBlip(checkpointOnMap)

    checkpointInGame = nil
    checkpointOnMap = nil
  else
    sampAddChatMessage("[GetCarPos.lua] Marker is not exists", messageColor)
  end
end
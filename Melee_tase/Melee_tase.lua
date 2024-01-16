RegisterNetEvent("Melee_tase", function(source)
  print(1)
  function GetPlayerLookingVector(playerped, radius)
    local yaw = GetEntityHeading(playerped)
    local pitch = 90.0-GetGameplayCamRelativePitch()

    if yaw > 180 then
      yaw = yaw - 360
    elseif yaw < -180 then
      yaw = yaw + 360
    end

    local pitch = pitch * math.pi / 180
    local yaw = yaw * math.pi / 180
    local x = radius * math.sin(pitch) * math.sin(yaw)
    local y = radius * math.sin(pitch) * math.cos(yaw)
    local z = radius * math.cos(pitch)

    local playerpedcoords = GetEntityCoords(playerped)
    local xcorr = -x+ playerpedcoords.x
    local ycorr = y+ playerpedcoords.y
    local zcorr = z+ playerpedcoords.z
    local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
    return Vector
  end

  local caller_anim_by_index = {
		[1] = {"combat@chg_positionpose_b", "aimb_calm_bwd"},
		[0] = {"combat@chg_positionpose_b", "aimb_calm_fwd"}
	}
  local target_anim = {"ragdoll@human", "electrocute"}


  local ped = PlayerPedId()
  if not IsPlayerFreeAiming(PlayerId(source)) then return end
  if not GetSelectedPedWeapon(ped) == 911657153 then return end

  local _, _, _, _, target = GetShapeTestResult(StartShapeTestRay(GetEntityCoords(ped), GetPlayerLookingVector(ped, 1.0), 4, GetPlayerPed(-1), 0))

  if IsEntityAPed(target) == 0 then return end

  local anim_index
  local dif = GetEntityHeading(target) - GetEntityHeading(ped)
  if dif < 0 then dif = dif + 360 end
  if dif < 90 or dif > 180 then anim_index = 1 else anim_index = 0 end

  local i = 0
  RequestAnimDict("combat@chg_positionpose_b")
  while not HasAnimDictLoaded("combat@chg_positionpose_b") and i < 30 do
    i = i + 1
    Citizen.Wait(100)
  end
  if not HasAnimDictLoaded("combat@chg_positionpose_b") then return end
  
  local i = 0
  RequestAnimDict("ragdoll@human")
  while not HasAnimDictLoaded("ragdoll@human") and i < 30 do
    i = i + 1
    Citizen.Wait(100)
  end
  if not HasAnimDictLoaded("ragdoll@human") then return end
  
  ClearPedTasksImmediately(ped)
  ClearPedTasksImmediately(target)
  
  if anim_index == 1 then SetEntityHeading(target, GetEntityHeading(ped)) else SetEntityHeading(target, GetEntityHeading(ped) + 180) end

  local caller_offset_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
  local target_pos = GetEntityCoords(target)
  SetEntityCoords(target, caller_offset_pos.x, caller_offset_pos.y, target_pos.z, 0, 0, 0, 0)

  TaskPlayAnim(ped, caller_anim_by_index[anim_index], 4.0, 4.0, 2500, 0, 0.0)
  TaskPlayAnim(target, target_anim, 4.0, 4.0, -1, 0, 0.0)

  RemoveAnimDict("combat@chg_positionpose_b")
  RemoveAnimDict("ragdoll@human")
  
  Citizen.Wait(2500)
  
  SetPedToRagdoll(target, 10000, 10000, 0)
end)

player = GetPlayerPed(-1)

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

Citizen.CreateThread(function()
  while true do
    GiveWeaponToPed(player, 911657153, 1, false, false)
    if GetSelectedPedWeapon(player) == 911657153 then
      if IsControlJustReleased(1, 288) then -------------- F1
        function GetPedInDirection(coordFrom, coordTo)
          local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 4, GetPlayerPed(-1), 0)
          local _,flag_PedHit,PedCoords,_,PedHit = GetShapeTestResult(rayHandle)
          return flag_PedHit, PedCoords, PedHit
        end
        
        flag_PedHit, PedCoords, target = GetPedInDirection(GetEntityCoords(player), GetPlayerLookingVector(player, 1))
        
        if target == 0 and IsPedAPlayer(GetEntityPlayerIsFreeAimingAt(player)) and #(GetEntityCoords(GetEntityPlayerIsFreeAimingAt(player)) - GetEntityCoords(player)) < 1.5 then
          target = GetEntityPlayerIsFreeAimingAt(player)
        end
        
        x, y, z = table.unpack(GetPlayerLookingVector(player, 1))
        if IsEntityAPed(target) then
          if GetEntityHeading(player) - GetEntityHeading(target) < 0 then
            local dif =  GetEntityHeading(target) - GetEntityHeading(player)
            if dif > 180 then
              angle = 360 - dif
            else
              angle = dif
            end
          else
            local dif = GetEntityHeading(player) - GetEntityHeading(target)
            if dif > 180 then
              angle = 360 - dif
            else
              angle = dif
            end
          end

          if angle > 90 then
            facing = true
            if GetEntityHeading(player) + 180 > 360 then
              SetEntityHeading(target, GetEntityHeading(player) - 180)
            else
              SetEntityHeading(target, GetEntityHeading(player) + 180)
            end
          else
            facing = false
            SetEntityHeading(target, GetEntityHeading(player))
          end


          local anim_dict_shooter = 'combat@chg_positionpose_b'
          if facing then
            anim_clip_shooter = 'aimb_calm_bwd'
          else
            anim_clip_shooter = 'aimb_calm_fwd'
          end

          local anim_dict_target = 'ragdoll@human'
          local anim_clip_target = 'electrocute'
          
          RequestAnimDict(anim_dict_shooter)
          RequestAnimDict(anim_dict_target)

          while not HasAnimDictLoaded(anim_dict_shooter) and not HasAnimDictLoaded(anim_dict_target) do
            Wait(1)
          end

          ClearPedTasks(player)
          ClearPedTasks(target)
          
          SetEntityCoords(target, x, y, z-0.5, 0, 0, 0, false)

          TaskPlayAnim(player, anim_dict_shooter, anim_clip_shooter, 4.0, 4.0, 2500, 0, 0.0)
          TaskPlayAnim(target, anim_dict_target, anim_clip_target, 4.0, 4.0, -1, 0, 0.0)

          RemoveAnimDict(anim_dict_shooter)
          RemoveAnimDict(anim_dict_target)
          
          Citizen.Wait(2500)
          
          SetPedToRagdoll(target, 10000, 10000, 0)
        end
      end
    end
    Citizen.Wait(1)
  end
end)

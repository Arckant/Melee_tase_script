player = GetPlayerPed(-1)
Citizen.CreateThread(function()
  while true do
    GiveWeaponToPed(player, 911657153, 1, false, false)
    if GetSelectedPedWeapon(player) == 911657153 then
      if IsControlJustReleased(1, 288) then -------------- F1
        if #(GetEntityCoords(GetEntityPlayerIsFreeAimingAt(player)) - GetEntityCoords(player)) < 2 and GetPlayerPed(GetNearestPlayerToEntity(player)) ~= player then
          target = GetPlayerPed(GetNearestPlayerToEntity(player));
        else
          target = GetRandomPedAtCoord(front_space_coord, 1.5, 1.5, 1.5, -1);
        end

          
        if GetEntityHeading(player) - GetEntityHeading(target) < 0 then
          local dif = (GetEntityHeading(player) - GetEntityHeading(target)) * -1
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


        front_space_coord = 0
        x1, y1, z1 = table.unpack(GetEntityCoords(player))
        x = 0 
        y = 0

        if GetEntityHeading(player) < 22.5 or GetEntityHeading(player) > 337.5 then
          y1 = y1+1;
        elseif GetEntityHeading(player) > 22.5 and GetEntityHeading(player) < 67.5 then
          y1 = y1+0.5;
          x1 = x1-0.5;
        elseif GetEntityHeading(player) > 67.5 and GetEntityHeading(player) < 112.5 then
          x1 = x1-1
        elseif GetEntityHeading(player) > 112.5 and GetEntityHeading(player) < 157.5 then
          y1 = y1-0.5;
          x1 = x1-0.5;
        elseif GetEntityHeading(player) > 157.5 and GetEntityHeading(player) < 202.5 then
          y1 = y1-1;
        elseif GetEntityHeading(player) > 202.5 and GetEntityHeading(player) < 247.5 then
          y1 = y1-0.5;
          x1 = x1+0.5;
        elseif GetEntityHeading(player) > 247.5 and GetEntityHeading(player) < 292.5 then 
          x1 = x1+1
        else
          y1 = y1+0.5;
          x1 = x1+0.5;
        end

        front_space_coord = vector3(x1, y1, z1 - 1)
        
        if #(GetEntityCoords(GetEntityPlayerIsFreeAimingAt(player)) - GetEntityCoords(player)) < 2 and GetPlayerPed(GetNearestPlayerToEntity(player)) ~= player then
          target = GetPlayerPed(GetNearestPlayerToEntity(player));
        else
          target = GetRandomPedAtCoord(front_space_coord, 1.5, 1.5, 1.5, -1);
        end
        
        
        if target ~= 0 then
          
          SetEntityCoords(target, front_space_coord, 0, 0, 0, false)
          
          RequestAnimDict(anim_dict_shooter)
          RequestAnimDict(anim_dict_target)

          while not HasAnimDictLoaded(anim_dict_shooter) and not HasAnimDictLoaded(anim_dict_target) do
            Wait(1)
          end

          ClearPedTasks(player)
          ClearPedTasks(target)
          

          TaskPlayAnim(player, anim_dict_shooter, anim_clip_shooter, 4.0, 4.0, 2500, 0, 0.0)
          TaskPlayAnim(target, anim_dict_target, anim_clip_target, 4.0, 4.0, -1, 0, 0.0)
          
          PlaySoundFrontend(-1, "0x03C504FC", "explosions", false)

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

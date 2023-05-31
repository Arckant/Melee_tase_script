player = GetPlayerPed(-1)

Citizen.CreateThread(function()
  while true do
    GiveWeaponToPed(player, 911657153, 1, false, false)
    if GetSelectedPedWeapon(player) == 911657153 then
      if IsControlJustReleased(1, 288) then -------------- F1
        target = GetEntityPlayerIsFreeAimingAt(player)
        if target ~= 0 and #(GetEntityCoords(GetEntityPlayerIsFreeAimingAt(player)) - GetEntityCoords(player)) < 2 then 

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


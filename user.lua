-- Global variables
local target = nil
local cooldowns = {0, 0, 0}
local ticks = 0
local bullet_ant_id = -100
local bullet_act_id = -100
local bullet_ant_pos = vec.new(-10,-10)
local bullet_act_pos = vec.new(-10,-10)
local bullet_dir = vec.new(-10,-10)
local esquina_value = 0
local modo_huir = 0
local modo_huir_tick = 0
-- Initialize bot
function bot_init(me)
	esquina_value = math.random(0, 50)
end
-- Main bot function
function bot_main(me)
    local me_pos = me:pos()

    -- Update cooldowns
    for i = 1, 3 do
        if cooldowns[i] > 0 then
            cooldowns[i] = cooldowns[i] - 1
        end
    end
    -- Find the closest visible enemy and bullet
    local closest_enemy = nil
    local min_distance = math.huge
    local closest_bullet = nil
    local min_distance_bullet = math.huge


        for i, object in ipairs(me:visible()) do
        local dist = vec.distance(me_pos, object:pos())
        if dist < min_distance and object:type() == 'player' then
            min_distance = dist
            closest_enemy = object
        elseif dist < min_distance_bullet and object:type() == 'small_proj' then
            min_distance_bullet = dist
            closest_bullet = object
            bullet_act_id = closest_bullet:id()
            bullet_act_pos = closest_bullet:pos()
            if bullet_act_id == bullet_ant_id then
                bullet_dir = bullet_act_pos:sub(bullet_ant_pos)
                local dist_ant = vec.distance(me_pos, bullet_ant_pos)
                local dist_act = vec.distance(me_pos, bullet_act_pos)
                if (dist_ant - dist_act) == 40 then
                   bullet_dir = vec.new(bullet_dir:x()*math.sin(math.deg(45)), buller_dir:y())
                   me:move(bullet_dir)
                end
            end
            bullet_ant_id = bullet_act_id
            bullet_ant_pos = bullet_act_pos
            bullet_act_id = -100
            bullet_act_pos = vec.new(-10,-10)
        end
    end

    --MOVEMENT--
    local death_circle = me:cod()
    local d = vec.distance(me:pos(),vec.new(me:cod():x(),me:cod():y()))

    --local vision = me:visible()
    --dodge a bullet



    --MOVEMENT--
    local death_circle = me:cod()
    local d = vec.distance(me:pos(),vec.new(me:cod():x(),me:cod():y()))

    --local vision = me:visible()
    --dodge a bullet

	if (modo_huir and (death_circle:x() == -1 or d <= death_circle:radius() - 5)  and (ticks - modo_huir_tick) < 240) then
		me:move(vec.new(closest_enemy:pos():x(),closest_enemy:pos():y()):sub(me:pos()):neg())
		
	else 
		modo_huir = 0
	end
	
	if (ticks < 800 and closest_enemy and vec.distance(me:pos(), closest_enemy:pos()) < 120) then
		modo_huir = 1
		modo_huir_tick = ticks

    elseif (death_circle:x() == -1) then
        me:move(vec.new(250,0):sub(me:pos()))
    elseif (d > death_circle:radius() - 5) then
        me:move(vec.new(death_circle:x(),death_circle:y()):sub(me:pos()))
		
    elseif (ticks < 20000) then
        -- posición actual del jugador
        local x = vec.new(me:cod():x(),me:cod():y()):sub(me:pos()):y()
        local y = -vec.new(me:cod():x(),me:cod():y()):sub(me:pos()):x()
        me:move(vec.new(x, y))
	
    end

    -- Set target to closest visible enemy
    for i, object in ipairs(me:visible()) do
        local dist = vec.distance(me_pos, object:pos())
        if dist < min_distance and object:type() == 'player' then
            min_distance = dist
            closest_enemy = object
        elseif dist < min_distance_bullet and object:type() == 'small_proj' then
            min_distance_bullet = dist
            closest_bullet = object
            bullet_act_id = closest_bullet:id()
            bullet_act_pos = closest_bullet:pos()
            print("picklin t'agrada la tita?")
            if bullet_act_id == bullet_ant_id then
                bullet_dir = bullet_act_pos:sub(bullet_ant_pos)
                local dist_ant = vec.distance(me_pos, bullet_ant_pos)
                local dist_act = vec.distance(me_pos, bullet_act_pos)
                print("kekw")
                print(dist_ant)
                print(dist_act)
                if (dist_ant - dist_act) == 40 then
                   bullet_dir = vec.new(bullet_dir:x()*math.sin(math.deg(90)), bullet_dir:y())
                   --me:move(bullet_dir)
                   print(bullet_dir)
                   --priority_move = 1
                end
            end
            bullet_ant_id = bullet_act_id
            bullet_ant_pos = bullet_act_pos
            bullet_act_id = -100
            bullet_act_pos = vec.new(-10,-10)
        end
    end


    -- Set target to closest visible enemy
    local target = closest_enemy

    if target then
        local direction = target:pos():sub(me_pos)
        local random = math.random(0, 20)
        --local center = vec.new(250+random, 250+random):sub(me_pos)
        --me:cast(0, direction)
        --cooldowns[1] = me:cooldown(0)
        -- If target is within melee range and melee attack is not on cooldown, use melee at
        if min_distance <= 2 and cooldowns[3] == 0 then
            me:cast(2, direction)
            cooldowns[3] = me:cooldown(2)
            
            -- If target is not within melee range and projectile is not on cooldown, use projecelse
        elseif cooldowns[1] == 0  then
            me:cast(0, direction)
            cooldowns[1] = me:cooldown(0)
        end
    end


    ticks = ticks + 1
end

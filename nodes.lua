--give yourself a torch & wield it.
-- Loop through all registered biomes
for name, def in pairs(minetest.registered_biomes) do
    -- Check if the biome has a depth_filler parameter
--	minetest.log("x","name:"..name.." filler:"..def.depth_filler)
    if def.depth_filler then
        -- Override the depth_filler parameter
        def.depth_filler = 30
        
        -- Unregister and re-register the biome with the new parameter
        minetest.unregister_biome(name)
        minetest.register_biome(def)
    end
end

local function dirtTouchAction(player)
	local pos = player:get_pos()

	local x_offset, z_offset= get_direction_offsets(player)
	--minetest.log("x","x_start:"..x_start..", x_end:"..x_end)	
	--minetest.log("x","z_start:"..z_start..", z_end:"..z_end)	
	local dirt_dug = false

	for dx = x_offset, x_offset do
		--minetest.log("x","dx:"..dx)	
		for dy = 0, 1 do
			for dz = z_offset, z_offset do
				--minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(neighbor_pos)
				
				if (node.name == "default:dirt" or node.name == "default:dry_dirt" )then
					minetest.set_node(neighbor_pos, {name = "air", param2 = node.param2})
					dirt_dug = true
							
				end
			end
		end
	end
    if dirt_dug then 
		minetest.sound_play("default_dig_crumbly", {pos = pos, gain = 0.5, max_hear_distance = 10}) 
		
		for dx = x_offset, x_offset do
			--minetest.log("x","dx:"..dx)	
			for dy = 1, 2 do
				for dz = z_offset, z_offset do
					--minetest.log("x","dz:"..dz)	
					local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
					local node = minetest.get_node(neighbor_pos)
					minetest.check_for_falling(neighbor_pos)
				end
			end
		end
	end
		--minetest.log("x","x:"..neighbor_pos.x ..",z:"..neighbor_pos.z)		
	
end

registerNodeTouchAction("default:dirt", dirtTouchAction)
registerNodeTouchAction("default:dry_dirt", dirtTouchAction)

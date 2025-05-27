local mesecons_picture_path = minetest.get_modpath(minetest.get_current_modname()) .."/textures"


-- Count the number of pictures.
pictures_in_folder = minetest.get_dir_list(mesecons_picture_path)

local picture_list = {}

for _,picture in ipairs(pictures_in_folder) do
	if string.find(picture, "_still.png") then
		picture_list[#picture_list+1] = picture
	end
end

local N = #picture_list

local function show_picture_formspec(playername, page)
	local images_per_page = 8
	local total_pages = math.ceil(N / images_per_page)
	page = math.max(1, math.min(page or 1, total_pages))

	local formspec = "size[9,5.5]"
	formspec = formspec .. "label[0,0;(Page "..page.." of "..total_pages..")]"

	local start_idx = (page - 1) * images_per_page + 1
	local end_idx = math.min(page * images_per_page, N)

	local x, y = 0, 0.5
	for i = start_idx, end_idx do
		local pic = picture_list[i]
		formspec = formspec .. "image_button["..x..","..y..";2,2;"..pic..";pic_"..i..";]"
		x = x + 2.2
		if (i - start_idx + 1) % 4 == 0 then
			x = 0
			y = y + 2.2
		end
	end
	-- Navigation buttons
	if page > 1 then
		formspec = formspec .. "button[0,5;2,0.6;prev_page;<< Previous]"
	end
	if page < total_pages then
		formspec = formspec .. "button[7,5;2,0.6;next_page;Next >>]"
	end

	minetest.show_formspec(playername, "gemalde:select_picture", formspec)
end


-- register for each picture
for n=1, N do

	local groups = {choppy=2, dig_immediate=3, picture=1, not_in_creative_inventory=1}
	if n == 1 then
		groups = {choppy=2, dig_immediate=3, picture=1}
	end

	-- node
	minetest.register_node("gemalde:node_"..n.."", {
		description = "Picture #"..n.."",
		drawtype = "signlike",
		tiles = {picture_list[n]},
		visual_scale = 3.0,
		inventory_image = "gemalde_node.png",
		wield_image = "gemalde_node.png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "wallmounted",
		},
		groups = groups,

		on_rightclick = function(pos, node, clicker)

			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")

			if clicker:get_player_name() == owner or minetest.check_player_privs(clicker, { protection_bypass = true }) then

				show_picture_formspec(clicker:get_player_name(), 1)

				minetest.register_on_player_receive_fields(function(player, formname, fields)
					if formname ~= "gemalde:select_picture" then return end
					local page = tonumber(fields.page) or 1

					-- Navigation
					if fields.prev_page then
						show_picture_formspec(player:get_player_name(), page - 1)
						return
					elseif fields.next_page then
						show_picture_formspec(player:get_player_name(), page + 1)
						return
					end

					-- Picture selection
					for i = 1, N do
						if fields["pic_"..i] then
							node.name = "gemalde:node_"..i
							minetest.env:set_node(pos, node)
							local meta = minetest.get_meta(pos)
							meta:set_string("owner", owner)
							return
						end
					end
				end)
			end
		end,

		after_place_node = function(pos, placer, itemstack, pointed_thing)
            local meta = minetest.get_meta(pos)
            meta:set_string("owner", placer:get_player_name())
        end,
	})

	-- crafts
	if n < N then
		minetest.register_craft({
			output = 'gemalde:node_'..n..'',
			recipe = {
				{'gemalde:node_'..(n+1)..''},
			}
		})
	end

	n = n + 1

end

-- close the craft loop
minetest.register_craft({
	output = 'gemalde:node_'..N..'',
	recipe = {
		{'gemalde:node_1'},
	}
})

-- initial craft
minetest.register_craft({
	output = 'gemalde:node_1',
	recipe = {
		{'default:paper', 'default:paper'},
		{'default:paper', 'default:paper'},
		{'default:paper', 'default:paper'},
	}
})

-- reset several pictures to #1
minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 2',
	recipe = {'group:picture', 'group:picture'},
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 3',
	recipe = {'group:picture', 'group:picture', 'group:picture'},
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 4',
	recipe = {
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture'
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 5',
	recipe = {
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture', 'group:picture'
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 6',
	recipe = {
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture', 'group:picture', 'group:picture'
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 7',
	recipe = {
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture'
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 8',
	recipe = {
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture', 'group:picture', 'group:picture', 
		'group:picture', 'group:picture'
	}
})

minetest.register_craft({
	type = 'shapeless',
	output = 'gemalde:node_1 9',
	recipe = {
			'group:picture', 'group:picture', 'group:picture', 
			'group:picture', 'group:picture', 'group:picture', 
			'group:picture', 'group:picture', 'group:picture'
		}
})

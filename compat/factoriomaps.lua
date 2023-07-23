Compat = Compat or {}

local function cleanup_entities_for_factoriomaps()
	print("Starting factoriomaps-factorissimo integration script")

	for surface, factoryList in pairs(global.surface_factories) do

		remote.call("factoriomaps", "surface_set_hidden", surface, true)

		for _, factory in pairs(factoryList) do
			if factory.built then
				for _, id in pairs(factory.outside_overlay_displays) do
					rendering.destroy(id)
				end

				remote.call("factoriomaps", "link_renderbox_area", {
					from = {
						{ factory.outside_x - factory.layout.outside_size / 2, factory.outside_y - factory.layout.outside_size / 2 },
						{ factory.outside_x + factory.layout.outside_size / 2, factory.outside_y + factory.layout.outside_size / 2 },
						surface = factory.outside_surface.name
					},
					to = {
						{ factory.inside_x - factory.layout.inside_size / 2 - 1, factory.inside_y - factory.layout.inside_size / 2 - 1 },
						{ factory.inside_x + factory.layout.inside_size / 2 + 1, factory.inside_y + factory.layout.inside_size / 2 + 1 },
						surface = factory.inside_surface.name
					}
				})

			end
		end
	end
end

function Compat.handle_factoriomaps()
	if remote.interfaces.factoriomaps then
		script.on_event(remote.call("factoriomaps", "get_start_capture_event_id"), cleanup_entities_for_factoriomaps)
	end
end

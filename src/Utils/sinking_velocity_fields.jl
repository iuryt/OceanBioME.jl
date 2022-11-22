using Oceananigans.Fields: ZFaceField
using Oceananigans.Forcings: maybe_constant_field

function setup_velocity_fields(drift_speeds, grid, open_bottom)
    drift_velocities = []
    for (u, v, w) in values(drift_speeds)
        if isa(values(w), Number)
            if open_bottom
                u, v, w = maybe_constant_field.((u, v, w))
            else
                w_field = ZFaceField(grid)
                for k=1:grid.Nz 
                    @inbounds w_field[:, :, k] .= w * (1 - exp((1-k)/2))
                end
                w = w_field
            end
        end # otherwise we give up and rely on the user

        push!(drift_velocities, (; u, v, w))
    end

    return NamedTuple{keys(drift_speeds)}(drift_velocities)
end
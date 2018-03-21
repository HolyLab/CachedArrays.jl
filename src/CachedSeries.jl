module CachedSeries

import Base: size, getindex, setindex!, show, eltype

export CachedSeries2D

include("util.jl")
include("cached_series_2d.jl")

end # module

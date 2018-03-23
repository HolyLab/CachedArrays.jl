module CachedSeries

using Images, AxisArrays, Unitful #just for utility functions (may move those?)

import Base: size, getindex, setindex!, show, eltype

export CachedSeries2D,
        axisspacing,      #utility
        match_axisspacing #utility

include("util.jl")
include("cached_series_2d.jl")

end # module

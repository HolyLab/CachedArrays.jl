__precompile__()

module CachedSeries

#below deps are just for utility functions (may move those?)
using Images, Unitful
using AxisArrays
const axes = Base.axes

import Base: size, getindex, setindex!, show, eltype, indices

export CachedArray,
        cache_axes,
        noncache_axes,
        axisspacing,      #utility
        match_axisspacing #utility

include("util.jl")
include("cached_series.jl")
include("cached_series_nd.jl")
include("cached_slice_series_nd.jl")

end # module

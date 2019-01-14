__precompile__()

module CachedSeries

#below deps are just for utility functions (may move those?)
using Images, Unitful
using AxisArrays
const axes = Base.axes

import Base: size, getindex, setindex!, show, eltype, indices

export CachedArray,
        cached_axes,
        noncached_axes,
        axisspacing,      #utility
        match_axisspacing #utility

include("util.jl")
include("abstract_cached_array.jl")
include("cached_array.jl")

end # module

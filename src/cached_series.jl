abstract type AbstractCachedSeries{TO,TI,N} <: AbstractArray{TO,N} end

eltype(A::AbstractCachedSeries{T}) where {T} = T
Base.IndexStyle(::Type{<:AbstractCachedSeries}) = IndexCartesian()

#Below functions must be defined to use the AbstractCachedSeries interface
cache_idxs(A::AbstractCachedSeries) = error("Subtypes of AbstractCachedSeries must implement their own cache_idxs method to retrieve a tuple of integer indices locating the cached 2D slice")
cache(A::AbstractCachedSeries) = error("Subtypes of AbstractCachedSeries must implement their own cache method to retrieve the currently cached 2D slice array")
update_cache!(A::AbstractCachedSeries, args...) = error("Subtypes of AbstractCachedSeries must implement their own update_cache! method to update or replace the current cached slice array")
size(A::AbstractCachedSeries) = error("Subtypes of AbstractCachedSeries must implement their own size method")

show(io::IO, ::MIME"text/plain", A::AbstractCachedSeries{T}) where {T} = show(io, A)
show(io::IO, A::AbstractCachedSeries{T}) where {T} = print(io, "Subtypes of AbstractCachedSeries should implement their own show(io::IO, A) method")
getindex(A::AbstractCachedSeries, args...) = error("Subtypes of AbstractCachedSeries should implement their own getindex method")
setindex!(A::AbstractCachedSeries, args...) = error("Subtypes of AbstractCachedSeries are read-only by default")

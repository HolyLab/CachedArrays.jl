#abstract type AbstractCachedArray{TO,TI,N,NC,AA} <: AbstractArray{TO,N} end
abstract type AbstractCachedArray{TO,N,TI,NC,AA} <: AbstractArray{TO,N} end

#IndexCartesian is the default, but in case that changes...
Base.IndexStyle(::Type{<:AbstractCachedArray}) = IndexCartesian()

#The four functions below and the update_cache! function may be enough
#to define an interface that's easily extended
parent(A::AbstractCachedArray) = A.parent
cache(A::AbstractCachedArray) = A.cached
current_I(A::AbstractCachedArray) = A.current_I
set_I!(A, inds) = A.current_I = inds

size(A::AbstractCachedArray) = size(parent(A))
axes(A::AbstractCachedArray) = axes(parent(A))

#Return the axes of the parent array corresponding with the cache
#(The first nd_cache dimensions)
cached_axes(A::AbstractCachedArray) = _cached_axes(axes(cache(A)), axes(parent(A)))
_cached_axes(ac, ap) = (first(ap), _cached_axes(Base.tail(ac), Base.tail(ap))...)
_cached_axes(ac::Tuple{}, ap) = ()

#Return the axes of the parent array not included in the cache
#(The last N-nd_cache dimensions)
noncached_axes(A::AbstractCachedArray) = _noncached_axes(axes(cache(A)), axes(parent(A)))
_noncached_axes(ac, ap) = _noncached_axes(Base.tail(ac), Base.tail(ap))
_noncached_axes(ac::Tuple{}, ap) = ap

function update_cache!(A::AbstractCachedArray{T}, inds::NTuple{N, Int}) where {T, N}
    cache(A) .= parent(A)[cached_axes(A)...,inds...]
    set_I!(A, inds)
end

Base.show(io::IO, A::AbstractCachedArray) = print(io, summary(A)*"\n")
Base.show(io::IO, ::MIME"text/plain", A::AbstractCachedArray) = show(io, A)

getindex(A::AbstractCachedArray{TO,N,TI,NC,AA}, I::Vararg{Int,N}) where {TO,N,TI,NC,AA} =
    _getslice(A, _cached_axes(axes(cache(A)), (I...,)), _noncached_axes(axes(cache(A)), (I...,)))

setindex!(A::AbstractCachedArray{TO,N,TI,NC,AA}, v, I::Vararg{Int, N}) where {TO,N,TI,NC,AA} =
    _setslice!(A, v, _cached_axes(axes(cache(A)), (I...,)), _noncached_axes(axes(cache(A)), (I...,)))

function _getslice(A::AbstractCachedArray{TO,N,TI,NC,AA}, cidxs::NTuple{NC,Int}, ncidxs::NTuple{NV,Int}) where {TO,N,TI,NC,AA,NV}
    if current_I(A) != ncidxs
        update_cache!(A, ncidxs)
    end
    return cache(A)[cidxs...] #Assumes the cache and the parent have the same indexing conventions. May be fine since we constructed with similar.
end

function _setslice!(A::AbstractCachedArray{TO,N,TI,NC,AA}, val, cidxs::NTuple{NC,Int}, ncidxs::NTuple{NV,Int}) where {TO,N,TI,NC,AA,NV}
    A.parent[cidxs..., ncidxs...] = val
    if current_I(A) != ncidxs
        update_cache!(A, ncidxs)
    else
        cache(A)[cidxs...] = val
    end
    return A
end

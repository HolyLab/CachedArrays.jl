abstract type CachedSeriesND{TO,TI,N,NC,AA} <: AbstractCachedSeries{TO,TI,N,NC,AA} end

#getindex(A::CachedSeriesND, i1::Int, i2::Int, I::Vararg{Int,N}) where {N} = _getslice(A, i1, i2, I...)
#setindex!(A::CachedSeriesND{TO,TI,N1,AA}, v, i1::Int, i2::Int, I::Vararg{Int, N}) where {TO,TI,N1,N,AA} = _setslice!(A, v, i1, i2, I...)

getindex(A::CachedSeriesND{TO,TI,N,NC,AA}, I::Vararg{Int,N}) where {TO,TI,N,NC,AA} =
    _getslice(A, _cache_axes(axes(cache(A)), (I...,)), _noncache_axes(axes(cache(A)), (I...,)))

setindex!(A::CachedSeriesND{TO,TI,N,NC,AA}, v, I::Vararg{Int, N}) where {TO,TI,N,NC,AA} =
    _setslice!(A, v, _cache_axes(axes(cache(A)), (I...,)), _noncache_axes(axes(cache(A)), (I...,)))

function _getslice(A::CachedSeriesND{TO,TI,N,NC,AA}, cidxs::NTuple{NC,Int}, ncidxs::NTuple{NV,Int}) where {TO,TI,N,NC,AA,NV}
    if cache_idxs(A) != ncidxs
        update_cache!(A, ncidxs)
    end
    return cache(A)[cidxs...] #Assumes the cache and the parent have the same indexing conventions. May be fine since we constructed with similar.
end

function _setslice!(A::CachedSeriesND{TO,TI,N,NC,AA}, val, cidxs::NTuple{NC,Int}, ncidxs::NTuple{NV,Int}) where {TO,TI,N,NC,AA,NV}
    A.parent[cidxs..., ncidxs...] = val
    if cache_idxs(A) != ncidxs
        update_cache!(A, ncidxs)
    else
        cache(A)[cidxs...] = val
    end
    return A
end

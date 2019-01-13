abstract type CachedSeries2D{TO,TI,N,AA} <: AbstractCachedSeries{TO,TI,N,AA} end

getindex(A::CachedSeries2D, i1::Int, i2::Int, I::Vararg{Int,N}) where {N} = _getslice(A, i1, i2, I...)
setindex!(A::CachedSeries2D{TO,TI,N1,AA}, v, i1::Int, i2::Int, I::Vararg{Int, N}) where {TO,TI,N1,N,AA} = _setslice!(A, v, i1, i2, I...)

function _getslice(A::CachedSeries2D, dim1, dim2, queryidxs::Vararg{Int,N}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2)
end

#function _setslice!(A::CachedSeries2D, val, dim1, dim2, queryidxs::NTuple{N,Int}) where {N}
function _setslice!(A::CachedSeries2D, val, dim1, dim2, queryidxs::Vararg{Int,N}) where {N}
    A.parent[dim1,dim2,queryidxs...] = val
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    else
        cache(A)[dim1,dim2] = val
    end
    return A
end

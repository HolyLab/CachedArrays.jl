#Like 2D version except that lazy computation / caching is applied to the first 3 dimensions
abstract type CachedSeries3D{TO,TI,N,AA} <: AbstractCachedSeries{TO,TI,N,AA} end

getindex(A::CachedSeries3D, i1::Int, i2::Int, i3::Int, I::Vararg{Int,N}) where {N} = _getslice(A, i1, i2, i3, I...)
setindex!(A::CachedSeries3D{TO,TI,N1,AA}, v, i1::Int, i2::Int, i3::Int, I::Vararg{Int, N}) where {TO,TI,N1,N,AA} = _setslice!(A, v, i1, i2, i3, I...)
function _getslice(A::CachedSeries3D, dim1, dim2, dim3, queryidxs::Vararg{Int,N}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2,dim3)
end

function _setslice!(A::CachedSeries3D, val, dim1, dim2, dim3, queryidxs::Vararg{Int,N}) where {N}
    A.parent[dim1,dim2,dim3,queryidxs...] = val
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    else
        cache(A)[dim1,dim2,dim3] = val
    end
    return A
end

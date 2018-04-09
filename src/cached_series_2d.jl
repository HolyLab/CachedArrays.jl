abstract type CachedSeries2D{TO,TI,N} <: AbstractCachedSeries{TO,TI,N} end

getindex(A::CachedSeries2D, dim1, dim2, dim3::Int) = _getslice(A, dim1, dim2, (dim3,))
getindex(A::CachedSeries2D, dim1, dim2, dim3::Int, dim4::Int) = _getslice(A, dim1, dim2, (dim3,dim4))

#function _getslice(A::CachedSeries2D, dim1::Union{AbstractUnitRange, Colon}, dim2::Union{AbstractUnitRange,Colon}, queryidxs::NTuple{N,Int}) where {N}
function _getslice(A::CachedSeries2D, dim1, dim2, queryidxs::NTuple{N,Int}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2)
end

#returns multiple slices.  This is memory-inefficient (allocates 2x as much as a mutating version would)
#function getindex(A::CachedSeries2D{T}, dim1::Union{AbstractUnitRange,Colon}, dim2::Union{AbstractUnitRange,Colon}, queryidxs...) where {T}
function getindex(A::CachedSeries2D{T}, dim1, dim2, queryidxs...) where {T}
    outsz = _idx_shape(A, (dim1, dim2, queryidxs...))
    output = zeros(T, outsz...)
    _getindex!(output, A, lose_colons(indices(A), dim1, dim2, queryidxs...)...)
end

function _getindex!(prealloc::AbstractArray{TO}, A::CachedSeries2D{TO}, idxs1, idxs2, queryidxs...) where {TO}
    itr = enumerate(Base.product(queryidxs...))
    itrsz = size(itr)
    for (ipre, ia) in itr
        prealloc[:, :, ind2sub(itrsz, ipre)...] = A[idxs1,idxs2,ia...]
    end
    return prealloc
end

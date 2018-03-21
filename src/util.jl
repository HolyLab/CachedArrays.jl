_idxs(A, dim, idxs) = idxs
_idxs(A, dim, idxs::Colon) = indices(A,dim)

function _idx_shape(A::AbstractArray, idxs)
    lens = zeros(Int, ndims(A))
    for i = 1:ndims(A)
        lens[i] = length(_idxs(A, i, idxs[i]))
    end
    return (lens...)
end

_index_slice(A::AbstractArray{T,2}, dim1::Colon, dim2::Colon) where {T} = A
_index_slice(A::AbstractArray{T,2}, dim1, dim2) where {T} = A[dim1,dim2]

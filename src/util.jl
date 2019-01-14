#This is an odd place to keep these.  Could see about PR to AxisArrays?
axisspacing(A::AxisArray) = map(step, axisvalues(A))
match_axisspacing(B::AbstractArray{T,N}, A::IM) where {T,N, IM<:ImageMeta} = ImageMeta(match_axisspacing(B, data(A)), properties(A))
function match_axisspacing(B::AbstractArray{T,N}, A::AxisArray{T2,N}) where {T,T2,N}
    sp = axisspacing(A)
    nms = axisnames(A)
    newaxs = []
    for ax = 1:length(sp)
        u = unit(sp[ax])
        push!(newaxs, Axis{nms[ax]}(linspace(0.0*u, (size(B,ax)-1)*sp[ax], size(B,ax))))
    end
    return AxisArray(B, newaxs...)
end

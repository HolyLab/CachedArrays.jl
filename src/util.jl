#This is an odd place to keep these.  Could see about PR to AxisArrays?
axisspacing(A::AxisArray) = map(step, axisvalues(A))
match_axisspacing(B::AbstractArray{T,N}, A::IM) where {T,N, IM<:ImageMeta} = ImageMeta(match_axisspacing(B, data(A)), properties(A))
function match_axisspacing(B::AbstractArray{T,N}, A::AxisArray{T2,N}) where {T,T2,N}
    sp = axisspacing(A)
    nms = axisnames(A)
    axf = ax->begin
        u = unit(sp[ax])
        Axis{nms[ax]}(range(0.0*u, stop=(size(B,ax)-1)*sp[ax], length=size(B,ax)))
    end
    newaxs = map(axf, 1:length(sp))
    return AxisArray(B, newaxs...)
end

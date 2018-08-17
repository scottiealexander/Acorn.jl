module SimpleParser

export printrow, TokenStream, peek

mutable struct TokenStream{T<:AbstractString}
    src::T
    ptr::Int
end
TokenStream(src::AbstractString) = TokenStream(src, 1)

function peek(t::TokenStream)
    ptr = t.ptr
    tkn, k = next(t, ptr)
    t.ptr = ptr
    return tkn
end

function Base.collect(t::TokenStream)
    x = Vector{SubString{String}}()
    while !done(t)
        push!(x, next(t)[1])
    end
    return x
end

Base.done(t::TokenStream, state::Integer=1) = t.ptr > length(t.src)
Base.start(t::TokenStream) = 1

function Base.next(t::TokenStream, state::Integer=1)
    t.ptr > length(t.src) && return "", t.ptr

    x = t.src[t.ptr:t.ptr]

    if ismatch(r"\w|\.", x)
        k = findnext_nonmatch(t, r"\w|\.", t.ptr)
    elseif x[1] == '\'' || x[1] == '"'
        k = findnext(t, x[1], t.ptr+1)
    elseif ismatch(r"[^\w\s]", x)
        if x == "#"
            k = findnext_nonmatch(t, r"[^\n\r]{1,2}", t.ptr)
        else
            k = t.ptr
        end
    elseif isspace(x[1])
        k = findnext_nonmatch(t, r"\s", t.ptr)
    end

    tkn = SubString(t.src, t.ptr, k)
    t.ptr = k + 1

    return tkn, t.ptr
end

function findnext_nonmatch(t::TokenStream, r::Regex, start::Integer)
    k = start
    while k < length(t.src) && ismatch(r, t.src[k+1:k+1])
        k += 1
    end
    return k
end

function findnext(t::TokenStream, chr::Char, start::Integer)
    start >= length(t.src) && return length(t.src)

    k = start
    while k <= length(t.src)
        if t.src[k] == chr && t.src[k-1] != '\\'
            break
        end
        k += 1
    end
    return k
end

function printrow(io::IO, x::AbstractString, colorfun::Function)
    ts = TokenStream(x)
    while !done(ts)
        tkn = next(ts)[1]
        print_with_color(colorfun(ts, tkn), io, tkn)
    end
    return io
end

# function Base.show(io::IO, t::TokenStream)
#     while !done(t)
#         tkn = next(t)[1]
#         print_with_color(get_color_pzl(t, tkn), io, tkn)
#     end
#     return io
# end
#
# function test()
#     src = """
#     #this is a comment
#     x = 0
#     while x < 10
#         println("hello world")
#         x += 1 #set x to be 1
#         yield()
#     end
#     """
#     # return TokenStream(src)
#     return TokenStream(src)
# end

end

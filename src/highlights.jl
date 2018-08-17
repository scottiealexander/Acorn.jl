function get_color_jl(t::TokenStream, x::AbstractString)
    if x[1] == '\'' || x[1] == '"'
        return :light_yellow
    elseif x[1] == '#'
        return :light_black
    elseif peek(t) == "("
        return :light_cyan
    elseif ismatch(r"^[\-\+]?\d+$|^[\-\+]?\d*\.\d+$|^true$|^false$", x)
        return :magenta
    elseif ismatch(r"^if$|^elseif$|^else$|^end$|^for$|^while$|^function$|^continue$|^break$|^return$|^using$|^import$|^begin$|^do$|^let$", x)
        return :red
    else
        return :white
    end
end

function get_color_pzl(t::TokenStream, x::AbstractString)
    if x[1] == '#'
        return :light_black
    elseif x == "red"
        return :light_red
    elseif x == "green"
        return :light_green
    elseif x == "blue"
        return :light_blue
    elseif x == "^"
        return :magenta
    elseif x == "*"
        return :yellow
    elseif x == "x"
        return :light_black
    elseif length(x) == 1 && ismatch(r"[neswNESW]", x)
        return :light_yellow
    else
        return :white
    end
end

function get_color_function(pth::String)
    ext = splitext(pth)[2]
    if ext == ".pzl"
        return get_color_pzl
    else
        return get_color_jl
    end
end

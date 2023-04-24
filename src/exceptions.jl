struct MetadataException <: Exception
    code::Int64
    msg::String
    
    function MetadataException(code::Int64, msg::String)
        new(code, msg)
    end
end

struct AuthenticationTypeException <: Exception
    code::Int64
    msg::String
    
    function AuthenticationTypeException(code::Int64, msg::String)
        new(code, msg)
    end
end
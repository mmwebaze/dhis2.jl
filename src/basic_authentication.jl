using Base64
using Parameters

@with_kw struct Credential
    username::String = "admin"
    password::String = "district"
    #base_url::String = "https://play.dhis2.org/2.39.1.2/api"
    base_url::String = "http://localhost:8095/api"
    #pa_token:String = ""
end


function basic()
    #credential = Credential(ENV["JDHIS2_USERNAME"], ENV["JDHIS2_PASSWORD"], ENV["JDHIS2_BASE_URL"])
    try
        credentials = string(ENV["JDHIS2_USERNAME"], ":", ENV["JDHIS2_PASSWORD"])
        encode_credentials = Base64.base64encode(credentials)
        header = Dict( "Authorization"=> string("BASIC ", encode_credentials), "Content-Type" => "application/json;charset=UTF-8");
        return header, ENV["JDHIS2_BASE_URL"]
    catch e
        throw(e)
    end 
end

# function basic(base_url, username, password)
#     credentials = string(username, ":", password)
#     encode_credentials = Base64.base64encode(credentials)
#     header = Dict( "Authorization"=> string("BASIC ", encode_credentials), "Content-Type" => "application/json;charset=UTF-8");
#     return header, base_url
# end

function pat(token)

end

function authenticate(auth_type)
    # credentials = string(credential.username, ":", credential.password)
    # encode_credentials = Base64.base64encode(credentials)
    # header = Dict( "Authorization"=> string("BASIC ", encode_credentials), "Content-Type" => "application/json;charset=UTF-8");
    # return header
    local headers
    try
        if auth_type == "basic"
            return basic()
        elseif auth_type == "pat"
            return pat()
        else
            # unsupport auth type exception
            throw(AuthenticationTypeException(101, "Unsupported authentication type: $auth_type"))
            #return -1
        end
    catch e
        ex = string("Authentication Error: ", e.msg)
        print(ex)
        throw(e)
    end    
end
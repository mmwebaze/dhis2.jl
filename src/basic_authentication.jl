using Base64
using Parameters

@with_kw struct Credential
    username::String = "admin"
    password::String = "district"
    #base_url::String = "https://play.dhis2.org/2.39.1.2/api"
    base_url::String = "http://localhost:8095/api"
    #pa_token:String = ""
end


function authenticate(credential::Credential)
    credentials = string(credential.username, ":", credential.password)
    encode_credentials = Base64.base64encode(credentials)
    header = Dict( "Authorization"=> string("BASIC ", encode_credentials), "Content-Type" => "application/json;charset=UTF-8");
    return header
end

function basic_auth(base_url, username, password)

    return Credential(username, password, base_url)
end

function pat_auth(token)

end
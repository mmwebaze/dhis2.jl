module Dhis2

using HTTP
using JSON
using DataFrames
using CSV

include("basic_authentication.jl")
export orgunit_hierarchy
export create_org_units

"""
Fetches the organizational unit hierarchy from a DHIS2 instance and returns it as a DataFrame.

base_url: The base URL of the DHIS2 instance.
auth_type: The authentication type to use when making the request.
"""
function orgunit_hierarchy(base_url::AbstractString, auth_type)
    credential = Credential()
    endpoint = string(credential.base_url, "/organisationUnits.json?paging=false&fields=id,name,displayName,level,parent[id,name]")
    
    headers = authenticate(credential);

    # Send the HTTP request and parse the response.
    response = HTTP.request("GET", endpoint, headers=headers)
    try
        org_units_found = JSON.parse(String(response.body))

        # Extract the organization units from the response.
        org_units = org_units_found["organisationUnits"]
        
        # Return an error message if no organization units were found.
        isempty(org_units) && return "NO ORG UNITS FOUND"

        uids::Vector{String} = []
        names::Vector{String} = []
        levels::Vector{Int8} = []
        parent_uids::Vector{String} = []
        parent_names::Vector{String} = []

        for ou in eachrow(org_units)

            org_unit = ou[1]
            push!(uids, org_unit["id"])
            push!(names, org_unit["name"])
            push!(levels, org_unit["level"])

            # Checks if the organisation unit has no parent. This means it's a level one org unit
            if !haskey(org_unit, "parent")
                push!(parent_uids, "")
                push!(parent_names, "")
                continue
            end

            push!(parent_uids, org_unit["parent"]["id"])
            push!(parent_names, org_unit["parent"]["name"])
        end

        org_unit_df = DataFrame(uid=uids, name=names, level=levels, parent_uid=parent_uids, parent_name=parent_names)
        #print(org_unit_df)
        return org_unit_df
    catch e
        error = string("Exception: ", e)
        print(error)
    end
end

"""
Creates organizational units using the metadata endpoint.

csv_file: The path to the csv file containing the organisation unit information. See documentation at
https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-239/metadata.html#webapi_csv_org_units
"""
function create_org_units(csv_file::AbstractString)
    credential = Credential()
    endpoint = string(credential.base_url, "/metadata")
    df = DataFrame(CSV.File(csv_file))
    columns = names(df)
    payload = []
    
    for i in 1:nrow(df)
        dic = Dict()
        for k in 1:length(columns)
            df_row = df[i, :]
            println(df_row[k])
            key = columns[k]
            if key == "parent"
                dic["parent"] = Dict("id" => df_row[k])
                continue
            end
            dic[columns[k]] = df_row[k]
        end
        push!(payload, dic)
    end
    print(payload)
    p = Dict("organisationUnits" => payload)
    data = JSON.json(p)
    headers = authenticate(credential);
    try
        response = HTTP.post(endpoint,headers=headers, body=data, verbose=2)
    catch e
        error = string("@create_org_units Exception: ", e)
    end
end

function update_org_units(base_url::AbstractString)
    url = string(base_url, "/organisationUnits")
end
# End of Package
end

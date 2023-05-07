module Dhis2

using HTTP
using JSON
using DataFrames
using CSV

include("exceptions.jl")
include("authentication.jl")
include("util.jl")

export orgunit_hierarchy
export create_metadata, update_metadata
export export_csv

"""
Fetches the organizational unit hierarchy from a DHIS2 instance and returns it as a DataFrame.

base_url: The base URL of the DHIS2 instance.
auth_type: The authentication type to use when making the request.
"""
function orgunit_hierarchy(;auth_type=basic)
    local headers
    local base_url
    
    try
        auth = authenticate(auth_type);
        headers = auth[1]
        base_url = auth[2]

        endpoint = string(base_url, "/organisationUnits.json?paging=false&fields=id,name,displayName,level,parent[id,name]")
    
        # Send the HTTP request and parse the response.
        response = HTTP.request("GET", endpoint, headers=headers)
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

        return org_unit_df, response.status
    catch e
        error = string("Exception: ", e)
        print(error)
        return -1
    end
end

"""
Creates organizational units and data elements using the metadata endpoint.

csv_file: The path to the csv file containing the organisation unit information. See documentation at
https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-239/metadata.html#webapi_csv_org_units
"""
function create_metadata(csv_file::AbstractString, metadata_type::AbstractString; auth_type="basic")
    local payload
    local headers
    local base_url
    
    try
        auth = authenticate(auth_type);
        headers = auth[1]
        base_url = auth[2]
    catch e
        return -1
    end

    #credential = Credential()
    endpoint = string(base_url, "/metadata")
    
    data = metadata_payload(csv_file);
    #headers = authenticate(credential);

    if metadata_type == "OU"
        payload = JSON.json(Dict("organisationUnits" => data))
    elseif metadata_type == "DE"
        payload = JSON.json(Dict("dataElements" => data))
    else
        # need to return a not supported metadata type exception/error
        throw(MetadataException(100, "Unsupported metadata type: $metadata_type"))
    end

    try
        response = HTTP.post(endpoint,headers=headers, body=payload, verbose=2)
        return response.status
    catch e
        error = string("@create_metadata Exception: ", e)
    end
end

"""
Updates organisation units and data elements using the metadata endpoint
"""
function update_metadata(csv_file::AbstractString, metadata_type::AbstractString; auth_type="basic")
    local response
    
    try
        auth = authenticate(auth_type);
        headers = auth[1]
        base_url = auth[2]

        if metadata_type == "OU"
            url = string(base_url, "/organisationUnits/")
        elseif metadata_type == "DE"
            url = string(base_url, "/dataElements/")
        else
            throw(MetadataException(100, "Unsupported metadata type $metadata_type"))
        end

        #headers = authenticate(credential);
        payload = metadata_payload(csv_file);
    
        for p in 1:length(payload)
            endpoint = string(url, payload[p]["id"])
            data = JSON.json(payload[p])
            response = HTTP.put(endpoint,headers=headers, body=data, verbose=2)
            print(response.status)
        end

        return response.status
    catch e
        return -1
    end
end

"""
Exports to CSV files organisations units and data elements.
"""
function export_csv(metadata_type::String, fields::Vector{String}, export_file_name; auth_type="basic")
    
    try
        url_portion = join(fields, ",")
        auth = authenticate(auth_type);
        headers = auth[1]
        base_url = auth[2]

        if metadata_type == "OU"
            endpoint = string(base_url, "/organisationUnits.json?paging=false&fields=", url_portion)
            response = HTTP.request("GET", endpoint, headers=headers)
            return process_orgunits(response, fields, export_file_name), response.status

        elseif metadata_type == "DE"
            endpoint = string(base_url, "/dataElements.json?paging=false&fields=", url_portion)
            response = HTTP.request("GET", endpoint, headers=headers)
            return process_data_elements(response, fields, export_file_name), response.status
        else
            # need to return a not supported metadata type exception/error
            throw(MetadataException(100, "Unsupported metadata type: $metadata_type"))
        end
    catch e
        return -1
    end
end
# End of Package
end

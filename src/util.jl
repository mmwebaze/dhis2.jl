

function metadata_payload(csv_file::AbstractString)
    df = DataFrame(CSV.File(csv_file))
    columns = names(df)
    payload = []
    
    for i in 1:nrow(df)
        dic = Dict()
        for k in 1:length(columns)
            df_row = df[i, :]
            key = columns[k]
            if key == "parent"
                dic["parent"] = Dict("id" => df_row[k])
                continue
            end
            if key == "attributes"
                #= string of id:value,id:value=#
                attrs = df_row[k]
                attr_values = split(attrs, ",")
                attribute_values = []
                
                for v in 1:length(attr_values)
                    #println(typeof(attr_values[v]))
                    attr_value = split(attr_values[v], ":")
                    id = attr_value[1]
                    value = attr_value[2]
                    push!(attribute_values, Dict("attribute" => Dict("id" => id), "value" => value))
                end
                dic["attributeValues"] = attribute_values
                continue
            end
            dic[columns[k]] = df_row[k]
        end
        push!(payload, dic)
    end
    print(payload)
    return payload
end

function process_orgunits(response::HTTP.Messages.Response, fields::Vector{String}, export_file_name::String)
    org_units_found = JSON.parse(String(response.body))
    org_units = org_units_found["organisationUnits"]
    isempty(org_units) && return "NO ORG UNITS FOUND"

    columns = Dict()

    for field in fields
        columns["$field"] = []
    end
    for ou in eachrow(org_units)
        org_unit = ou[1]
         for field in fields
            
            # parent and level need to be handled for OUs
            if field == "parent"
                if !haskey(org_unit, "parent")
                    push!(columns["$field"], "")
                    continue
                elseif haskey(org_unit, "parent")
                    push!(columns["$field"], org_unit["$field"]["id"])
                    continue
                end
            end
            push!(columns["$field"], org_unit["$field"])
         end 
    end
    
    df = DataFrame(columns)
    CSV.write(export_file_name, DataFrame(columns))
    return df
end

function process_data_elements(response::HTTP.Messages.Response, fields::Vector{String}, export_file_name::String)
    data_elements_found = JSON.parse(String(response.body))
    data_elements = data_elements_found["dataElements"]
    isempty(data_elements) && return "NO DATA ELEMENTS FOUND"

    columns = Dict()

    for field in fields
        columns["$field"] = []
    end
    for de in eachrow(data_elements)
        data_element = de[1]
         for field in fields
            
            # parent and level need to be handled for OUs
            # if field == "parent"
            #     if !haskey(org_unit, "parent")
            #         push!(columns["$field"], "")
            #         continue
            #     elseif haskey(org_unit, "parent")
            #         push!(columns["$field"], org_unit["$field"]["id"])
            #         continue
            #     end
            # end
            push!(columns["$field"], data_element["$field"])
         end 
    end
    df = DataFrame(columns)
    CSV.write(export_file_name, DataFrame(columns))
    return df
end
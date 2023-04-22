

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
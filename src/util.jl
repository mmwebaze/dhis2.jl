

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
            dic[columns[k]] = df_row[k]
        end
        push!(payload, dic)
    end
    #print(payload)
    return payload
end
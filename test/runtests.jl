using Dhis2
using Test

@testset "Dhis2.jl" begin

    ENV["JDHIS2_BASE_URL"] = "https://play.dhis2.org/2.39.1.2/api"
    ENV["JDHIS2_USERNAME"] = "admin"
    ENV["JDHIS2_PASSWORD"] = "district"
    auth_type = "basic"
    ou_csv = "ou.csv"
    de_csv = "de.csv"
    ou_update_csv = "ou_update.csv"
    de_update_csv = "de_update.csv"
    
    #println(ENV)

    #= Tests getting hierarchy and returns it as a dataframe =#
    @test orgunit_hierarchy(auth_type="basic")[2] == 200

    #= Tests OU operations create and update =#
    @test create_metadata("ou.csv", "OU", auth_type="basic") == 200
    @test update_metadata("ou_update.csv", "OU") == 200

    #= Tests DE operations create and update =#
    @test create_metadata("de.csv", "DE") == 200
    @test update_metadata("de_update.csv", "DE") == 200

    ou_fields = ["id","name","displayName","level","parent"]
    @test export_csv("OU", ou_fields, "ou_exported.csv", auth_type="basic")[2] == 200
    de_fields = ["id","name","displayName"]
    @test export_csv("DE", de_fields, "de_exported.csv", auth_type="basic")[2] == 200
end

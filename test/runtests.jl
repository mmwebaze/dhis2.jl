using Dhis2
using Test

@testset "Dhis2.jl" begin

    base_url = "https://play.dhis2.org/2.39.1.2/api"
    auth_type = "basic"
    ou_csv = "ou.csv"
    de_csv = "de.csv"
    ou_update_csv = "ou_update.csv"
    de_update_csv = "de_update.csv"
    
    #@test orgunit_hierarchy(base_url, auth_type)
    #@test create_metadata(ou_csv, "OU")
    #@test create_metadata(de_csv, "DE")
    @test update_metadata(ou_update_csv, "OU")
    @test update_metadata(de_update_csv, "DE")
end

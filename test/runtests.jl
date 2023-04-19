using Dhis2
using Test

@testset "Dhis2.jl" begin

    base_url = "https://play.dhis2.org/2.39.1.2/api"
    auth_type = "basic"
    @test orgunit_hierarchy(base_url, auth_type)
    @test create_org_units("test.csv")
end

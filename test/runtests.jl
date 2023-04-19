using Dhis2
using Test

@testset "Dhis2.jl" begin

    base_url = "https://play.dhis2.org/2.39.1.2/api"
    auth_type = "basic"
    test_file_csv_file = "test.csv"
    update_test_csv_file = "update_test.csv"
    @test orgunit_hierarchy(base_url, auth_type)
    @test create_org_units(test_file_csv_file)
    @test update_org_units(update_test_csv_file)
end

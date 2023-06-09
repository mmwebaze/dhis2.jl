# Dhis2

Utility functions for [DHIS2](https://dhis2.org/).   


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mmwebaze.github.io/Dhis2.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mmwebaze.github.io/Dhis2.jl/dev/)
[![Build Status](https://github.com/mmwebaze/Dhis2.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/mmwebaze/Dhis2.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/mmwebaze/Dhis2.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mmwebaze/Dhis2.jl)

## Installation

The package can be installed with Julia's package manager, either by using the Pkg REPL mode (press ] to enter):

* pkg> add Dhis2
* julia> using Pkg; Pkg.add("Dhis2")

## Project Status

The package is still under active development with release candidate (rc) 1.0 scheduled for end of April 2023. The package is built and tested on Julia 1.8.5 and DHIS2 version 2.37.3 and above. All the development and testing was carried out on macOS with the M1 chip.

## Contributing, Questions and Feature Requests

Contributions are very welcome, as are feature requests and suggestions. Please open an issue if you encounter any problems or would just like to ask a question.

## Basic Usage

### Authentication

To use any of the features provided by this package, authentication to a DHIS2 instance needs to provided. Currently the package supports basic authentication with the intention of implementing Personal Access Tokens (PAT) at a later point. If no authentication is provided, it will default to basic authentication:

* Configure environment variables JDHIS2_USERNAME, JDHIS2_PASSWORD and JDHIS2_BASE_URL
* The value of JDHIS2_BASE_URL should be in the form https://domain/api


### Available Features

```julia
    Dhis2.orgunit_hierarchy(auth_type::AbstractString) # Returns a dataframe of the entire org unit hierarchy. The auth_type parameter takes on the valye "basic" or "pat". 
    Dhis2.create_metadata(csv_file::AbstractString, metadata_type::AbstractString, auth_type::AbstractString) # Creates Organisation Units (OU) or Data Elements (DE). The metadata_type can either be OU or DE. The auth_type parameter takes on the valye "basic" or "pat".
    Dhis2.update_metadata(csv_file::AbstractString, metadata_type::AbstractString, auth_type::AbstractString) # Updates Organisation Units (OU) or Data Elements (DE). The metadata_type can either be OU or DE. The auth_type parameter takes on the valye "basic" or "pat".
    Dhis2.export_csv(metadata_type::String, fields::Vector{String}, export_file_name; auth_type="basic") # Export Org Units & Data Elements to CSV. This function also returns a dataframe
```

### Sample metadata Organisation Units & Data Elements

```csv
    name,code,parent,shortName,openingDate,attributes
    "Central Region", CR,hgZKVly5QMe,"Central Region",2023-04-19,"g2kjpD7Dgea:CR"
    "Eastern Region", ER,hgZKVly5QMe,"Eastern Region",2023-04-19,"g2kjpD7Dgea:ER"
```

```csv
    name,id,code,shortName,description,aggregationType,valueType,domainType,attributes
    "Women participated skill development training",,"D0001","Women participated in training",XYZ,SUM,INTEGER,AGGREGATE,"kWXwL5w8Rkh:Wpsd"
    "Women participated community organizations",,"D0002","Women participated in organizations",ABC,SUM,INTEGER,AGGREGATE,"kWXwL5w8Rkh:Wpco"
```

## Documentation

Detailed documentation on how to use DHIS2 API can be found [here](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-239/introduction.html).
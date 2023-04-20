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

To use any of the features provided by this package, authentication to a DHIS2 instance needs to provided. Currently the package supports basic authentication with the intention of implementing Personal Access Tokens (PAT) at a later point. If no authentication is provided, the package will point to the [demo](https://play.dhis2.org/) instance provided by DHIS2. There are two ways to create the authentication object:

1. Configuring environment variables username, password and base_url. This is the preffered setup
2. Directly calling Dhis2.basic_auth(base_url, username, password)

### Available Features

```julia
    Dhis2.orgunit_hierarchy(base_url::AbstractString, auth_type::AbstractString) # Returns a dataframe of the entire org unit hierarchy
    Dhis2.create_metadata(csv_file::AbstractString, metadata_type::AbstractString) # Creates Organisation Units (OU) or Data Elements (DE). The metadata_type can either be OU or DE.
    Dhis2.update_metadata(csv_file::AbstractString, metadata_type::AbstractString) # Updates Organisation Units (OU) or Data Elements (DE). The metadata_type can either be OU or DE.
```

### Sample metadata Organisation Units & Data Elements

```csv
    name,code,parent,shortName,openingDate
    "Central Region", CR,hgZKVly5QMe,"Central Region",2023-04-19
    "Eastern Region", ER,hgZKVly5QMe,"Eastern Region",2023-04-19
```

```csv
    name,id,code,shortName,description,aggregationType,valueType,domainType
    "Women participated skill development training",,"D0001","Women participated in training",XYZ,SUM,INTEGER,AGGREGATE
    "Women participated community organizations",,"D0002","Women participated in organizations",ABC,SUM,INTEGER,AGGREGATE
```

## Documentation

Detailed documentation on how to use DHIS2 API can be found [here](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-239/introduction.html).
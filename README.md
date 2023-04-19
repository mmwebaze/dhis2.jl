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

```julia
Dhis2.orgunit_hierarchy(base_url::AbstractString, auth_type)
print s
```

## Documentation

Detailed documentation on how to use DHIS2 API can be found [here] (https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-239/introduction.html).
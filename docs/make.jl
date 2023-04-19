using Dhis2
using Documenter

DocMeta.setdocmeta!(Dhis2, :DocTestSetup, :(using Dhis2); recursive=true)

makedocs(;
    modules=[Dhis2],
    authors="Michael Mwebaze <michael.mwebaze@gmail.com> and contributors",
    repo="https://github.com/mmwebaze/Dhis2.jl/blob/{commit}{path}#{line}",
    sitename="Dhis2.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mmwebaze.github.io/Dhis2.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mmwebaze/Dhis2.jl",
    devbranch="main",
)

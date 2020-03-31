function Get-JCNavBarLinks ()
{
    Return @(
        (New-UDLink -Text "Users" -Url "../SystemUsers"),
        (New-UDLink -Text "Systems" -Url "../Systems"),
        (New-UDLink -Text "Associations" -Url "../Associations")
    )
}


param(
    [Parameter(Mandatory = $false)]
    [string] 
    $management_group = "bdbpolicy", 
    [Parameter(Mandatory = $false)]
    [string] $lib_route = "C:\Users\User\OneDrive - Go to Cloud SAS\Desktop\Proyectos Jhon MOra\Banco de Bogota\TF_Diagnoting_Settings\TF_Diagnoting_Settings\policy-definitions\lib"
)
$all_policy = az policy definition list --query "[?policyType=='Custom' && contains(id, '${management_group}')]"  --management-group $management_group | ConvertFrom-Json
foreach ($policy in $all_policy) {
    #$($policy) | ConvertTo-json | Out-File -FilePath "${lib_route}\$($policy.name).json" -Encoding utf8
    $search = az policy definition show --name $($policy.name) --management-group $management_group
    if ($search) {
        az policy definition show --name $($policy.name) --management-group $management_group | Out-File "${lib_route}\$($policy.name).json" -Encoding utf8
    }

} 

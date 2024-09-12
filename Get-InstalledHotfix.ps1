[CmdletBinding()]
Param(
    $Computers = (Import-csv ".\servers.csv"), #Must include "adaccountname" column
    $Patch = "KB2468871"
)

$i = 1
ForEach ($Server in $Computers) {
    
    Write-Progress -Activity "Checking $Server for hotfix $Patch" -Status "$i of $($Computers.Count)" -PercentComplete (($i / $Computers.Count)*100)
    
    If(Test-Connection -Count 1 -ComputerName $Server.adaccountname){

        $hotfix = Get-HotFix -ComputerName $server.adaccountname -Id $Patch -ErrorAction 0;  
        If ($hotfix){$found = "Y"} Else {$found = "N"}
    }
    Else {$found = "ConnectFailed"}

    $Server | Select *,@{Name="Patch";Expression={$found}} | Export-CSV "Hotfix-$Patch-$(get-date -format yyyy-MM-dd).csv" -NoTypeInformation -Append  
    $i++
}

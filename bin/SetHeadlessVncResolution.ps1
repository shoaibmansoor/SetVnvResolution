function Test-RegistryValue {
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,
        
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Value
    )
    
    try {
        if (Test-Path $Path) {
            Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

function Set-Registry-Value {
    param (
        $reg_path,
        $reg_name,
        $reg_value
    )
    if(Test-RegistryValue -path $reg_path -value $reg_name) {
        Write-Host ("Setting $reg_path | Name $reg_name, Value: $reg_value")  
        Set-ItemProperty -Path $reg_path -Name $reg_name -Value $reg_value
        Write-Host ("Last command status: $?")
    }
}

$reg_path = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration'
$height = 1920
$width = 1080

Write-Host ("** Setting resolution for VNC server **")  

set-location -path $reg_path
$child_items = Get-childitem
$hex_height = "0x" + "{0:x8}" -f $height
$hex_width = "0x" + "{0:x8}" -f $width
$resolution_bit = 32
$stride_out = [math]::floor(($height * $resolution_bit + 7) / 8)
$stride = "0x" + [System.Convert]::ToString($stride_out, 16)

for($i = 0; $i -lt $child_items.length; $i++) { 
    $name = $child_items[$i].PSChildName
    if ($name -match 'EDID|SIMULATED') {
        Set-Registry-Value -reg_path "$reg_path\$name\00" -reg_name "PrimSurfSize.cx" -reg_value $hex_height
        Set-Registry-Value -reg_path "$reg_path\$name\00" -reg_name "PrimSurfSize.cy" -reg_value $hex_width
        Set-Registry-Value -reg_path "$reg_path\$name\00" -reg_name "Stride" -reg_value $stride

        Set-Registry-Value -reg_path "$reg_path\$name\00\00" -reg_name "PrimSurfSize.cx" -reg_value $hex_height
        Set-Registry-Value -reg_path "$reg_path\$name\00\00" -reg_name "PrimSurfSize.cy" -reg_value $hex_width
        Set-Registry-Value -reg_path "$reg_path\$name\00\00" -reg_name "Stride" -reg_value $stride
    }
}
if ($? -eq $true) {
    Write-Host ("** VNC Server resolution is set to $height x $width **")
}

# Flea props creation script 
# Author: Azzen <github.com/azzen>
# Date 2020-07-13 10:49:56
# Purpose: Create a json file for the flea
# Dependencies: Powershell >= 7.0.2

Param($model, $name, $price="50", $health="50", $desc="Placeholder")

$mdlName = [System.IO.Path]::GetFileNameWithoutExtension($model)
$struct = @{
    Identifier = $mdlName.ToUpper();
    Name = $name;
    Desc = $desc;
    Model = $model.Replace("\", "/");
    Health = $health;
    Category = "FURNITURE";
    Quantity = 0;
    IsStackable = "true";
    IsBuyableFromFlea = "true";
}

ConvertTo-Json $struct | Out-File ( $mdlname.ToLower() + ".json" )
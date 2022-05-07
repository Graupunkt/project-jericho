# Shows FrontEnd to User
Function Show-Frontend {
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()
}

# DYNAMIC FRONTEND
try {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
    Add-Type -assembly System.Windows.Forms
}
catch {
    Write-Warning -Message 'Unable to load required assemblies'
    return
}
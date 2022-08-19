
	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$FormSaveLocation = New-Object 'System.Windows.Forms.Form'
	$buttonCancel = New-Object 'System.Windows.Forms.Button'
	$labelSaveCurrentLocation = New-Object 'System.Windows.Forms.Label'
	$TextboxSaveComment = New-Object 'System.Windows.Forms.TextBox'
	$labelComment = New-Object 'System.Windows.Forms.Label'
	$ComboboxSaveSystem = New-Object 'System.Windows.Forms.ComboBox'
	$labelSystem = New-Object 'System.Windows.Forms.Label'
	$TextboxSaveName = New-Object 'System.Windows.Forms.TextBox'
	$labelName = New-Object 'System.Windows.Forms.Label'
	$ComboboxSaveType = New-Object 'System.Windows.Forms.ComboBox'
	$labelType = New-Object 'System.Windows.Forms.Label'
	$labelLocation = New-Object 'System.Windows.Forms.Label'
	$radiobuttonSpaceglobal = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonPlanetarylocal = New-Object 'System.Windows.Forms.RadioButton'
	$buttonSave = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$FormSaveLocation_Load={
		#TODO: Initialize Form Controls here
		
	}
	
	#region Control Helper Functions
	function Update-ComboBox
	{
	<#
		.SYNOPSIS
			This functions helps you load items into a ComboBox.
		
		.DESCRIPTION
			Use this function to dynamically load items into the ComboBox control.
		
		.PARAMETER ComboBox
			The ComboBox control you want to add items to.
		
		.PARAMETER Items
			The object or objects you wish to load into the ComboBox's Items collection.
		
		.PARAMETER DisplayMember
			Indicates the property to display for the items in this control.
			
		.PARAMETER ValueMember
			Indicates the property to use for the value of the control.
		
		.PARAMETER Append
			Adds the item(s) to the ComboBox without clearing the Items collection.
		
		.EXAMPLE
			Update-ComboBox $combobox1 "Red", "White", "Blue"
		
		.EXAMPLE
			Update-ComboBox $combobox1 "Red" -Append
			Update-ComboBox $combobox1 "White" -Append
			Update-ComboBox $combobox1 "Blue" -Append
		
		.EXAMPLE
			Update-ComboBox $combobox1 (Get-Process) "ProcessName"
		
		.NOTES
			Additional information about the function.
	#>
		
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			[System.Windows.Forms.ComboBox]
			$ComboBox,
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			$Items,
			[Parameter(Mandatory = $false)]
			[string]$DisplayMember,
			[Parameter(Mandatory = $false)]
			[string]$ValueMember,
			[switch]
			$Append
		)
		
		if (-not $Append)
		{
			$ComboBox.Items.Clear()
		}
		
		if ($Items -is [Object[]])
		{
			$ComboBox.Items.AddRange($Items)
		}
		elseif ($Items -is [System.Collections.IEnumerable])
		{
			$ComboBox.BeginUpdate()
			foreach ($obj in $Items)
			{
				$ComboBox.Items.Add($obj)
			}
			$ComboBox.EndUpdate()
		}
		else
		{
			$ComboBox.Items.Add($Items)
		}
		
		if ($DisplayMember)
		{
			$ComboBox.DisplayMember = $DisplayMember
		}
		
		if ($ValueMember)
		{
			$ComboBox.ValueMember = $ValueMember
		}
	}
	
	
	#endregion
	
	$radiobuttonSpaceglobal_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$ComboboxSaveType_SelectedIndexChanged={
		#TODO: Place custom script here
		
	}
	
	$buttonSave_Click={
		#TODO: Place custom script here
		$global:buttonSaveClicked = $true
	}
	
	$buttonCancel_Click={
		#TODO: Place custom script here
		$FormSaveLocation.close()
	}
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$FormSaveLocation.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonCancel.remove_Click($buttonCancel_Click)
			$ComboboxSaveType.remove_SelectedIndexChanged($ComboboxSaveType_SelectedIndexChanged)
			$radiobuttonSpaceglobal.remove_CheckedChanged($radiobuttonSpaceglobal_CheckedChanged)
			$buttonSave.remove_Click($buttonSave_Click)
			$FormSaveLocation.remove_Load($FormSaveLocation_Load)
			$FormSaveLocation.remove_Load($Form_StateCorrection_Load)
			$FormSaveLocation.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$FormSaveLocation.SuspendLayout()
	#
	# FormSaveLocation
	#
	$FormSaveLocation.Controls.Add($buttonCancel)
	$FormSaveLocation.Controls.Add($labelSaveCurrentLocation)
	$FormSaveLocation.Controls.Add($TextboxSaveComment)
	$FormSaveLocation.Controls.Add($labelComment)
	$FormSaveLocation.Controls.Add($ComboboxSaveSystem)
	$FormSaveLocation.Controls.Add($labelSystem)
	$FormSaveLocation.Controls.Add($TextboxSaveName)
	$FormSaveLocation.Controls.Add($labelName)
	$FormSaveLocation.Controls.Add($ComboboxSaveType)
	$FormSaveLocation.Controls.Add($labelType)
	$FormSaveLocation.Controls.Add($labelLocation)
	$FormSaveLocation.Controls.Add($radiobuttonSpaceglobal)
	$FormSaveLocation.Controls.Add($radiobuttonPlanetarylocal)
	$FormSaveLocation.Controls.Add($buttonSave)
	$FormSaveLocation.AcceptButton = $buttonSave
	$FormSaveLocation.AutoScaleDimensions = New-Object System.Drawing.SizeF(6, 13)
	$FormSaveLocation.AutoScaleMode = 'Font'
	$FormSaveLocation.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$FormSaveLocation.ClientSize = New-Object System.Drawing.Size(467, 181)
	$FormSaveLocation.FormBorderStyle = 'FixedDialog'
	$FormSaveLocation.MaximizeBox = $False
	$FormSaveLocation.MinimizeBox = $False
	$FormSaveLocation.Name = 'FormSaveLocation'
	$FormSaveLocation.StartPosition = 'CenterScreen'
	$FormSaveLocation.Text = 'Form'
	$FormSaveLocation.add_Load($FormSaveLocation_Load)
	#
	# buttonCancel
	#
	$buttonCancel.Anchor = 'Bottom, Right'
	$buttonCancel.DialogResult = 'OK'
	$buttonCancel.Location = New-Object System.Drawing.Point(380, 147)
	$buttonCancel.Name = 'buttonCancel'
	$buttonCancel.Size = New-Object System.Drawing.Size(75, 23)
	$buttonCancel.TabIndex = 13
	$buttonCancel.Text = '&Cancel'
	$buttonCancel.UseCompatibleTextRendering = $True
	$buttonCancel.UseVisualStyleBackColor = $True
	$buttonCancel.add_Click($buttonCancel_Click)
	#
	# labelSaveCurrentLocation
	#
	$labelSaveCurrentLocation.AutoSize = $True
	$labelSaveCurrentLocation.Font = [System.Drawing.Font]::new('Dungeon', '18')
	$labelSaveCurrentLocation.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelSaveCurrentLocation.Location = New-Object System.Drawing.Point(84, 14)
	$labelSaveCurrentLocation.Name = 'labelSaveCurrentLocation'
	$labelSaveCurrentLocation.Size = New-Object System.Drawing.Size(298, 27)
	$labelSaveCurrentLocation.TabIndex = 12
	$labelSaveCurrentLocation.Text = 'Save current Location'
	#
	# TextboxSaveComment
	#
	$TextboxSaveComment.Location = New-Object System.Drawing.Point(135, 145)
	$TextboxSaveComment.Name = 'TextboxSaveComment'
	$TextboxSaveComment.Size = New-Object System.Drawing.Size(121, 20)
	$TextboxSaveComment.TabIndex = 11
	#
	# labelComment
	#
	$labelComment.AutoSize = $True
	$labelComment.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$labelComment.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelComment.Location = New-Object System.Drawing.Point(25, 147)
	$labelComment.Name = 'labelComment'
	$labelComment.Size = New-Object System.Drawing.Size(79, 15)
	$labelComment.TabIndex = 10
	$labelComment.Text = 'Comment'
	#
	# ComboboxSaveSystem
	#
	$ComboboxSaveSystem.FormattingEnabled = $True
	$ComboboxSaveSystem.Location = New-Object System.Drawing.Point(135, 62)
	$ComboboxSaveSystem.Name = 'ComboboxSaveSystem'
	$ComboboxSaveSystem.Size = New-Object System.Drawing.Size(121, 21)
	$ComboboxSaveSystem.TabIndex = 9
	#
	# labelSystem
	#
	$labelSystem.AutoSize = $True
	$labelSystem.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$labelSystem.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelSystem.Location = New-Object System.Drawing.Point(25, 64)
	$labelSystem.Name = 'labelSystem'
	$labelSystem.Size = New-Object System.Drawing.Size(64, 15)
	$labelSystem.TabIndex = 8
	$labelSystem.Text = 'System'
	#
	# TextboxSaveName
	#
	$TextboxSaveName.Location = New-Object System.Drawing.Point(135, 118)
	$TextboxSaveName.Name = 'TextboxSaveName'
	$TextboxSaveName.Size = New-Object System.Drawing.Size(121, 20)
	$TextboxSaveName.TabIndex = 7
	#
	# labelName
	#
	$labelName.AutoSize = $True
	$labelName.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$labelName.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelName.Location = New-Object System.Drawing.Point(25, 120)
	$labelName.Name = 'labelName'
	$labelName.Size = New-Object System.Drawing.Size(50, 15)
	$labelName.TabIndex = 6
	$labelName.Text = 'Name'
	#
	# ComboboxSaveType
	#
	$ComboboxSaveType.FormattingEnabled = $True
	$ComboboxSaveType.Location = New-Object System.Drawing.Point(135, 90)
	$ComboboxSaveType.Name = 'ComboboxSaveType'
	$ComboboxSaveType.Size = New-Object System.Drawing.Size(121, 21)
	$ComboboxSaveType.TabIndex = 5
	$ComboboxSaveType.add_SelectedIndexChanged($ComboboxSaveType_SelectedIndexChanged)
	#
	# labelType
	#
	$labelType.AutoSize = $True
	$labelType.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$labelType.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelType.Location = New-Object System.Drawing.Point(25, 94)
	$labelType.Name = 'labelType'
	$labelType.Size = New-Object System.Drawing.Size(43, 15)
	$labelType.TabIndex = 4
	$labelType.Text = 'Type'
	#
	# labelLocation
	#
	$labelLocation.AutoSize = $True
	$labelLocation.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$labelLocation.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelLocation.Location = New-Object System.Drawing.Point(306, 56)
	$labelLocation.Name = 'labelLocation'
	$labelLocation.Size = New-Object System.Drawing.Size(69, 15)
	$labelLocation.TabIndex = 3
	$labelLocation.Text = 'Location'
	#
	# radiobuttonSpaceglobal
	#
	$radiobuttonSpaceglobal.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$radiobuttonSpaceglobal.ForeColor = [System.Drawing.Color]::White 
	$radiobuttonSpaceglobal.Location = New-Object System.Drawing.Point(306, 94)
	$radiobuttonSpaceglobal.Name = 'radiobuttonSpaceglobal'
	$radiobuttonSpaceglobal.Size = New-Object System.Drawing.Size(173, 24)
	$radiobuttonSpaceglobal.TabIndex = 2
	$radiobuttonSpaceglobal.TabStop = $True
	$radiobuttonSpaceglobal.Text = 'Space (global)'
	$radiobuttonSpaceglobal.UseVisualStyleBackColor = $True
	$radiobuttonSpaceglobal.add_CheckedChanged($radiobuttonSpaceglobal_CheckedChanged)
	#
	# radiobuttonPlanetarylocal
	#
	$radiobuttonPlanetarylocal.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$radiobuttonPlanetarylocal.ForeColor = [System.Drawing.Color]::White 
	$radiobuttonPlanetarylocal.Location = New-Object System.Drawing.Point(306, 74)
	$radiobuttonPlanetarylocal.Name = 'radiobuttonPlanetarylocal'
	$radiobuttonPlanetarylocal.Size = New-Object System.Drawing.Size(165, 24)
	$radiobuttonPlanetarylocal.TabIndex = 1
	$radiobuttonPlanetarylocal.TabStop = $True
	$radiobuttonPlanetarylocal.Text = 'Planetary (local)'
	$radiobuttonPlanetarylocal.UseVisualStyleBackColor = $True
	#
	# buttonSave
	#
	$buttonSave.Anchor = 'Bottom, Right'
	$buttonSave.DialogResult = 'OK'
	$buttonSave.Location = New-Object System.Drawing.Point(289, 147)
	$buttonSave.Name = 'buttonSave'
	$buttonSave.Size = New-Object System.Drawing.Size(75, 23)
	$buttonSave.TabIndex = 0
	$buttonSave.Text = '&Save'
	$buttonSave.UseCompatibleTextRendering = $True
	$buttonSave.UseVisualStyleBackColor = $True
	$buttonSave.add_Click($buttonSave_Click)
	$FormSaveLocation.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $FormSaveLocation.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$FormSaveLocation.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$FormSaveLocation.add_FormClosed($Form_Cleanup_FormClosed)

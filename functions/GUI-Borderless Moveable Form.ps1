dd-Type -AssemblyName System.Windows.Forms

# set up some globals for dragging
$global:dragging = $false
$global:mouseDragX = 0
$global:mouseDragY = 0


#Form
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = "None"
$form.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$form.MinimumSize = New-Object System.Drawing.Size(456, 547)
$form.AutoScaleDimensions = New-Object System.Drawing.SizeF(7.0, 15.0)
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$form.ClientSize = New-Object System.Drawing.Size(440, 509)
$form.ShowIcon = $false
$form.StartPosition = "CenterScreen"
$form.TopMost = $true


#lblDrag (this is the object used for dragging the form)
$lblDrag = New-Object System.Windows.Forms.Label
$lblDrag.Name = "lblDrag"
$lblDrag.BackColor = [System.Drawing.Color]::LightYellow
$lblDrag.Location = New-Object System.Drawing.Point(172, 226)
$lblDrag.Size = New-Object System.Drawing.Size(117, 27)
$lblDrag.Anchor = "Top","Right"
$lblDrag.BorderStyle = "FixedSingle"
$lblDrag.Text = "Drag form.."
$lblDrag.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# set the 'dragging' flag and capture the current mouse position
$lblDrag.Add_MouseDown( { $global:dragging = $true
                            $global:mouseDragX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
                            $global:mouseDragY = [System.Windows.Forms.Cursor]::Position.Y -$form.Top
                        })

# move the form while the mouse is depressed (i.e. $global:dragging -eq $true)
$lblDrag.Add_MouseMove( { if($global:dragging) {
                                $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
                                $currentX = [System.Windows.Forms.Cursor]::Position.X
                                $currentY = [System.Windows.Forms.Cursor]::Position.Y
                                [int]$newX = [Math]::Min($currentX - $global:mouseDragX, $screen.Right - $form.Width)
                                [int]$newY = [Math]::Min($currentY - $global:mouseDragY, $screen.Bottom - $form.Height)
                                $form.Location = New-Object System.Drawing.Point($newX, $newY)
                            }})

# stop dragging the form
$lblDrag.Add_MouseUp( { $global:dragging = $false })


# add a button so you will be able to close the form
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Name = "btnClose"
$btnClose.Anchor = "Top","Right"
$btnClose.Location = New-Object System.Drawing.Point(1, 1)
$btnClose.Size = New-Object System.Drawing.Size(117, 27)
$btnClose.Text = "&Close"
$btnClose.UseVisualStyleBackColor = $true
$btnClose.UseMnemonic = $true
$btnClose.DialogResult = [System.Windows.Forms.DialogResult]::OK

# add controls to the form
$form.Controls.Add($btnClose)
$form.Controls.Add($lblDrag)

$form.AcceptButton = $btnClose

# show the form and play around with the dragging label
$form.ShowDialog()

# when done, dispose of the form
$form.Dispose()
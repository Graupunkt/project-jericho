$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(900,600)

$gps = get-process | select Name,ID,Description,@{n='Memory';e={$_.WorkingSet}}
$list = New-Object System.collections.ArrayList
$list.AddRange($gps)

$dataGridView = New-Object System.Windows.Forms.DataGridView -Property @{
    Size=New-Object System.Drawing.Size(800,400)
    ColumnHeadersVisible = $true
    DataSource = $list
}

$form.Controls.Add($dataGridView)
$form.ShowDialog()

$dataGridView.DataSource
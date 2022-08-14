
	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formProjectJericho = New-Object 'System.Windows.Forms.Form'
	$labelCreatedByGraupunktWi = New-Object 'System.Windows.Forms.Label'
	$groupbox24 = New-Object 'System.Windows.Forms.GroupBox'
	$buttonSelect = New-Object 'System.Windows.Forms.Button'
	$textbox241 = New-Object 'System.Windows.Forms.TextBox'
	$labelPArent = New-Object 'System.Windows.Forms.Label'
	$textbox240 = New-Object 'System.Windows.Forms.TextBox'
	$labelSystem = New-Object 'System.Windows.Forms.Label'
	$label83 = New-Object 'System.Windows.Forms.Label'
	$labelSAVED = New-Object 'System.Windows.Forms.Label'
	$label85 = New-Object 'System.Windows.Forms.Label'
	$textbox64 = New-Object 'System.Windows.Forms.TextBox'
	$textbox65 = New-Object 'System.Windows.Forms.TextBox'
	$textbox66 = New-Object 'System.Windows.Forms.TextBox'
	$panel1 = New-Object 'System.Windows.Forms.Panel'
	$label1013061 = New-Object 'System.Windows.Forms.Label'
	$labelSettings = New-Object 'System.Windows.Forms.Label'
	$labelSupportAndUpdatesMer = New-Object 'System.Windows.Forms.Label'
	$linklabelHttpsdiscordggWMh5YC = New-Object 'System.Windows.Forms.LinkLabel'
	$tabcontrol1 = New-Object 'System.Windows.Forms.TabControl'
	$tabpage1 = New-Object 'System.Windows.Forms.TabPage'
	$labelRiseSetHourAngleD = New-Object 'System.Windows.Forms.Label'
	$labelHourAngleDest = New-Object 'System.Windows.Forms.Label'
	$labelRiseSetHourAngleP = New-Object 'System.Windows.Forms.Label'
	$labelHourAnglePlayer = New-Object 'System.Windows.Forms.Label'
	$labelPlayer = New-Object 'System.Windows.Forms.Label'
	$groupbox27 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013051 = New-Object 'System.Windows.Forms.Label'
	$label88 = New-Object 'System.Windows.Forms.Label'
	$labelLocation = New-Object 'System.Windows.Forms.Label'
	$textbox73 = New-Object 'System.Windows.Forms.TextBox'
	$textbox74 = New-Object 'System.Windows.Forms.TextBox'
	$textbox75 = New-Object 'System.Windows.Forms.TextBox'
	$labelDestination = New-Object 'System.Windows.Forms.Label'
	$groupbox25 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013053 = New-Object 'System.Windows.Forms.Label'
	$label1013052 = New-Object 'System.Windows.Forms.Label'
	$labelServer = New-Object 'System.Windows.Forms.Label'
	$textbox67 = New-Object 'System.Windows.Forms.TextBox'
	$textbox68 = New-Object 'System.Windows.Forms.TextBox'
	$textbox69 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox23 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013090 = New-Object 'System.Windows.Forms.Label'
	$label80 = New-Object 'System.Windows.Forms.Label'
	$textbox245 = New-Object 'System.Windows.Forms.TextBox'
	$label72 = New-Object 'System.Windows.Forms.Label'
	$label1013091 = New-Object 'System.Windows.Forms.Label'
	$label81 = New-Object 'System.Windows.Forms.Label'
	$label1013092 = New-Object 'System.Windows.Forms.Label'
	$label82 = New-Object 'System.Windows.Forms.Label'
	$textbox246 = New-Object 'System.Windows.Forms.TextBox'
	$label74 = New-Object 'System.Windows.Forms.Label'
	$textbox59 = New-Object 'System.Windows.Forms.TextBox'
	$label76 = New-Object 'System.Windows.Forms.Label'
	$textbox60 = New-Object 'System.Windows.Forms.TextBox'
	$labelOM = New-Object 'System.Windows.Forms.Label'
	$labelQT = New-Object 'System.Windows.Forms.Label'
	$labelPOI = New-Object 'System.Windows.Forms.Label'
	$textbox61 = New-Object 'System.Windows.Forms.TextBox'
	$textbox62 = New-Object 'System.Windows.Forms.TextBox'
	$textbox63 = New-Object 'System.Windows.Forms.TextBox'
	$textbox58 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox22 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013093 = New-Object 'System.Windows.Forms.Label'
	$label79 = New-Object 'System.Windows.Forms.Label'
	$label1013094 = New-Object 'System.Windows.Forms.Label'
	$label78 = New-Object 'System.Windows.Forms.Label'
	$label1013095 = New-Object 'System.Windows.Forms.Label'
	$textbox247 = New-Object 'System.Windows.Forms.TextBox'
	$label70 = New-Object 'System.Windows.Forms.Label'
	$textbox248 = New-Object 'System.Windows.Forms.TextBox'
	$textbox57 = New-Object 'System.Windows.Forms.TextBox'
	$label68 = New-Object 'System.Windows.Forms.Label'
	$textbox56 = New-Object 'System.Windows.Forms.TextBox'
	$label69 = New-Object 'System.Windows.Forms.Label'
	$labelKm = New-Object 'System.Windows.Forms.Label'
	$textbox55 = New-Object 'System.Windows.Forms.TextBox'
	$labelOC = New-Object 'System.Windows.Forms.Label'
	$label65 = New-Object 'System.Windows.Forms.Label'
	$label66 = New-Object 'System.Windows.Forms.Label'
	$textbox21 = New-Object 'System.Windows.Forms.TextBox'
	$textbox20 = New-Object 'System.Windows.Forms.TextBox'
	$textbox19 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox21 = New-Object 'System.Windows.Forms.GroupBox'
	$textbox42 = New-Object 'System.Windows.Forms.TextBox'
	$label57 = New-Object 'System.Windows.Forms.Label'
	$textbox43 = New-Object 'System.Windows.Forms.TextBox'
	$label58 = New-Object 'System.Windows.Forms.Label'
	$labelCondition = New-Object 'System.Windows.Forms.Label'
	$textbox44 = New-Object 'System.Windows.Forms.TextBox'
	$label59 = New-Object 'System.Windows.Forms.Label'
	$textbox45 = New-Object 'System.Windows.Forms.TextBox'
	$textbox54 = New-Object 'System.Windows.Forms.TextBox'
	$label60 = New-Object 'System.Windows.Forms.Label'
	$label61 = New-Object 'System.Windows.Forms.Label'
	$label62 = New-Object 'System.Windows.Forms.Label'
	$label63 = New-Object 'System.Windows.Forms.Label'
	$groupbox20 = New-Object 'System.Windows.Forms.GroupBox'
	$labelMin = New-Object 'System.Windows.Forms.Label'
	$label56 = New-Object 'System.Windows.Forms.Label'
	$labelDestDayCondition = New-Object 'System.Windows.Forms.Label'
	$label54 = New-Object 'System.Windows.Forms.Label'
	$textbox27 = New-Object 'System.Windows.Forms.TextBox'
	$labelIn = New-Object 'System.Windows.Forms.Label'
	$labelPlanet = New-Object 'System.Windows.Forms.Label'
	$label52 = New-Object 'System.Windows.Forms.Label'
	$label53 = New-Object 'System.Windows.Forms.Label'
	$textbox38 = New-Object 'System.Windows.Forms.TextBox'
	$textbox39 = New-Object 'System.Windows.Forms.TextBox'
	$textbox40 = New-Object 'System.Windows.Forms.TextBox'
	$textbox41 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox19 = New-Object 'System.Windows.Forms.GroupBox'
	$label45 = New-Object 'System.Windows.Forms.Label'
	$textbox16 = New-Object 'System.Windows.Forms.TextBox'
	$textbox17 = New-Object 'System.Windows.Forms.TextBox'
	$textbox18 = New-Object 'System.Windows.Forms.TextBox'
	$label46 = New-Object 'System.Windows.Forms.Label'
	$label47 = New-Object 'System.Windows.Forms.Label'
	$label48 = New-Object 'System.Windows.Forms.Label'
	$label49 = New-Object 'System.Windows.Forms.Label'
	$label50 = New-Object 'System.Windows.Forms.Label'
	$groupbox18 = New-Object 'System.Windows.Forms.GroupBox'
	$labelZ = New-Object 'System.Windows.Forms.Label'
	$labelY = New-Object 'System.Windows.Forms.Label'
	$labelX = New-Object 'System.Windows.Forms.Label'
	$textbox12 = New-Object 'System.Windows.Forms.TextBox'
	$textbox10 = New-Object 'System.Windows.Forms.TextBox'
	$textbox11 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox17 = New-Object 'System.Windows.Forms.GroupBox'
	$labelM = New-Object 'System.Windows.Forms.Label'
	$label2 = New-Object 'System.Windows.Forms.Label'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$labelHeight = New-Object 'System.Windows.Forms.Label'
	$label5 = New-Object 'System.Windows.Forms.Label'
	$label4 = New-Object 'System.Windows.Forms.Label'
	$textbox51 = New-Object 'System.Windows.Forms.TextBox'
	$textbox52 = New-Object 'System.Windows.Forms.TextBox'
	$textbox53 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox16 = New-Object 'System.Windows.Forms.GroupBox'
	$label42 = New-Object 'System.Windows.Forms.Label'
	$textbox6 = New-Object 'System.Windows.Forms.TextBox'
	$label43 = New-Object 'System.Windows.Forms.Label'
	$textbox5 = New-Object 'System.Windows.Forms.TextBox'
	$label44 = New-Object 'System.Windows.Forms.Label'
	$textbox4 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox15 = New-Object 'System.Windows.Forms.GroupBox'
	$label39 = New-Object 'System.Windows.Forms.Label'
	$label40 = New-Object 'System.Windows.Forms.Label'
	$label41 = New-Object 'System.Windows.Forms.Label'
	$textbox23 = New-Object 'System.Windows.Forms.TextBox'
	$textbox7 = New-Object 'System.Windows.Forms.TextBox'
	$textbox8 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	$label36 = New-Object 'System.Windows.Forms.Label'
	$label37 = New-Object 'System.Windows.Forms.Label'
	$label38 = New-Object 'System.Windows.Forms.Label'
	$textbox2 = New-Object 'System.Windows.Forms.TextBox'
	$textbox1 = New-Object 'System.Windows.Forms.TextBox'
	$textbox3 = New-Object 'System.Windows.Forms.TextBox'
	$picturebox7 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage2 = New-Object 'System.Windows.Forms.TabPage'
	$groupbox26 = New-Object 'System.Windows.Forms.GroupBox'
	$labelTotal = New-Object 'System.Windows.Forms.Label'
	$textbox237 = New-Object 'System.Windows.Forms.TextBox'
	$labelOCunt = New-Object 'System.Windows.Forms.Label'
	$labelSInce = New-Object 'System.Windows.Forms.Label'
	$labelLAST = New-Object 'System.Windows.Forms.Label'
	$textbox70 = New-Object 'System.Windows.Forms.TextBox'
	$textbox71 = New-Object 'System.Windows.Forms.TextBox'
	$textbox72 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox42 = New-Object 'System.Windows.Forms.GroupBox'
	$textbox165 = New-Object 'System.Windows.Forms.TextBox'
	$textbox166 = New-Object 'System.Windows.Forms.TextBox'
	$textbox167 = New-Object 'System.Windows.Forms.TextBox'
	$label1013020 = New-Object 'System.Windows.Forms.Label'
	$label1013021 = New-Object 'System.Windows.Forms.Label'
	$label1013022 = New-Object 'System.Windows.Forms.Label'
	$textbox168 = New-Object 'System.Windows.Forms.TextBox'
	$textbox169 = New-Object 'System.Windows.Forms.TextBox'
	$textbox170 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox41 = New-Object 'System.Windows.Forms.GroupBox'
	$textbox159 = New-Object 'System.Windows.Forms.TextBox'
	$textbox193 = New-Object 'System.Windows.Forms.TextBox'
	$textbox160 = New-Object 'System.Windows.Forms.TextBox'
	$textbox194 = New-Object 'System.Windows.Forms.TextBox'
	$textbox161 = New-Object 'System.Windows.Forms.TextBox'
	$textbox191 = New-Object 'System.Windows.Forms.TextBox'
	$label1013017 = New-Object 'System.Windows.Forms.Label'
	$label1013018 = New-Object 'System.Windows.Forms.Label'
	$label1013019 = New-Object 'System.Windows.Forms.Label'
	$textbox190 = New-Object 'System.Windows.Forms.TextBox'
	$textbox192 = New-Object 'System.Windows.Forms.TextBox'
	$textbox162 = New-Object 'System.Windows.Forms.TextBox'
	$textbox163 = New-Object 'System.Windows.Forms.TextBox'
	$textbox164 = New-Object 'System.Windows.Forms.TextBox'
	$textbox189 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox32 = New-Object 'System.Windows.Forms.GroupBox'
	$textbox216 = New-Object 'System.Windows.Forms.TextBox'
	$textbox215 = New-Object 'System.Windows.Forms.TextBox'
	$textbox214 = New-Object 'System.Windows.Forms.TextBox'
	$textbox180 = New-Object 'System.Windows.Forms.TextBox'
	$textbox181 = New-Object 'System.Windows.Forms.TextBox'
	$textbox182 = New-Object 'System.Windows.Forms.TextBox'
	$textbox177 = New-Object 'System.Windows.Forms.TextBox'
	$textbox178 = New-Object 'System.Windows.Forms.TextBox'
	$textbox179 = New-Object 'System.Windows.Forms.TextBox'
	$textbox174 = New-Object 'System.Windows.Forms.TextBox'
	$textbox175 = New-Object 'System.Windows.Forms.TextBox'
	$textbox176 = New-Object 'System.Windows.Forms.TextBox'
	$textbox173 = New-Object 'System.Windows.Forms.TextBox'
	$textbox172 = New-Object 'System.Windows.Forms.TextBox'
	$textbox171 = New-Object 'System.Windows.Forms.TextBox'
	$labelFinalDISTANCE = New-Object 'System.Windows.Forms.Label'
	$labelCurrentDistance = New-Object 'System.Windows.Forms.Label'
	$labelQuantumMarker = New-Object 'System.Windows.Forms.Label'
	$groupbox31 = New-Object 'System.Windows.Forms.GroupBox'
	$textbox89 = New-Object 'System.Windows.Forms.TextBox'
	$textbox88 = New-Object 'System.Windows.Forms.TextBox'
	$textbox87 = New-Object 'System.Windows.Forms.TextBox'
	$labelSeconds = New-Object 'System.Windows.Forms.Label'
	$textbox86 = New-Object 'System.Windows.Forms.TextBox'
	$labelMinutes = New-Object 'System.Windows.Forms.Label'
	$labelHours = New-Object 'System.Windows.Forms.Label'
	$labelDays = New-Object 'System.Windows.Forms.Label'
	$groupbox40 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013050 = New-Object 'System.Windows.Forms.Label'
	$label1013049 = New-Object 'System.Windows.Forms.Label'
	$label1013048 = New-Object 'System.Windows.Forms.Label'
	$label1013047 = New-Object 'System.Windows.Forms.Label'
	$label1013046 = New-Object 'System.Windows.Forms.Label'
	$label1013045 = New-Object 'System.Windows.Forms.Label'
	$textbox147 = New-Object 'System.Windows.Forms.TextBox'
	$textbox148 = New-Object 'System.Windows.Forms.TextBox'
	$textbox149 = New-Object 'System.Windows.Forms.TextBox'
	$textbox150 = New-Object 'System.Windows.Forms.TextBox'
	$textbox151 = New-Object 'System.Windows.Forms.TextBox'
	$textbox152 = New-Object 'System.Windows.Forms.TextBox'
	$textbox153 = New-Object 'System.Windows.Forms.TextBox'
	$textbox154 = New-Object 'System.Windows.Forms.TextBox'
	$textbox155 = New-Object 'System.Windows.Forms.TextBox'
	$textbox156 = New-Object 'System.Windows.Forms.TextBox'
	$textbox157 = New-Object 'System.Windows.Forms.TextBox'
	$textbox158 = New-Object 'System.Windows.Forms.TextBox'
	$groupbox30 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013088 = New-Object 'System.Windows.Forms.Label'
	$label1013089 = New-Object 'System.Windows.Forms.Label'
	$textbox243 = New-Object 'System.Windows.Forms.TextBox'
	$labelForecast = New-Object 'System.Windows.Forms.Label'
	$textbox244 = New-Object 'System.Windows.Forms.TextBox'
	$label1013034 = New-Object 'System.Windows.Forms.Label'
	$label1013033 = New-Object 'System.Windows.Forms.Label'
	$label1013032 = New-Object 'System.Windows.Forms.Label'
	$label1013031 = New-Object 'System.Windows.Forms.Label'
	$textbox184 = New-Object 'System.Windows.Forms.TextBox'
	$textbox185 = New-Object 'System.Windows.Forms.TextBox'
	$textbox183 = New-Object 'System.Windows.Forms.TextBox'
	$labelDelta = New-Object 'System.Windows.Forms.Label'
	$textbox84 = New-Object 'System.Windows.Forms.TextBox'
	$labelCurrent = New-Object 'System.Windows.Forms.Label'
	$groupbox33 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013068 = New-Object 'System.Windows.Forms.Label'
	$label1013067 = New-Object 'System.Windows.Forms.Label'
	$label1013066 = New-Object 'System.Windows.Forms.Label'
	$label1013065 = New-Object 'System.Windows.Forms.Label'
	$label1013064 = New-Object 'System.Windows.Forms.Label'
	$label1013063 = New-Object 'System.Windows.Forms.Label'
	$textbox208 = New-Object 'System.Windows.Forms.TextBox'
	$textbox209 = New-Object 'System.Windows.Forms.TextBox'
	$textbox210 = New-Object 'System.Windows.Forms.TextBox'
	$textbox211 = New-Object 'System.Windows.Forms.TextBox'
	$textbox212 = New-Object 'System.Windows.Forms.TextBox'
	$textbox213 = New-Object 'System.Windows.Forms.TextBox'
	$textbox207 = New-Object 'System.Windows.Forms.TextBox'
	$textbox206 = New-Object 'System.Windows.Forms.TextBox'
	$textbox204 = New-Object 'System.Windows.Forms.TextBox'
	$textbox203 = New-Object 'System.Windows.Forms.TextBox'
	$textbox202 = New-Object 'System.Windows.Forms.TextBox'
	$textbox201 = New-Object 'System.Windows.Forms.TextBox'
	$textbox200 = New-Object 'System.Windows.Forms.TextBox'
	$textbox199 = New-Object 'System.Windows.Forms.TextBox'
	$textbox198 = New-Object 'System.Windows.Forms.TextBox'
	$textbox197 = New-Object 'System.Windows.Forms.TextBox'
	$textbox196 = New-Object 'System.Windows.Forms.TextBox'
	$textbox195 = New-Object 'System.Windows.Forms.TextBox'
	$label6 = New-Object 'System.Windows.Forms.Label'
	$label1013058 = New-Object 'System.Windows.Forms.Label'
	$label1013057 = New-Object 'System.Windows.Forms.Label'
	$label3 = New-Object 'System.Windows.Forms.Label'
	$label1013055 = New-Object 'System.Windows.Forms.Label'
	$label1013054 = New-Object 'System.Windows.Forms.Label'
	$groupbox29 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013060 = New-Object 'System.Windows.Forms.Label'
	$textbox219 = New-Object 'System.Windows.Forms.TextBox'
	$label1013059 = New-Object 'System.Windows.Forms.Label'
	$textbox218 = New-Object 'System.Windows.Forms.TextBox'
	$labelCOmpass = New-Object 'System.Windows.Forms.Label'
	$label1012958 = New-Object 'System.Windows.Forms.Label'
	$label1012957 = New-Object 'System.Windows.Forms.Label'
	$label1012956 = New-Object 'System.Windows.Forms.Label'
	$textbox80 = New-Object 'System.Windows.Forms.TextBox'
	$textbox81 = New-Object 'System.Windows.Forms.TextBox'
	$textbox82 = New-Object 'System.Windows.Forms.TextBox'
	$labelRPEv = New-Object 'System.Windows.Forms.Label'
	$labelRePv = New-Object 'System.Windows.Forms.Label'
	$labelPrev = New-Object 'System.Windows.Forms.Label'
	$textbox79 = New-Object 'System.Windows.Forms.TextBox'
	$textbox78 = New-Object 'System.Windows.Forms.TextBox'
	$textbox77 = New-Object 'System.Windows.Forms.TextBox'
	$labelOnGround = New-Object 'System.Windows.Forms.Label'
	$labelInOrbit = New-Object 'System.Windows.Forms.Label'
	$labelInSpace = New-Object 'System.Windows.Forms.Label'
	$picturebox8 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage3 = New-Object 'System.Windows.Forms.TabPage'
	$groupbox46 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013085 = New-Object 'System.Windows.Forms.Label'
	$textbox235 = New-Object 'System.Windows.Forms.TextBox'
	$label1013086 = New-Object 'System.Windows.Forms.Label'
	$textbox236 = New-Object 'System.Windows.Forms.TextBox'
	$label1013087 = New-Object 'System.Windows.Forms.Label'
	$label1013084 = New-Object 'System.Windows.Forms.Label'
	$textbox234 = New-Object 'System.Windows.Forms.TextBox'
	$labelSec = New-Object 'System.Windows.Forms.Label'
	$label1013083 = New-Object 'System.Windows.Forms.Label'
	$textbox233 = New-Object 'System.Windows.Forms.TextBox'
	$textbox230 = New-Object 'System.Windows.Forms.TextBox'
	$labelExpected = New-Object 'System.Windows.Forms.Label'
	$labelEta = New-Object 'System.Windows.Forms.Label'
	$labelG = New-Object 'System.Windows.Forms.Label'
	$labelMS = New-Object 'System.Windows.Forms.Label'
	$textbox231 = New-Object 'System.Windows.Forms.TextBox'
	$textbox232 = New-Object 'System.Windows.Forms.TextBox'
	$labelCurrentSpeed = New-Object 'System.Windows.Forms.Label'
	$labelGRAVITY = New-Object 'System.Windows.Forms.Label'
	$groupbox45 = New-Object 'System.Windows.Forms.GroupBox'
	$label1013082 = New-Object 'System.Windows.Forms.Label'
	$textbox228 = New-Object 'System.Windows.Forms.TextBox'
	$label1013081 = New-Object 'System.Windows.Forms.Label'
	$textbox227 = New-Object 'System.Windows.Forms.TextBox'
	$labelBOmbMAXTIME = New-Object 'System.Windows.Forms.Label'
	$labelBombMAXDISTANCE = New-Object 'System.Windows.Forms.Label'
	$label1013077 = New-Object 'System.Windows.Forms.Label'
	$label1013078 = New-Object 'System.Windows.Forms.Label'
	$textbox224 = New-Object 'System.Windows.Forms.TextBox'
	$textbox226 = New-Object 'System.Windows.Forms.TextBox'
	$label1013079 = New-Object 'System.Windows.Forms.Label'
	$label1013080 = New-Object 'System.Windows.Forms.Label'
	$groupbox44 = New-Object 'System.Windows.Forms.GroupBox'
	$labelWEST = New-Object 'System.Windows.Forms.Label'
	$labelEast = New-Object 'System.Windows.Forms.Label'
	$labelSOUTH = New-Object 'System.Windows.Forms.Label'
	$labelNORTH = New-Object 'System.Windows.Forms.Label'
	$label1013069 = New-Object 'System.Windows.Forms.Label'
	$label1013070 = New-Object 'System.Windows.Forms.Label'
	$label1013071 = New-Object 'System.Windows.Forms.Label'
	$label1013072 = New-Object 'System.Windows.Forms.Label'
	$textbox220 = New-Object 'System.Windows.Forms.TextBox'
	$textbox221 = New-Object 'System.Windows.Forms.TextBox'
	$textbox222 = New-Object 'System.Windows.Forms.TextBox'
	$labelLongitudinal = New-Object 'System.Windows.Forms.Label'
	$textbox223 = New-Object 'System.Windows.Forms.TextBox'
	$labelLATERAL = New-Object 'System.Windows.Forms.Label'
	$picturebox6 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage4 = New-Object 'System.Windows.Forms.TabPage'
	$picturebox5 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage6 = New-Object 'System.Windows.Forms.TabPage'
	$picturebox4 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage7 = New-Object 'System.Windows.Forms.TabPage'
	$picturebox3 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage10 = New-Object 'System.Windows.Forms.TabPage'
	$datagridview2 = New-Object 'System.Windows.Forms.DataGridView'
	$datagridview1 = New-Object 'System.Windows.Forms.DataGridView'
	$tabpage8 = New-Object 'System.Windows.Forms.TabPage'
	$buttonDebugMode = New-Object 'System.Windows.Forms.Button'
	$textbox242 = New-Object 'System.Windows.Forms.TextBox'
	$labelLimits = New-Object 'System.Windows.Forms.Label'
	$labelScript = New-Object 'System.Windows.Forms.Label'
	$labelFunctions = New-Object 'System.Windows.Forms.Label'
	$labelDatapointsOnPlanetMa = New-Object 'System.Windows.Forms.Label'
	$labelDatapointsOnSystemMa = New-Object 'System.Windows.Forms.Label'
	$textbox239 = New-Object 'System.Windows.Forms.TextBox'
	$textbox238 = New-Object 'System.Windows.Forms.TextBox'
	$buttonAutoRunToggle = New-Object 'System.Windows.Forms.Button'
	$buttonToggleIngameOverlay = New-Object 'System.Windows.Forms.Button'
	$buttonClearStarCitizenCach = New-Object 'System.Windows.Forms.Button'
	$buttonAntiLogoffScript = New-Object 'System.Windows.Forms.Button'
	$buttonShowLocationHotKey = New-Object 'System.Windows.Forms.Button'
	$picturebox9 = New-Object 'System.Windows.Forms.PictureBox'
	$tabpage5 = New-Object 'System.Windows.Forms.TabPage'
	$richtextbox2 = New-Object 'System.Windows.Forms.RichTextBox'
	$tabpage9 = New-Object 'System.Windows.Forms.TabPage'
	$richtextbox1 = New-Object 'System.Windows.Forms.RichTextBox'
	$picturebox10 = New-Object 'System.Windows.Forms.PictureBox'
	$picturebox2 = New-Object 'System.Windows.Forms.PictureBox'
	$tooltip = New-Object 'System.Windows.Forms.ToolTip'
	$contextmenustrip1 = New-Object 'System.Windows.Forms.ContextMenuStrip'
	$labelLocal = New-Object 'System.Windows.Forms.Label'
	$labelUTC = New-Object 'System.Windows.Forms.Label'
	$labelSession = New-Object 'System.Windows.Forms.Label'
	$labelOm1 = New-Object 'System.Windows.Forms.Label'
	$labelOm2 = New-Object 'System.Windows.Forms.Label'
	$labelOM3 = New-Object 'System.Windows.Forms.Label'
	$labelOm4 = New-Object 'System.Windows.Forms.Label'
	$labelOm5 = New-Object 'System.Windows.Forms.Label'
	$labelOm6 = New-Object 'System.Windows.Forms.Label'
	$Version = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Releases = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Durations = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Resets = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Contents = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Major = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$i = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$l = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Build = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Evocati = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Wave1 = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$PTUPublic = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Live = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Time = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Day = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$EvocatiPhase = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Wave1Phase = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$PTUPublicPhase = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Release = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Resets2 = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Ships = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$Features = New-Object 'System.Windows.Forms.DataGridViewTextBoxColumn'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formProjectJericho_Load={
		#TODO: Initialize Form Controls here
		Write-Host "$($OrangeForeColor)- Pre Loading Main Application"
	}
	
	#region Control Helper Functions
	<#
		.SYNOPSIS
			Sets the emulation of the WebBrowser control for the application.
		
		.DESCRIPTION
			Sets the emulation of the WebBrowser control for the application using the installed version of IE.
			This improves the WebBrowser control compatibility with newer html features.
		
		.PARAMETER ExecutableName
			The name of the executable E.g. PowerShellStudio.exe.
			Default Value: The running executable name.
		
		.EXAMPLE
			PS C:\> Set-WebBrowserEmulation
	
		.EXAMPLE
			PS C:\> Set-WebBrowserEmulation PowerShell.exe
	#>
	function Set-WebBrowserEmulation
	{
		param
		(
			[ValidateNotNullOrEmpty()]
			[string]
			$ExecutableName = [System.IO.Path]::GetFileName([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
		)
		
		#region Get IE Version
		$valueNames = 'svcVersion', 'svcUpdateVersion', 'Version', 'W2kVersion'
		
		$version = 0;
		for ($i = 0; $i -lt $valueNames.Length; $i++)
		{
			$objVal = [Microsoft.Win32.Registry]::GetValue('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer', $valueNames[$i], '0')
			$strVal = [System.Convert]::ToString($objVal)
			if ($strVal)
			{
				$iPos = $strVal.IndexOf('.')
				if ($iPos -gt 0)
				{
					$strVal = $strVal.Substring(0, $iPos)
				}
				
				$res = 0;
				if ([int]::TryParse($strVal, [ref]$res))
				{
					$version = [Math]::Max($version, $res)
				}
			}
		}
		
		if ($version -lt 7)
		{
			$version = 7000
		}
		else
		{
			$version = $version * 1000
		}
		#endregion
		
		[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION', $ExecutableName, $version)
	}
	
	
	
	function Update-Chart
	{
	<#
	    .SYNOPSIS
	        This functions helps you plot points on a chart.
	    
	    .DESCRIPTION
	        Use the function to plot points on a chart or add more charts to a chart control.
	    
	    .PARAMETER ChartControl
	        The Chart Control you when to add points to.
	    
	    .PARAMETER XPoints
	        Set the X Axis Points. These can be strings or numerical values.
	    
	    .PARAMETER YPoints
	        Set the Y Axis Points. These can be strings or numerical values.
	    
	    .PARAMETER XTitle
	        Set the Title for the X Axis.
	    
	    .PARAMETER YTitle
	        Set the Title for the Y Axis.
	    
	    .PARAMETER Title
	        Set the Title for the chart.
	    
	    .PARAMETER ChartType
	        Set the Style of the chart. See System.Windows.Forms.DataVisualization.Charting.SeriesChartType Enum.
	    
	    .PARAMETER SeriesIndex
	        Set the settings of a particular Series and corresponding ChartArea.
	    
	    .PARAMETER TitleIndex
	        Set the settings of a particular Title.
	    
	    .PARAMETER SeriesName
	        Set the settings of a particular Series using its name and corresponding ChartArea.
	        The Series will be created if not found.
	        If SeriesIndex is set, it will replace the Series' name if the Series does not exist.
	    
	    .PARAMETER Enable3D
	        The chart will be rendered in 3D.
	    
	    .PARAMETER Disable3D
	        The chart will be rendered in 2D.
	    
	    .PARAMETER AppendNew
	        When this switch is used, a new ChartArea is added to Chart Control.
	    
	    .NOTES
	        Additional information about the function.
	    
	    .LINK
	        http://www.sapien.com/blog/2011/05/05/primalforms-2011-designing-charts-for-powershell/
	#>
		
		param
		(
			[Parameter(Mandatory = $true, Position = 1)]
			[ValidateNotNull()]
			[System.Windows.Forms.DataVisualization.Charting.Chart]$ChartControl,
			[Parameter(Mandatory = $true, Position = 2)]
			[ValidateNotNull()]
			$XPoints,
			[Parameter(Mandatory = $true, Position = 3)]
			[ValidateNotNull()]
			$YPoints,
			[Parameter(Mandatory = $false, Position = 4)]
			[string]$XTitle,
			[Parameter(Mandatory = $false, Position = 5)]
			[string]$YTitle,
			[Parameter(Mandatory = $false, Position = 6)]
			[string]$Title,
			[Parameter(Mandatory = $false, Position = 7)]
			[System.Windows.Forms.DataVisualization.Charting.SeriesChartType]$ChartType,
			[Parameter(Mandatory = $false, Position = 8)]
			[int]$SeriesIndex = -1,
			[Parameter(Mandatory = $false, Position = 9)]
			[int]$TitleIndex = 0,
			[Parameter(Mandatory = $false)]
			[string]$SeriesName = $null,
			[switch]$Enable3D,
			[switch]$Disable3D,
			[switch]$AppendNew
		)
		
		$ChartAreaIndex = 0
		if ($AppendNew)
		{
			$name = "ChartArea " + ($ChartControl.ChartAreas.Count + 1).ToString();
			$ChartArea = $ChartControl.ChartAreas.Add($name)
			$ChartAreaIndex = $ChartControl.ChartAreas.Count - 1
			
			$name = "Series " + ($ChartControl.Series.Count + 1).ToString();
			$Series = $ChartControl.Series.Add($name)
			$SeriesIndex = $ChartControl.Series.Count - 1
			
			$Series.ChartArea = $ChartArea.Name
		}
		else
		{
			if ($ChartControl.ChartAreas.Count -eq 0)
			{
				$name = "ChartArea " + ($ChartControl.ChartAreas.Count + 1).ToString();
				[void]$ChartControl.ChartAreas.Add($name)
				$ChartAreaIndex = $ChartControl.ChartAreas.Count - 1
			}
			
			if ($ChartControl.Series.Count -eq 0)
			{
				if (-not $SeriesName)
				{
					$SeriesName = "Series " + ($ChartControl.Series.Count + 1).ToString();
				}
				
				$Series = $ChartControl.Series.Add($SeriesName)
				$SeriesIndex = $ChartControl.Series.Count - 1
				$Series.ChartArea = $ChartControl.ChartAreas[$ChartAreaIndex].Name
			}
			elseif ($SeriesName)
			{
				$Series = $ChartControl.Series.FindByName($SeriesName)
				
				if ($null -eq $Series)
				{
					if (($SeriesIndex -gt -1) -and ($SeriesIndex -lt $ChartControl.Series.Count))
					{
						$Series = $ChartControl.Series[$SeriesIndex]
						$Series.Name = $SeriesName
					}
					else
					{
						$Series = $ChartControl.Series.Add($SeriesName)
						$SeriesIndex = $ChartControl.Series.Count - 1
					}
					
					$Series.ChartArea = $ChartControl.ChartAreas[$ChartAreaIndex].Name
				}
				else
				{
					$SeriesIndex = $ChartControl.Series.IndexOf($Series)
					$ChartAreaIndex = $ChartControl.ChartAreas.IndexOf($Series.ChartArea)
				}
			}
		}
		
		if (($SeriesIndex -lt 0) -or ($SeriesIndex -ge $ChartControl.Series.Count))
		{
			$SeriesIndex = 0
		}
		
		$Series = $ChartControl.Series[$SeriesIndex]
		$Series.Points.Clear()
		$ChartArea = $ChartControl.ChartAreas[$Series.ChartArea]
		
		if ($Enable3D)
		{
			$ChartArea.Area3DStyle.Enable3D = $true
		}
		elseif ($Disable3D)
		{
			$ChartArea.Area3DStyle.Enable3D = $false
		}
		
		if ($Title)
		{
			if ($ChartControl.Titles.Count -eq 0)
			{
				#$name = "Title " + ($ChartControl.Titles.Count + 1).ToString();
				$TitleObj = $ChartControl.Titles.Add($Title)
				$TitleIndex = $ChartControl.Titles.Count - 1
				$TitleObj.DockedToChartArea = $ChartArea.Name
				$TitleObj.IsDockedInsideChartArea = $false
			}
			
			$ChartControl.Titles[$TitleIndex].Text = $Title
		}
		
		if ($ChartType)
		{
			$Series.ChartType = $ChartType
		}
		
		if ($XTitle)
		{
			$ChartArea.AxisX.Title = $XTitle
		}
		
		if ($YTitle)
		{
			$ChartArea.AxisY.Title = $YTitle
		}
		
		if ($XPoints -isnot [Array] -or $XPoints -isnot [System.Collections.IEnumerable])
		{
			$array = New-Object System.Collections.ArrayList
			$array.Add($XPoints)
			$XPoints = $array
		}
		
		if ($YPoints -isnot [Array] -or $YPoints -isnot [System.Collections.IEnumerable])
		{
			$array = New-Object System.Collections.ArrayList
			$array.Add($YPoints)
			$YPoints = $array
		}
		
		$Series.Points.DataBindXY($XPoints, $YPoints)
	}
	
	
	
	function Clear-Chart
	{
	<#
		.SYNOPSIS
			This function clears the contents of the chart.
	
		.DESCRIPTION
			Use the function to remove contents from the chart control.
	
		.PARAMETER  ChartControl
			The Chart Control to clear.
	
		.PARAMETER  LeaveSingleChart
			Leaves the first chart and removes all others from the control.
		
		.LINK
			http://www.sapien.com/blog/2011/05/05/primalforms-2011-designing-charts-for-powershell/
	#>
		Param (	
		[ValidateNotNull()]
		[Parameter(Position=1,Mandatory=$true)]
	  	[System.Windows.Forms.DataVisualization.Charting.Chart]$ChartControl
		,
		[Parameter(Position=2, Mandatory=$false)]
		[Switch]$LeaveSingleChart
		)
		
		$count = 0	
		if($LeaveSingleChart)
		{
			$count = 1
		}
		
		while($ChartControl.Series.Count -gt $count)
		{
			$ChartControl.Series.RemoveAt($ChartControl.Series.Count - 1)
		}
		
		while($ChartControl.ChartAreas.Count -gt $count)
		{
			$ChartControl.ChartAreas.RemoveAt($ChartControl.ChartAreas.Count - 1)
		}
		
		while($ChartControl.Titles.Count -gt $count)
		{
			$ChartControl.Titles.RemoveAt($ChartControl.Titles.Count - 1)
		}
		
		if($ChartControl.Series.Count -gt 0)
		{
			$ChartControl.Series[0].Points.Clear()
		}
	}
	
	
	
	function Update-ListBox
	{
	<#
		.SYNOPSIS
			This functions helps you load items into a ListBox or CheckedListBox.
		
		.DESCRIPTION
			Use this function to dynamically load items into the ListBox control.
		
		.PARAMETER ListBox
			The ListBox control you want to add items to.
		
		.PARAMETER Items
			The object or objects you wish to load into the ListBox's Items collection.
		
		.PARAMETER DisplayMember
			Indicates the property to display for the items in this control.
			
		.PARAMETER ValueMember
			Indicates the property to use for the value of the control.
		
		.PARAMETER Append
			Adds the item(s) to the ListBox without clearing the Items collection.
		
		.EXAMPLE
			Update-ListBox $ListBox1 "Red", "White", "Blue"
		
		.EXAMPLE
			Update-ListBox $listBox1 "Red" -Append
			Update-ListBox $listBox1 "White" -Append
			Update-ListBox $listBox1 "Blue" -Append
		
		.EXAMPLE
			Update-ListBox $listBox1 (Get-Process) "ProcessName"
		
		.NOTES
			Additional information about the function.
	#>
		
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			[System.Windows.Forms.ListBox]
			$ListBox,
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
			$ListBox.Items.Clear()
		}
		
		if ($Items -is [System.Windows.Forms.ListBox+ObjectCollection] -or $Items -is [System.Collections.ICollection])
		{
			$ListBox.Items.AddRange($Items)
		}
		elseif ($Items -is [System.Collections.IEnumerable])
		{
			$ListBox.BeginUpdate()
			foreach ($obj in $Items)
			{
				$ListBox.Items.Add($obj)
			}
			$ListBox.EndUpdate()
		}
		else
		{
			$ListBox.Items.Add($Items)
		}
		
		if ($DisplayMember)
		{
			$ListBox.DisplayMember = $DisplayMember
		}
		if ($ValueMember)
		{
			$ListBox.ValueMember = $ValueMember
		}
	}
	
	
	
	function Update-DataGridView
	{
		<#
		.SYNOPSIS
			This functions helps you load items into a DataGridView.
	
		.DESCRIPTION
			Use this function to dynamically load items into the DataGridView control.
	
		.PARAMETER  DataGridView
			The DataGridView control you want to add items to.
	
		.PARAMETER  Item
			The object or objects you wish to load into the DataGridView's items collection.
		
		.PARAMETER  DataMember
			Sets the name of the list or table in the data source for which the DataGridView is displaying data.
	
		.PARAMETER AutoSizeColumns
		    Resizes DataGridView control's columns after loading the items.
		#>
		Param (
			[ValidateNotNull()]
			[Parameter(Mandatory=$true)]
			[System.Windows.Forms.DataGridView]$DataGridView,
			[ValidateNotNull()]
			[Parameter(Mandatory=$true)]
			$Item,
		    [Parameter(Mandatory=$false)]
			[string]$DataMember,
			[System.Windows.Forms.DataGridViewAutoSizeColumnsMode]$AutoSizeColumns = 'None'
		)
		$DataGridView.SuspendLayout()
		$DataGridView.DataMember = $DataMember
		
		if ($null -eq $Item)
		{
			$DataGridView.DataSource = $null
		}
		elseif ($Item -is [System.Data.DataSet] -and $Item.Tables.Count -gt 0)
		{
			$DataGridView.DataSource = $Item.Tables[0]
		}
		elseif ($Item -is [System.ComponentModel.IListSource]`
		-or $Item -is [System.ComponentModel.IBindingList] -or $Item -is [System.ComponentModel.IBindingListView] )
		{
			$DataGridView.DataSource = $Item
		}
		else
		{
			$array = New-Object System.Collections.ArrayList
			
			if ($Item -is [System.Collections.IList])
			{
				$array.AddRange($Item)
			}
			else
			{
				$array.Add($Item)
			}
			$DataGridView.DataSource = $array
		}
		
		if ($AutoSizeColumns -ne 'None')
		{
			$DataGridView.AutoResizeColumns($AutoSizeColumns)
		}
		
		$DataGridView.ResumeLayout()
	}
	
	
	
	function ConvertTo-DataTable
	{
		<#
			.SYNOPSIS
				Converts objects into a DataTable.
		
			.DESCRIPTION
				Converts objects into a DataTable, which are used for DataBinding.
		
			.PARAMETER  InputObject
				The input to convert into a DataTable.
		
			.PARAMETER  Table
				The DataTable you wish to load the input into.
		
			.PARAMETER RetainColumns
				This switch tells the function to keep the DataTable's existing columns.
			
			.PARAMETER FilterCIMProperties
				This switch removes CIM properties that start with an underline.
		
			.EXAMPLE
				$DataTable = ConvertTo-DataTable -InputObject (Get-Process)
		#>
		[OutputType([System.Data.DataTable])]
		param(
		$InputObject, 
		[ValidateNotNull()]
		[System.Data.DataTable]$Table,
		[switch]$RetainColumns,
		[switch]$FilterCIMProperties)
		
		if($null -eq $Table)
		{
			$Table = New-Object System.Data.DataTable
		}
		
		if ($null -eq $InputObject)
		{
			$Table.Clear()
			return @( ,$Table)
		}
		
		if ($InputObject -is [System.Data.DataTable])
		{
			$Table = $InputObject
		}
		elseif ($InputObject -is [System.Data.DataSet] -and $InputObject.Tables.Count -gt 0)
		{
			$Table = $InputObject.Tables[0]
		}
		else
		{
			if (-not $RetainColumns -or $Table.Columns.Count -eq 0)
			{
				#Clear out the Table Contents
				$Table.Clear()
				
				if ($null -eq $InputObject) { return } #Empty Data
				
				$object = $null
				#find the first non null value
				foreach ($item in $InputObject)
				{
					if ($null -ne $item)
					{
						$object = $item
						break
					}
				}
				
				if ($null -eq $object) { return } #All null then empty
				
				#Get all the properties in order to create the columns
				foreach ($prop in $object.PSObject.Get_Properties())
				{
					if (-not $FilterCIMProperties -or -not $prop.Name.StartsWith('__')) #filter out CIM properties
					{
						#Get the type from the Definition string
						$type = $null
						
						if ($null -ne $prop.Value)
						{
							try { $type = $prop.Value.GetType() }
							catch { Out-Null }
						}
						
						if ($null -ne $type) # -and [System.Type]::GetTypeCode($type) -ne 'Object')
						{
							[void]$table.Columns.Add($prop.Name, $type)
						}
						else #Type info not found
						{
							[void]$table.Columns.Add($prop.Name)
						}
					}
				}
				
				if ($object -is [System.Data.DataRow])
				{
					foreach ($item in $InputObject)
					{
						$Table.Rows.Add($item)
					}
					return @( ,$Table)
				}
			}
			else
			{
				$Table.Rows.Clear()
			}
			
			foreach ($item in $InputObject)
			{
				$row = $table.NewRow()
				
				if ($item)
				{
					foreach ($prop in $item.PSObject.Get_Properties())
					{
						if ($table.Columns.Contains($prop.Name))
						{
							$row.Item($prop.Name) = $prop.Value
						}
					}
				}
				[void]$table.Rows.Add($row)
			}
		}
		
		return @(,$Table)
	}
	
	
	
	function Show-NotifyIcon
	{
	<#
		.SYNOPSIS
			Displays a NotifyIcon's balloon tip message in the taskbar's notification area.
		
		.DESCRIPTION
			Displays a NotifyIcon's a balloon tip message in the taskbar's notification area.
			
		.PARAMETER NotifyIcon
	     	The NotifyIcon control that will be displayed.
		
		.PARAMETER BalloonTipText
	     	Sets the text to display in the balloon tip.
		
		.PARAMETER BalloonTipTitle
			Sets the Title to display in the balloon tip.
		
		.PARAMETER BalloonTipIcon	
			The icon to display in the ballon tip.
		
		.PARAMETER Timeout	
			The time the ToolTip Balloon will remain visible in milliseconds. 
			Default: 0 - Uses windows default.
	#>
		 param(
		  [Parameter(Mandatory = $true, Position = 0)]
		  [ValidateNotNull()]
		  [System.Windows.Forms.NotifyIcon]$NotifyIcon,
		  [Parameter(Mandatory = $true, Position = 1)]
		  [ValidateNotNullOrEmpty()]
		  [String]$BalloonTipText,
		  [Parameter(Position = 2)]
		  [String]$BalloonTipTitle = '',
		  [Parameter(Position = 3)]
		  [System.Windows.Forms.ToolTipIcon]$BalloonTipIcon = 'None',
		  [Parameter(Position = 4)]
		  [int]$Timeout = 0
	 	)
		
		if($null -eq $NotifyIcon.Icon)
		{
			#Set a Default Icon otherwise the balloon will not show
			$NotifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon([System.Windows.Forms.Application]::ExecutablePath)
		}
		
		$NotifyIcon.ShowBalloonTip($Timeout, $BalloonTipTitle, $BalloonTipText, $BalloonTipIcon)
	}
	
	
	
	#endregion
	
	
	$buttonShowLocationHotKey_Click = {
		
		if ($buttonShowLocationHotKey.ForeColor -eq [System.Drawing.Color]::FromArgb(50, 250, 50))
		{
			Stop-Process -Name "Script_Showlocation_Hotkey ALT-GR or LEFTCTRL+ALT_RunAsAdmin" -Force
			$buttonShowLocationHotKey.ForeColor = [System.Drawing.Color]::FromArgb(250, 50, 50)
		}
		else
		{
			Start-Process "$script:ScriptDir\Script_Showlocation_Hotkey ALT-GR or LEFTCTRL+ALT_RunAsAdmin.exe"
			$buttonShowLocationHotKey.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
		}
	}
	
	$buttonAntiLogoffScript_Click = {
	
		#CHECK TOGGLE STATE (IF GREEN OR NOT)
		if ($buttonAntiLogoffScript.ForeColor -eq [System.Drawing.Color]::FromArgb(50, 250, 50))
		{
			Stop-Process -Name "AntiLogoffScript_V3" -Force
			$buttonAntiLogoffScript.ForeColor = [System.Drawing.Color]::FromArgb(250, 50, 50)
		}
		else
		{
			Start-Process "$script:ScriptDir\AntiLogoffScript_V3.exe"
			$buttonAntiLogoffScript.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
		}
	}
	
	$buttonClearStarCitizenCach_Click={
		Clear-CacheSC
		$buttonClearStarCitizenCach.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
	}
	
	$buttonToggleIngameOverlay_Click = {
		
		if ($global:RunspaceOverlay.RunspaceStateInfo.State)
		{
			Start-Process "msg" -argumentlist "* runspace is open"
			$RunspaceOverlay.CloseAsync()
			$RunspaceOverlay.Dispose()
			#
			$pOverlay.Close()
			$pOverlay.Dispose()
			#
			$formIngameOverlay.Close()
		}
		else
		{
			Start-Process "msg" -argumentlist "* runspace not detected"
		}
	}
	
	$label1013061_Click={
		$global:exitflag = $true
	}
	
	
	$buttonAutoRunToggle_Click={
		if ($buttonAutoRunToggle.ForeColor -eq [System.Drawing.Color]::FromArgb(50, 250, 50))
		{
			Stop-Process -Name "AutorunToggle" -Force
			$buttonAutoRunToggle.ForeColor = [System.Drawing.Color]::FromArgb(250, 50, 50)
		}
		else
		{
			Start-Process "$script:ScriptDir\AutorunToggle.exe"
			$buttonAutoRunToggle.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
		}
	}
	
	$buttonSelect_Click={
		$global:ShowPoiSelection = $true
	}
	
	$labelPlayerDayCondition_Click={
		#TODO: Place custom script here
		
	}
	
	$labelHourAngleDest_Click={
		#TODO: Place custom script here
		
	}
	
	$buttonDebugMode_Click={
		if ($buttonDebugMode.ForeColor -eq [System.Drawing.Color]::FromArgb(50, 250, 50))
		{
			$global:debug = $false
			$buttonDebugMode.ForeColor = [System.Drawing.Color]::FromArgb(250, 50, 50)
		}
		else
		{
			$global:debug = $true
			$buttonDebugMode.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
		}
	}
	
	$datagridview2_CellContentClick=[System.Windows.Forms.DataGridViewCellEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.DataGridViewCellEventArgs]
		#TODO: Place custom script here
		
	}
	
	$datagridview1_CellContentClick=[System.Windows.Forms.DataGridViewCellEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.DataGridViewCellEventArgs]
		#TODO: Place custom script here
		
	}
	
	$tabcontrol1_Click={
		#TODO: Place custom script here
		
	}
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formProjectJericho.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonSelect.remove_Click($buttonSelect_Click)
			$label1013061.remove_Click($label1013061_Click)
			$datagridview2.remove_CellContentClick($datagridview2_CellContentClick)
			$datagridview1.remove_CellContentClick($datagridview1_CellContentClick)
			$buttonDebugMode.remove_Click($buttonDebugMode_Click)
			$buttonAutoRunToggle.remove_Click($buttonAutoRunToggle_Click)
			$buttonToggleIngameOverlay.remove_Click($buttonToggleIngameOverlay_Click)
			$buttonClearStarCitizenCach.remove_Click($buttonClearStarCitizenCach_Click)
			$buttonAntiLogoffScript.remove_Click($buttonAntiLogoffScript_Click)
			$buttonShowLocationHotKey.remove_Click($buttonShowLocationHotKey_Click)
			$tabcontrol1.remove_Click($tabcontrol1_Click)
			$formProjectJericho.remove_Load($formProjectJericho_Load)
			$formProjectJericho.remove_Load($Form_StateCorrection_Load)
			$formProjectJericho.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formProjectJericho.SuspendLayout()
	$groupbox24.SuspendLayout()
	$tabcontrol1.SuspendLayout()
	$tabpage1.SuspendLayout()
	$groupbox27.SuspendLayout()
	$groupbox25.SuspendLayout()
	$groupbox23.SuspendLayout()
	$groupbox22.SuspendLayout()
	$groupbox21.SuspendLayout()
	$groupbox20.SuspendLayout()
	$groupbox19.SuspendLayout()
	$groupbox18.SuspendLayout()
	$groupbox17.SuspendLayout()
	$groupbox16.SuspendLayout()
	$groupbox15.SuspendLayout()
	$groupbox1.SuspendLayout()
	$tabpage2.SuspendLayout()
	$groupbox26.SuspendLayout()
	$groupbox42.SuspendLayout()
	$groupbox41.SuspendLayout()
	$groupbox32.SuspendLayout()
	$groupbox31.SuspendLayout()
	$groupbox40.SuspendLayout()
	$groupbox30.SuspendLayout()
	$groupbox33.SuspendLayout()
	$groupbox29.SuspendLayout()
	$tabpage3.SuspendLayout()
	$groupbox46.SuspendLayout()
	$groupbox45.SuspendLayout()
	$groupbox44.SuspendLayout()
	$tabpage4.SuspendLayout()
	$tabpage6.SuspendLayout()
	$tabpage7.SuspendLayout()
	$tabpage10.SuspendLayout()
	$tabpage8.SuspendLayout()
	$tabpage5.SuspendLayout()
	$tabpage9.SuspendLayout()
	#
	# formProjectJericho
	#
	$formProjectJericho.Controls.Add($labelCreatedByGraupunktWi)
	$formProjectJericho.Controls.Add($groupbox24)
	$formProjectJericho.Controls.Add($panel1)
	$formProjectJericho.Controls.Add($label1013061)
	$formProjectJericho.Controls.Add($labelSettings)
	$formProjectJericho.Controls.Add($labelSupportAndUpdatesMer)
	$formProjectJericho.Controls.Add($linklabelHttpsdiscordggWMh5YC)
	$formProjectJericho.Controls.Add($tabcontrol1)
	$formProjectJericho.Controls.Add($picturebox2)
	$formProjectJericho.AutoScaleDimensions = New-Object System.Drawing.SizeF(7, 15)
	$formProjectJericho.AutoScaleMode = 'Font'
	$formProjectJericho.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$formProjectJericho.BackgroundImageLayout = 'None'
	$formProjectJericho.ClientSize = New-Object System.Drawing.Size(1241, 726)
	$formProjectJericho.Font = [System.Drawing.Font]::new('Bookman Old Style', '8.25')
	$formProjectJericho.FormBorderStyle = 'FixedSingle'
	$formProjectJericho.Margin = '4, 3, 4, 3'
	$formProjectJericho.MaximizeBox = $False
	$formProjectJericho.Name = 'formProjectJericho'
	$formProjectJericho.Text = 'Project Jericho'
	$formProjectJericho.add_Load($formProjectJericho_Load)
	#
	# labelCreatedByGraupunktWi
	#
	$labelCreatedByGraupunktWi.AutoSize = $True
	$labelCreatedByGraupunktWi.BackColor = [System.Drawing.Color]::Transparent 
	$labelCreatedByGraupunktWi.Font = [System.Drawing.Font]::new('Montserrat', '8.999999')
	$labelCreatedByGraupunktWi.ForeColor = [System.Drawing.Color]::Transparent 
	$labelCreatedByGraupunktWi.Location = New-Object System.Drawing.Point(3, 702)
	$labelCreatedByGraupunktWi.Margin = '4, 0, 4, 0'
	$labelCreatedByGraupunktWi.Name = 'labelCreatedByGraupunktWi'
	$labelCreatedByGraupunktWi.Size = New-Object System.Drawing.Size(573, 16)
	$labelCreatedByGraupunktWi.TabIndex = 16
	$labelCreatedByGraupunktWi.Text = 'Ⓒ created by Graupunkt with blood and love, with help from justMurphy, Xabdiben, BigCheese'
	#
	# groupbox24
	#
	$groupbox24.Controls.Add($buttonSelect)
	$groupbox24.Controls.Add($textbox241)
	$groupbox24.Controls.Add($labelPArent)
	$groupbox24.Controls.Add($textbox240)
	$groupbox24.Controls.Add($labelSystem)
	$groupbox24.Controls.Add($label83)
	$groupbox24.Controls.Add($labelSAVED)
	$groupbox24.Controls.Add($label85)
	$groupbox24.Controls.Add($textbox64)
	$groupbox24.Controls.Add($textbox65)
	$groupbox24.Controls.Add($textbox66)
	$groupbox24.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$groupbox24.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox24.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox24.Location = New-Object System.Drawing.Point(851, 7)
	$groupbox24.Margin = '4, 3, 4, 3'
	$groupbox24.Name = 'groupbox24'
	$groupbox24.Padding = '4, 3, 4, 3'
	$groupbox24.RightToLeft = 'Yes'
	$groupbox24.Size = New-Object System.Drawing.Size(299, 117)
	$groupbox24.TabIndex = 13
	$groupbox24.TabStop = $False
	$groupbox24.Text = 'CURRENT DESTINATION'
	$tooltip.SetToolTip($groupbox24, 'The currently selected target, when it was added to the dataset, as well as other details such as the discoverer')
	#
	# buttonSelect
	#
	$buttonSelect.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$buttonSelect.Cursor = 'Hand'
	$buttonSelect.FlatStyle = 'Flat'
	$buttonSelect.Location = New-Object System.Drawing.Point(229, 77)
	$buttonSelect.Margin = '4, 3, 4, 3'
	$buttonSelect.Name = 'buttonSelect'
	$buttonSelect.Size = New-Object System.Drawing.Size(62, 27)
	$buttonSelect.TabIndex = 16
	$buttonSelect.Text = 'Select'
	$buttonSelect.UseVisualStyleBackColor = $False
	$buttonSelect.add_Click($buttonSelect_Click)
	#
	# textbox241
	#
	$textbox241.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox241.BorderStyle = 'None'
	$textbox241.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox241.ForeColor = [System.Drawing.Color]::White 
	$textbox241.Location = New-Object System.Drawing.Point(86, 54)
	$textbox241.Margin = '0, 0, 0, 0'
	$textbox241.Name = 'textbox241'
	$textbox241.ReadOnly = $True
	$textbox241.RightToLeft = 'No'
	$textbox241.Size = New-Object System.Drawing.Size(185, 16)
	$textbox241.TabIndex = 15
	$textbox241.Text = '-'
	#
	# labelPArent
	#
	$labelPArent.AutoSize = $True
	$labelPArent.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelPArent.ForeColor = [System.Drawing.Color]::Gray 
	$labelPArent.Location = New-Object System.Drawing.Point(15, 54)
	$labelPArent.Margin = '4, 0, 4, 0'
	$labelPArent.Name = 'labelPArent'
	$labelPArent.RightToLeft = 'No'
	$labelPArent.Size = New-Object System.Drawing.Size(55, 16)
	$labelPArent.TabIndex = 14
	$labelPArent.Text = 'PArent'
	#
	# textbox240
	#
	$textbox240.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox240.BorderStyle = 'None'
	$textbox240.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox240.ForeColor = [System.Drawing.Color]::White 
	$textbox240.Location = New-Object System.Drawing.Point(86, 36)
	$textbox240.Margin = '0, 0, 0, 0'
	$textbox240.Name = 'textbox240'
	$textbox240.ReadOnly = $True
	$textbox240.RightToLeft = 'No'
	$textbox240.Size = New-Object System.Drawing.Size(185, 16)
	$textbox240.TabIndex = 13
	$textbox240.Text = '-'
	#
	# labelSystem
	#
	$labelSystem.AutoSize = $True
	$labelSystem.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSystem.ForeColor = [System.Drawing.Color]::Gray 
	$labelSystem.Location = New-Object System.Drawing.Point(15, 36)
	$labelSystem.Margin = '4, 0, 4, 0'
	$labelSystem.Name = 'labelSystem'
	$labelSystem.RightToLeft = 'No'
	$labelSystem.Size = New-Object System.Drawing.Size(55, 16)
	$labelSystem.TabIndex = 12
	$labelSystem.Text = 'System'
	#
	# label83
	#
	$label83.AutoSize = $True
	$label83.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label83.ForeColor = [System.Drawing.Color]::Gray 
	$label83.Location = New-Object System.Drawing.Point(15, 90)
	$label83.Margin = '4, 0, 4, 0'
	$label83.Name = 'label83'
	$label83.RightToLeft = 'No'
	$label83.Size = New-Object System.Drawing.Size(63, 16)
	$label83.TabIndex = 11
	$label83.Text = 'COMMENT'
	#
	# labelSAVED
	#
	$labelSAVED.AutoSize = $True
	$labelSAVED.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSAVED.ForeColor = [System.Drawing.Color]::Gray 
	$labelSAVED.Location = New-Object System.Drawing.Point(15, 72)
	$labelSAVED.Margin = '4, 0, 4, 0'
	$labelSAVED.Name = 'labelSAVED'
	$labelSAVED.RightToLeft = 'No'
	$labelSAVED.Size = New-Object System.Drawing.Size(47, 16)
	$labelSAVED.TabIndex = 10
	$labelSAVED.Text = 'SAVED'
	#
	# label85
	#
	$label85.AutoSize = $True
	$label85.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label85.ForeColor = [System.Drawing.Color]::Gray 
	$label85.Location = New-Object System.Drawing.Point(15, 18)
	$label85.Margin = '4, 0, 4, 0'
	$label85.Name = 'label85'
	$label85.RightToLeft = 'No'
	$label85.Size = New-Object System.Drawing.Size(39, 16)
	$label85.TabIndex = 9
	$label85.Text = 'Name'
	#
	# textbox64
	#
	$textbox64.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox64.BorderStyle = 'None'
	$textbox64.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox64.ForeColor = [System.Drawing.Color]::White 
	$textbox64.Location = New-Object System.Drawing.Point(86, 72)
	$textbox64.Margin = '0, 0, 0, 0'
	$textbox64.Name = 'textbox64'
	$textbox64.ReadOnly = $True
	$textbox64.RightToLeft = 'No'
	$textbox64.Size = New-Object System.Drawing.Size(185, 16)
	$textbox64.TabIndex = 1
	$textbox64.Text = '-'
	#
	# textbox65
	#
	$textbox65.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox65.BorderStyle = 'None'
	$textbox65.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox65.ForeColor = [System.Drawing.Color]::White 
	$textbox65.Location = New-Object System.Drawing.Point(86, 18)
	$textbox65.Margin = '0, 0, 0, 0'
	$textbox65.Name = 'textbox65'
	$textbox65.ReadOnly = $True
	$textbox65.RightToLeft = 'No'
	$textbox65.Size = New-Object System.Drawing.Size(185, 16)
	$textbox65.TabIndex = 0
	$textbox65.Text = 'No DATA'
	#
	# textbox66
	#
	$textbox66.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox66.BorderStyle = 'None'
	$textbox66.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox66.ForeColor = [System.Drawing.Color]::White 
	$textbox66.Location = New-Object System.Drawing.Point(86, 90)
	$textbox66.Margin = '0, 0, 0, 0'
	$textbox66.Name = 'textbox66'
	$textbox66.ReadOnly = $True
	$textbox66.RightToLeft = 'No'
	$textbox66.Size = New-Object System.Drawing.Size(185, 16)
	$textbox66.TabIndex = 2
	$textbox66.Text = '-'
	#
	# panel1
	#
	$panel1.Location = New-Object System.Drawing.Point(909, 125)
	$panel1.Margin = '4, 3, 4, 3'
	$panel1.Name = 'panel1'
	$panel1.Size = New-Object System.Drawing.Size(369, 36)
	$panel1.TabIndex = 52
	#
	# label1013061
	#
	$label1013061.AutoSize = $True
	$label1013061.BackColor = [System.Drawing.Color]::Transparent 
	$label1013061.Font = [System.Drawing.Font]::new('Jericho-Digital', '20.25', [System.Drawing.FontStyle]'Bold')
	$label1013061.ForeColor = [System.Drawing.Color]::DarkOrange 
	$label1013061.Location = New-Object System.Drawing.Point(1211, 9)
	$label1013061.Margin = '4, 0, 4, 0'
	$label1013061.Name = 'label1013061'
	$label1013061.Size = New-Object System.Drawing.Size(26, 27)
	$label1013061.TabIndex = 50
	$label1013061.Text = 'X'
	$label1013061.add_Click($label1013061_Click)
	#
	# labelSettings
	#
	$labelSettings.AutoSize = $True
	$labelSettings.ForeColor = [System.Drawing.Color]::White 
	$labelSettings.Location = New-Object System.Drawing.Point(635, 90)
	$labelSettings.Margin = '4, 0, 4, 0'
	$labelSettings.Name = 'labelSettings'
	$labelSettings.Size = New-Object System.Drawing.Size(0, 15)
	$labelSettings.TabIndex = 27
	$labelSettings.Visible = $False
	#
	# labelSupportAndUpdatesMer
	#
	$labelSupportAndUpdatesMer.AutoSize = $True
	$labelSupportAndUpdatesMer.BackColor = [System.Drawing.Color]::Transparent 
	$labelSupportAndUpdatesMer.Font = [System.Drawing.Font]::new('Montserrat', '8.999999')
	$labelSupportAndUpdatesMer.ForeColor = [System.Drawing.Color]::Transparent 
	$labelSupportAndUpdatesMer.Location = New-Object System.Drawing.Point(740, 702)
	$labelSupportAndUpdatesMer.Margin = '4, 0, 4, 0'
	$labelSupportAndUpdatesMer.Name = 'labelSupportAndUpdatesMer'
	$labelSupportAndUpdatesMer.Size = New-Object System.Drawing.Size(255, 16)
	$labelSupportAndUpdatesMer.TabIndex = 18
	$labelSupportAndUpdatesMer.Text = 'Support and Updates @ Meridian Discord'
	#
	# linklabelHttpsdiscordggWMh5YC
	#
	$linklabelHttpsdiscordggWMh5YC.Cursor = 'Hand'
	$linklabelHttpsdiscordggWMh5YC.Font = [System.Drawing.Font]::new('Montserrat', '8.999999')
	$linklabelHttpsdiscordggWMh5YC.LinkColor = [System.Drawing.Color]::DarkOrange 
	$linklabelHttpsdiscordggWMh5YC.Location = New-Object System.Drawing.Point(1006, 702)
	$linklabelHttpsdiscordggWMh5YC.Margin = '4, 0, 4, 0'
	$linklabelHttpsdiscordggWMh5YC.Name = 'linklabelHttpsdiscordggWMh5YC'
	$linklabelHttpsdiscordggWMh5YC.Size = New-Object System.Drawing.Size(210, 19)
	$linklabelHttpsdiscordggWMh5YC.TabIndex = 17
	$linklabelHttpsdiscordggWMh5YC.TabStop = $True
	$linklabelHttpsdiscordggWMh5YC.Text = 'https://discord.gg/WMh5YCeQVS'
	#
	# tabcontrol1
	#
	$tabcontrol1.Controls.Add($tabpage1)
	$tabcontrol1.Controls.Add($tabpage2)
	$tabcontrol1.Controls.Add($tabpage3)
	$tabcontrol1.Controls.Add($tabpage4)
	$tabcontrol1.Controls.Add($tabpage6)
	$tabcontrol1.Controls.Add($tabpage7)
	$tabcontrol1.Controls.Add($tabpage10)
	$tabcontrol1.Controls.Add($tabpage8)
	$tabcontrol1.Controls.Add($tabpage5)
	$tabcontrol1.Controls.Add($tabpage9)
	$tabcontrol1.Cursor = 'Hand'
	$tabcontrol1.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$tabcontrol1.HotTrack = $True
	$tabcontrol1.ItemSize = New-Object System.Drawing.Size(75, 20)
	$tabcontrol1.Location = New-Object System.Drawing.Point(-5, 136)
	$tabcontrol1.Margin = '0, 0, 0, 0'
	$tabcontrol1.Name = 'tabcontrol1'
	$tabcontrol1.Padding = New-Object System.Drawing.Point(10, 3)
	$tabcontrol1.SelectedIndex = 0
	$tabcontrol1.ShowToolTips = $True
	$tabcontrol1.Size = New-Object System.Drawing.Size(1255, 605)
	$tabcontrol1.TabIndex = 2
	$tabcontrol1.add_Click($tabcontrol1_Click)
	#
	# tabpage1
	#
	$tabpage1.Controls.Add($labelRiseSetHourAngleD)
	$tabpage1.Controls.Add($labelHourAngleDest)
	$tabpage1.Controls.Add($labelRiseSetHourAngleP)
	$tabpage1.Controls.Add($labelHourAnglePlayer)
	$tabpage1.Controls.Add($labelPlayer)
	$tabpage1.Controls.Add($groupbox27)
	$tabpage1.Controls.Add($labelDestination)
	$tabpage1.Controls.Add($groupbox25)
	$tabpage1.Controls.Add($groupbox23)
	$tabpage1.Controls.Add($groupbox22)
	$tabpage1.Controls.Add($groupbox21)
	$tabpage1.Controls.Add($groupbox20)
	$tabpage1.Controls.Add($groupbox19)
	$tabpage1.Controls.Add($groupbox18)
	$tabpage1.Controls.Add($groupbox17)
	$tabpage1.Controls.Add($groupbox16)
	$tabpage1.Controls.Add($groupbox15)
	$tabpage1.Controls.Add($groupbox1)
	$tabpage1.Controls.Add($picturebox7)
	$tabpage1.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$tabpage1.BackgroundImageLayout = 'Stretch'
	$tabpage1.Cursor = 'Default'
	$tabpage1.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$tabpage1.ForeColor = [System.Drawing.Color]::DarkOrange 
	$tabpage1.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage1.Margin = '4, 3, 4, 3'
	$tabpage1.Name = 'tabpage1'
	$tabpage1.Padding = '4, 3, 4, 3'
	$tabpage1.RightToLeft = 'No'
	$tabpage1.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage1.TabIndex = 0
	$tabpage1.Text = 'Informations'
	#
	# labelRiseSetHourAngleD
	#
	$labelRiseSetHourAngleD.AutoSize = $True
	$labelRiseSetHourAngleD.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelRiseSetHourAngleD.ForeColor = [System.Drawing.Color]::Gray 
	$labelRiseSetHourAngleD.Location = New-Object System.Drawing.Point(609, 423)
	$labelRiseSetHourAngleD.Margin = '4, 0, 4, 0'
	$labelRiseSetHourAngleD.Name = 'labelRiseSetHourAngleD'
	$labelRiseSetHourAngleD.Size = New-Object System.Drawing.Size(139, 16)
	$labelRiseSetHourAngleD.TabIndex = 55
	$labelRiseSetHourAngleD.Text = 'RiseSetHourAngleD'
	#
	# labelHourAngleDest
	#
	$labelHourAngleDest.AutoSize = $True
	$labelHourAngleDest.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelHourAngleDest.ForeColor = [System.Drawing.Color]::Gray 
	$labelHourAngleDest.Location = New-Object System.Drawing.Point(609, 403)
	$labelHourAngleDest.Margin = '4, 0, 4, 0'
	$labelHourAngleDest.Name = 'labelHourAngleDest'
	$labelHourAngleDest.Size = New-Object System.Drawing.Size(119, 16)
	$labelHourAngleDest.TabIndex = 54
	$labelHourAngleDest.Text = 'HourHangleDest'
	#
	# labelRiseSetHourAngleP
	#
	$labelRiseSetHourAngleP.AutoSize = $True
	$labelRiseSetHourAngleP.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelRiseSetHourAngleP.ForeColor = [System.Drawing.Color]::Gray 
	$labelRiseSetHourAngleP.Location = New-Object System.Drawing.Point(609, 183)
	$labelRiseSetHourAngleP.Margin = '4, 0, 4, 0'
	$labelRiseSetHourAngleP.Name = 'labelRiseSetHourAngleP'
	$labelRiseSetHourAngleP.Size = New-Object System.Drawing.Size(139, 16)
	$labelRiseSetHourAngleP.TabIndex = 52
	$labelRiseSetHourAngleP.Text = 'RiseSetHourAngleP'
	#
	# labelHourAnglePlayer
	#
	$labelHourAnglePlayer.AutoSize = $True
	$labelHourAnglePlayer.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelHourAnglePlayer.ForeColor = [System.Drawing.Color]::Gray 
	$labelHourAnglePlayer.Location = New-Object System.Drawing.Point(609, 165)
	$labelHourAnglePlayer.Margin = '4, 0, 4, 0'
	$labelHourAnglePlayer.Name = 'labelHourAnglePlayer'
	$labelHourAnglePlayer.Size = New-Object System.Drawing.Size(127, 16)
	$labelHourAnglePlayer.TabIndex = 51
	$labelHourAnglePlayer.Text = 'HourAnglePlayer'
	#
	# labelPlayer
	#
	$labelPlayer.AutoSize = $True
	$labelPlayer.BackColor = [System.Drawing.Color]::Black 
	$labelPlayer.Font = [System.Drawing.Font]::new('Dungeon', '20.25', [System.Drawing.FontStyle]'Bold')
	$labelPlayer.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelPlayer.Location = New-Object System.Drawing.Point(270, 12)
	$labelPlayer.Margin = '4, 0, 4, 0'
	$labelPlayer.Name = 'labelPlayer'
	$labelPlayer.Size = New-Object System.Drawing.Size(112, 30)
	$labelPlayer.TabIndex = 37
	$labelPlayer.Text = 'Player'
	$tooltip.SetToolTip($labelPlayer, 'All values that are related to the player are displayed in orange')
	#
	# groupbox27
	#
	$groupbox27.Controls.Add($label1013051)
	$groupbox27.Controls.Add($label88)
	$groupbox27.Controls.Add($labelLocation)
	$groupbox27.Controls.Add($textbox73)
	$groupbox27.Controls.Add($textbox74)
	$groupbox27.Controls.Add($textbox75)
	$groupbox27.BackColor = [System.Drawing.Color]::Black 
	$groupbox27.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox27.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox27.Location = New-Object System.Drawing.Point(661, 50)
	$groupbox27.Margin = '4, 3, 4, 3'
	$groupbox27.Name = 'groupbox27'
	$groupbox27.Padding = '4, 3, 4, 3'
	$groupbox27.RightToLeft = 'Yes'
	$groupbox27.Size = New-Object System.Drawing.Size(243, 84)
	$groupbox27.TabIndex = 14
	$groupbox27.TabStop = $False
	$groupbox27.Text = 'SERVER'
	$tooltip.SetToolTip($groupbox27, 'The game server we are currently on, including the current session duration and the player name.')
	#
	# label1013051
	#
	$label1013051.AutoSize = $True
	$label1013051.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013051.ForeColor = [System.Drawing.Color]::Gray 
	$label1013051.Location = New-Object System.Drawing.Point(15, 40)
	$label1013051.Margin = '4, 0, 4, 0'
	$label1013051.Name = 'label1013051'
	$label1013051.RightToLeft = 'No'
	$label1013051.Size = New-Object System.Drawing.Size(59, 16)
	$label1013051.TabIndex = 12
	$label1013051.Text = 'Session'
	#
	# label88
	#
	$label88.AutoSize = $True
	$label88.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label88.ForeColor = [System.Drawing.Color]::Gray 
	$label88.Location = New-Object System.Drawing.Point(15, 60)
	$label88.Margin = '4, 0, 4, 0'
	$label88.Name = 'label88'
	$label88.RightToLeft = 'No'
	$label88.Size = New-Object System.Drawing.Size(55, 16)
	$label88.TabIndex = 11
	$label88.Text = 'Player'
	#
	# labelLocation
	#
	$labelLocation.AutoSize = $True
	$labelLocation.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelLocation.ForeColor = [System.Drawing.Color]::Gray 
	$labelLocation.Location = New-Object System.Drawing.Point(15, 20)
	$labelLocation.Margin = '4, 0, 4, 0'
	$labelLocation.Name = 'labelLocation'
	$labelLocation.RightToLeft = 'No'
	$labelLocation.Size = New-Object System.Drawing.Size(67, 16)
	$labelLocation.TabIndex = 9
	$labelLocation.Text = 'Location'
	#
	# textbox73
	#
	$textbox73.BackColor = [System.Drawing.Color]::Black 
	$textbox73.BorderStyle = 'None'
	$textbox73.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox73.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox73.Location = New-Object System.Drawing.Point(85, 40)
	$textbox73.Margin = '0, 0, 0, 0'
	$textbox73.Name = 'textbox73'
	$textbox73.ReadOnly = $True
	$textbox73.RightToLeft = 'No'
	$textbox73.Size = New-Object System.Drawing.Size(146, 16)
	$textbox73.TabIndex = 1
	$textbox73.Text = '-'
	#
	# textbox74
	#
	$textbox74.BackColor = [System.Drawing.Color]::Black 
	$textbox74.BorderStyle = 'None'
	$textbox74.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox74.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox74.Location = New-Object System.Drawing.Point(85, 20)
	$textbox74.Margin = '0, 0, 0, 0'
	$textbox74.Name = 'textbox74'
	$textbox74.ReadOnly = $True
	$textbox74.RightToLeft = 'No'
	$textbox74.Size = New-Object System.Drawing.Size(146, 16)
	$textbox74.TabIndex = 0
	$textbox74.Text = '-'
	#
	# textbox75
	#
	$textbox75.BackColor = [System.Drawing.Color]::Black 
	$textbox75.BorderStyle = 'None'
	$textbox75.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox75.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox75.Location = New-Object System.Drawing.Point(85, 60)
	$textbox75.Margin = '0, 0, 0, 0'
	$textbox75.Name = 'textbox75'
	$textbox75.ReadOnly = $True
	$textbox75.RightToLeft = 'No'
	$textbox75.Size = New-Object System.Drawing.Size(146, 16)
	$textbox75.TabIndex = 2
	$textbox75.Text = '-'
	#
	# labelDestination
	#
	$labelDestination.AutoSize = $True
	$labelDestination.BackColor = [System.Drawing.Color]::Black 
	$labelDestination.FlatStyle = 'Flat'
	$labelDestination.Font = [System.Drawing.Font]::new('Dungeon', '20.25', [System.Drawing.FontStyle]'Bold')
	$labelDestination.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelDestination.Location = New-Object System.Drawing.Point(226, 266)
	$labelDestination.Margin = '4, 0, 4, 0'
	$labelDestination.Name = 'labelDestination'
	$labelDestination.Size = New-Object System.Drawing.Size(189, 30)
	$labelDestination.TabIndex = 7
	$labelDestination.Text = 'Destination'
	#
	# groupbox25
	#
	$groupbox25.Controls.Add($label1013053)
	$groupbox25.Controls.Add($label1013052)
	$groupbox25.Controls.Add($labelServer)
	$groupbox25.Controls.Add($textbox67)
	$groupbox25.Controls.Add($textbox68)
	$groupbox25.Controls.Add($textbox69)
	$groupbox25.BackColor = [System.Drawing.Color]::Black 
	$groupbox25.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox25.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox25.Location = New-Object System.Drawing.Point(936, 50)
	$groupbox25.Margin = '4, 3, 4, 3'
	$groupbox25.Name = 'groupbox25'
	$groupbox25.Padding = '4, 3, 4, 3'
	$groupbox25.RightToLeft = 'Yes'
	$groupbox25.Size = New-Object System.Drawing.Size(246, 84)
	$groupbox25.TabIndex = 14
	$groupbox25.TabStop = $False
	$groupbox25.Text = 'TIME'
	$tooltip.SetToolTip($groupbox25, 'An overview of the different times.
ingame = time of the simulation in the verse
Local = The current time of the user
UTC = The time in which basic calculations and events take place.')
	#
	# label1013053
	#
	$label1013053.AutoSize = $True
	$label1013053.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013053.ForeColor = [System.Drawing.Color]::Gray 
	$label1013053.Location = New-Object System.Drawing.Point(15, 59)
	$label1013053.Margin = '4, 0, 4, 0'
	$label1013053.Name = 'label1013053'
	$label1013053.RightToLeft = 'No'
	$label1013053.Size = New-Object System.Drawing.Size(31, 16)
	$label1013053.TabIndex = 51
	$label1013053.Text = 'Utc'
	#
	# label1013052
	#
	$label1013052.AutoSize = $True
	$label1013052.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013052.ForeColor = [System.Drawing.Color]::Gray 
	$label1013052.Location = New-Object System.Drawing.Point(15, 40)
	$label1013052.Margin = '4, 0, 4, 0'
	$label1013052.Name = 'label1013052'
	$label1013052.RightToLeft = 'No'
	$label1013052.Size = New-Object System.Drawing.Size(47, 16)
	$label1013052.TabIndex = 50
	$label1013052.Text = 'Local'
	#
	# labelServer
	#
	$labelServer.AutoSize = $True
	$labelServer.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelServer.ForeColor = [System.Drawing.Color]::Gray 
	$labelServer.Location = New-Object System.Drawing.Point(15, 20)
	$labelServer.Margin = '4, 0, 4, 0'
	$labelServer.Name = 'labelServer'
	$labelServer.RightToLeft = 'No'
	$labelServer.Size = New-Object System.Drawing.Size(51, 16)
	$labelServer.TabIndex = 9
	$labelServer.Text = 'INGAME'
	#
	# textbox67
	#
	$textbox67.BackColor = [System.Drawing.Color]::Black 
	$textbox67.BorderStyle = 'None'
	$textbox67.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox67.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox67.Location = New-Object System.Drawing.Point(82, 40)
	$textbox67.Margin = '0, 0, 0, 0'
	$textbox67.Name = 'textbox67'
	$textbox67.ReadOnly = $True
	$textbox67.RightToLeft = 'No'
	$textbox67.Size = New-Object System.Drawing.Size(146, 16)
	$textbox67.TabIndex = 1
	$textbox67.Text = '-'
	#
	# textbox68
	#
	$textbox68.BackColor = [System.Drawing.Color]::Black 
	$textbox68.BorderStyle = 'None'
	$textbox68.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox68.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox68.Location = New-Object System.Drawing.Point(82, 20)
	$textbox68.Margin = '0, 0, 0, 0'
	$textbox68.Name = 'textbox68'
	$textbox68.ReadOnly = $True
	$textbox68.RightToLeft = 'No'
	$textbox68.Size = New-Object System.Drawing.Size(146, 16)
	$textbox68.TabIndex = 0
	$textbox68.Text = '-'
	#
	# textbox69
	#
	$textbox69.BackColor = [System.Drawing.Color]::Black 
	$textbox69.BorderStyle = 'None'
	$textbox69.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox69.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox69.Location = New-Object System.Drawing.Point(82, 60)
	$textbox69.Margin = '0, 0, 0, 0'
	$textbox69.Name = 'textbox69'
	$textbox69.ReadOnly = $True
	$textbox69.RightToLeft = 'No'
	$textbox69.Size = New-Object System.Drawing.Size(146, 16)
	$textbox69.TabIndex = 2
	$textbox69.Text = '-'
	#
	# groupbox23
	#
	$groupbox23.Controls.Add($label1013090)
	$groupbox23.Controls.Add($label80)
	$groupbox23.Controls.Add($textbox245)
	$groupbox23.Controls.Add($label72)
	$groupbox23.Controls.Add($label1013091)
	$groupbox23.Controls.Add($label81)
	$groupbox23.Controls.Add($label1013092)
	$groupbox23.Controls.Add($label82)
	$groupbox23.Controls.Add($textbox246)
	$groupbox23.Controls.Add($label74)
	$groupbox23.Controls.Add($textbox59)
	$groupbox23.Controls.Add($label76)
	$groupbox23.Controls.Add($textbox60)
	$groupbox23.Controls.Add($labelOM)
	$groupbox23.Controls.Add($labelQT)
	$groupbox23.Controls.Add($labelPOI)
	$groupbox23.Controls.Add($textbox61)
	$groupbox23.Controls.Add($textbox62)
	$groupbox23.Controls.Add($textbox63)
	$groupbox23.Controls.Add($textbox58)
	$groupbox23.BackColor = [System.Drawing.Color]::Black 
	$groupbox23.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox23.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox23.Location = New-Object System.Drawing.Point(261, 401)
	$groupbox23.Margin = '4, 3, 4, 3'
	$groupbox23.Name = 'groupbox23'
	$groupbox23.Padding = '4, 3, 4, 3'
	$groupbox23.RightToLeft = 'Yes'
	$groupbox23.Size = New-Object System.Drawing.Size(310, 105)
	$groupbox23.TabIndex = 47
	$groupbox23.TabStop = $False
	$groupbox23.Text = 'LOCATIONS '
	$tooltip.SetToolTip($groupbox23, 'Here we see the next locations with their corresponding distances. 
POI = Point of Interest
QT = Quantum Travel Beacon
OM = Orbital Marker')
	#
	# label1013090
	#
	$label1013090.AutoSize = $True
	$label1013090.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013090.ForeColor = [System.Drawing.Color]::Gray 
	$label1013090.Location = New-Object System.Drawing.Point(279, 79)
	$label1013090.Margin = '4, 0, 4, 0'
	$label1013090.Name = 'label1013090'
	$label1013090.RightToLeft = 'No'
	$label1013090.Size = New-Object System.Drawing.Size(23, 16)
	$label1013090.TabIndex = 53
	$label1013090.Text = 'km'
	#
	# label80
	#
	$label80.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label80.ForeColor = [System.Drawing.Color]::Gray 
	$label80.Location = New-Object System.Drawing.Point(211, 14)
	$label80.Margin = '0, 0, 0, 0'
	$label80.Name = 'label80'
	$label80.RightToLeft = 'No'
	$label80.Size = New-Object System.Drawing.Size(26, 26)
	$label80.TabIndex = 51
	$label80.Text = '→'
	#
	# textbox245
	#
	$textbox245.BackColor = [System.Drawing.Color]::Black 
	$textbox245.BorderStyle = 'None'
	$textbox245.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox245.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox245.Location = New-Object System.Drawing.Point(237, 79)
	$textbox245.Margin = '0, 0, 0, 0'
	$textbox245.Name = 'textbox245'
	$textbox245.ReadOnly = $True
	$textbox245.RightToLeft = 'No'
	$textbox245.Size = New-Object System.Drawing.Size(39, 16)
	$textbox245.TabIndex = 52
	$textbox245.Text = '-'
	$textbox245.TextAlign = 'Right'
	#
	# label72
	#
	$label72.AutoSize = $True
	$label72.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label72.ForeColor = [System.Drawing.Color]::Gray 
	$label72.Location = New-Object System.Drawing.Point(279, 60)
	$label72.Margin = '4, 0, 4, 0'
	$label72.Name = 'label72'
	$label72.RightToLeft = 'No'
	$label72.Size = New-Object System.Drawing.Size(23, 16)
	$label72.TabIndex = 46
	$label72.Text = 'km'
	#
	# label1013091
	#
	$label1013091.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label1013091.ForeColor = [System.Drawing.Color]::Gray 
	$label1013091.Location = New-Object System.Drawing.Point(211, 71)
	$label1013091.Margin = '0, 0, 0, 0'
	$label1013091.Name = 'label1013091'
	$label1013091.RightToLeft = 'No'
	$label1013091.Size = New-Object System.Drawing.Size(26, 26)
	$label1013091.TabIndex = 51
	$label1013091.Text = '→'
	#
	# label81
	#
	$label81.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label81.ForeColor = [System.Drawing.Color]::Gray 
	$label81.Location = New-Object System.Drawing.Point(211, 33)
	$label81.Margin = '0, 0, 0, 0'
	$label81.Name = 'label81'
	$label81.RightToLeft = 'No'
	$label81.Size = New-Object System.Drawing.Size(26, 26)
	$label81.TabIndex = 50
	$label81.Text = '→'
	#
	# label1013092
	#
	$label1013092.AutoSize = $True
	$label1013092.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013092.ForeColor = [System.Drawing.Color]::Brown 
	$label1013092.Location = New-Object System.Drawing.Point(15, 79)
	$label1013092.Margin = '4, 0, 4, 0'
	$label1013092.Name = 'label1013092'
	$label1013092.RightToLeft = 'No'
	$label1013092.Size = New-Object System.Drawing.Size(23, 16)
	$label1013092.TabIndex = 49
	$label1013092.Text = 'OC'
	#
	# label82
	#
	$label82.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label82.ForeColor = [System.Drawing.Color]::Gray 
	$label82.Location = New-Object System.Drawing.Point(211, 52)
	$label82.Margin = '0, 0, 0, 0'
	$label82.Name = 'label82'
	$label82.RightToLeft = 'No'
	$label82.Size = New-Object System.Drawing.Size(26, 26)
	$label82.TabIndex = 49
	$label82.Text = '→'
	#
	# textbox246
	#
	$textbox246.BackColor = [System.Drawing.Color]::Black 
	$textbox246.BorderStyle = 'None'
	$textbox246.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox246.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox246.Location = New-Object System.Drawing.Point(47, 79)
	$textbox246.Margin = '0, 0, 0, 0'
	$textbox246.Name = 'textbox246'
	$textbox246.ReadOnly = $True
	$textbox246.RightToLeft = 'No'
	$textbox246.Size = New-Object System.Drawing.Size(161, 16)
	$textbox246.TabIndex = 50
	$textbox246.Text = '-'
	$textbox246.TextAlign = 'Right'
	#
	# label74
	#
	$label74.AutoSize = $True
	$label74.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label74.ForeColor = [System.Drawing.Color]::Gray 
	$label74.Location = New-Object System.Drawing.Point(279, 40)
	$label74.Margin = '4, 0, 4, 0'
	$label74.Name = 'label74'
	$label74.RightToLeft = 'No'
	$label74.Size = New-Object System.Drawing.Size(23, 16)
	$label74.TabIndex = 43
	$label74.Text = 'km'
	#
	# textbox59
	#
	$textbox59.BackColor = [System.Drawing.Color]::Black 
	$textbox59.BorderStyle = 'None'
	$textbox59.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox59.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox59.Location = New-Object System.Drawing.Point(237, 40)
	$textbox59.Margin = '0, 0, 0, 0'
	$textbox59.Name = 'textbox59'
	$textbox59.ReadOnly = $True
	$textbox59.RightToLeft = 'No'
	$textbox59.Size = New-Object System.Drawing.Size(39, 16)
	$textbox59.TabIndex = 42
	$textbox59.Text = '-'
	$textbox59.TextAlign = 'Right'
	#
	# label76
	#
	$label76.AutoSize = $True
	$label76.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label76.ForeColor = [System.Drawing.Color]::Gray 
	$label76.Location = New-Object System.Drawing.Point(279, 20)
	$label76.Margin = '4, 0, 4, 0'
	$label76.Name = 'label76'
	$label76.RightToLeft = 'No'
	$label76.Size = New-Object System.Drawing.Size(23, 16)
	$label76.TabIndex = 40
	$label76.Text = 'km'
	#
	# textbox60
	#
	$textbox60.BackColor = [System.Drawing.Color]::Black 
	$textbox60.BorderStyle = 'None'
	$textbox60.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox60.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox60.Location = New-Object System.Drawing.Point(237, 20)
	$textbox60.Margin = '0, 0, 0, 0'
	$textbox60.Name = 'textbox60'
	$textbox60.ReadOnly = $True
	$textbox60.RightToLeft = 'No'
	$textbox60.Size = New-Object System.Drawing.Size(39, 16)
	$textbox60.TabIndex = 39
	$textbox60.Text = '-'
	$textbox60.TextAlign = 'Right'
	#
	# labelOM
	#
	$labelOM.AutoSize = $True
	$labelOM.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOM.ForeColor = [System.Drawing.Color]::Gray 
	$labelOM.Location = New-Object System.Drawing.Point(15, 60)
	$labelOM.Margin = '4, 0, 4, 0'
	$labelOM.Name = 'labelOM'
	$labelOM.RightToLeft = 'No'
	$labelOM.Size = New-Object System.Drawing.Size(23, 16)
	$labelOM.TabIndex = 11
	$labelOM.Text = 'OM'
	#
	# labelQT
	#
	$labelQT.AutoSize = $True
	$labelQT.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelQT.ForeColor = [System.Drawing.Color]::Gray 
	$labelQT.Location = New-Object System.Drawing.Point(15, 40)
	$labelQT.Margin = '4, 0, 4, 0'
	$labelQT.Name = 'labelQT'
	$labelQT.RightToLeft = 'No'
	$labelQT.Size = New-Object System.Drawing.Size(23, 16)
	$labelQT.TabIndex = 10
	$labelQT.Text = 'QT'
	#
	# labelPOI
	#
	$labelPOI.AutoSize = $True
	$labelPOI.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelPOI.ForeColor = [System.Drawing.Color]::Gray 
	$labelPOI.Location = New-Object System.Drawing.Point(15, 20)
	$labelPOI.Margin = '4, 0, 4, 0'
	$labelPOI.Name = 'labelPOI'
	$labelPOI.RightToLeft = 'No'
	$labelPOI.Size = New-Object System.Drawing.Size(27, 16)
	$labelPOI.TabIndex = 9
	$labelPOI.Text = 'POI'
	#
	# textbox61
	#
	$textbox61.BackColor = [System.Drawing.Color]::Black 
	$textbox61.BorderStyle = 'None'
	$textbox61.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox61.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox61.Location = New-Object System.Drawing.Point(47, 20)
	$textbox61.Margin = '0, 0, 0, 0'
	$textbox61.Name = 'textbox61'
	$textbox61.ReadOnly = $True
	$textbox61.RightToLeft = 'No'
	$textbox61.Size = New-Object System.Drawing.Size(161, 16)
	$textbox61.TabIndex = 24
	$textbox61.Text = '-'
	$textbox61.TextAlign = 'Right'
	#
	# textbox62
	#
	$textbox62.BackColor = [System.Drawing.Color]::Black 
	$textbox62.BorderStyle = 'None'
	$textbox62.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox62.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox62.Location = New-Object System.Drawing.Point(47, 60)
	$textbox62.Margin = '0, 0, 0, 0'
	$textbox62.Name = 'textbox62'
	$textbox62.ReadOnly = $True
	$textbox62.RightToLeft = 'No'
	$textbox62.Size = New-Object System.Drawing.Size(161, 16)
	$textbox62.TabIndex = 26
	$textbox62.Text = '-'
	$textbox62.TextAlign = 'Right'
	#
	# textbox63
	#
	$textbox63.BackColor = [System.Drawing.Color]::Black 
	$textbox63.BorderStyle = 'None'
	$textbox63.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox63.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox63.Location = New-Object System.Drawing.Point(47, 40)
	$textbox63.Margin = '0, 0, 0, 0'
	$textbox63.Name = 'textbox63'
	$textbox63.ReadOnly = $True
	$textbox63.RightToLeft = 'No'
	$textbox63.Size = New-Object System.Drawing.Size(161, 16)
	$textbox63.TabIndex = 25
	$textbox63.Text = '-'
	$textbox63.TextAlign = 'Right'
	#
	# textbox58
	#
	$textbox58.BackColor = [System.Drawing.Color]::Black 
	$textbox58.BorderStyle = 'None'
	$textbox58.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox58.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox58.Location = New-Object System.Drawing.Point(237, 60)
	$textbox58.Margin = '0, 0, 0, 0'
	$textbox58.Name = 'textbox58'
	$textbox58.ReadOnly = $True
	$textbox58.RightToLeft = 'No'
	$textbox58.Size = New-Object System.Drawing.Size(39, 16)
	$textbox58.TabIndex = 45
	$textbox58.Text = '-'
	$textbox58.TextAlign = 'Right'
	#
	# groupbox22
	#
	$groupbox22.Controls.Add($label1013093)
	$groupbox22.Controls.Add($label79)
	$groupbox22.Controls.Add($label1013094)
	$groupbox22.Controls.Add($label78)
	$groupbox22.Controls.Add($label1013095)
	$groupbox22.Controls.Add($textbox247)
	$groupbox22.Controls.Add($label70)
	$groupbox22.Controls.Add($textbox248)
	$groupbox22.Controls.Add($textbox57)
	$groupbox22.Controls.Add($label68)
	$groupbox22.Controls.Add($textbox56)
	$groupbox22.Controls.Add($label69)
	$groupbox22.Controls.Add($labelKm)
	$groupbox22.Controls.Add($textbox55)
	$groupbox22.Controls.Add($labelOC)
	$groupbox22.Controls.Add($label65)
	$groupbox22.Controls.Add($label66)
	$groupbox22.Controls.Add($textbox21)
	$groupbox22.Controls.Add($textbox20)
	$groupbox22.Controls.Add($textbox19)
	$groupbox22.BackColor = [System.Drawing.Color]::Black 
	$groupbox22.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox22.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox22.Location = New-Object System.Drawing.Point(261, 143)
	$groupbox22.Margin = '4, 3, 4, 3'
	$groupbox22.Name = 'groupbox22'
	$groupbox22.Padding = '4, 3, 4, 3'
	$groupbox22.RightToLeft = 'Yes'
	$groupbox22.Size = New-Object System.Drawing.Size(310, 105)
	$groupbox22.TabIndex = 19
	$groupbox22.TabStop = $False
	$groupbox22.Text = 'LOCATIONS '
	$tooltip.SetToolTip($groupbox22, 'Here we see the next locations with their corresponding distances.
POI = Point of Interest
QT = Quantum Travel Beacon
OC = Object Container
')
	#
	# label1013093
	#
	$label1013093.AutoSize = $True
	$label1013093.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013093.ForeColor = [System.Drawing.Color]::Gray 
	$label1013093.Location = New-Object System.Drawing.Point(279, 59)
	$label1013093.Margin = '4, 0, 4, 0'
	$label1013093.Name = 'label1013093'
	$label1013093.RightToLeft = 'No'
	$label1013093.Size = New-Object System.Drawing.Size(23, 16)
	$label1013093.TabIndex = 57
	$label1013093.Text = 'km'
	#
	# label79
	#
	$label79.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label79.ForeColor = [System.Drawing.Color]::Gray 
	$label79.Location = New-Object System.Drawing.Point(211, 14)
	$label79.Margin = '0, 0, 0, 0'
	$label79.Name = 'label79'
	$label79.RightToLeft = 'No'
	$label79.Size = New-Object System.Drawing.Size(26, 26)
	$label79.TabIndex = 48
	$label79.Text = '→'
	#
	# label1013094
	#
	$label1013094.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label1013094.ForeColor = [System.Drawing.Color]::Gray 
	$label1013094.Location = New-Object System.Drawing.Point(211, 51)
	$label1013094.Margin = '0, 0, 0, 0'
	$label1013094.Name = 'label1013094'
	$label1013094.RightToLeft = 'No'
	$label1013094.Size = New-Object System.Drawing.Size(26, 26)
	$label1013094.TabIndex = 58
	$label1013094.Text = '→'
	#
	# label78
	#
	$label78.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label78.ForeColor = [System.Drawing.Color]::Gray 
	$label78.Location = New-Object System.Drawing.Point(211, 33)
	$label78.Margin = '0, 0, 0, 0'
	$label78.Name = 'label78'
	$label78.RightToLeft = 'No'
	$label78.Size = New-Object System.Drawing.Size(26, 26)
	$label78.TabIndex = 48
	$label78.Text = '→'
	#
	# label1013095
	#
	$label1013095.AutoSize = $True
	$label1013095.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013095.ForeColor = [System.Drawing.Color]::Brown 
	$label1013095.Location = New-Object System.Drawing.Point(15, 59)
	$label1013095.Margin = '4, 0, 4, 0'
	$label1013095.Name = 'label1013095'
	$label1013095.RightToLeft = 'No'
	$label1013095.Size = New-Object System.Drawing.Size(23, 16)
	$label1013095.TabIndex = 54
	$label1013095.Text = 'OM'
	#
	# textbox247
	#
	$textbox247.BackColor = [System.Drawing.Color]::Black 
	$textbox247.BorderStyle = 'None'
	$textbox247.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox247.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox247.Location = New-Object System.Drawing.Point(47, 59)
	$textbox247.Margin = '0, 0, 0, 0'
	$textbox247.Name = 'textbox247'
	$textbox247.ReadOnly = $True
	$textbox247.RightToLeft = 'No'
	$textbox247.Size = New-Object System.Drawing.Size(161, 16)
	$textbox247.TabIndex = 55
	$textbox247.Text = '-'
	$textbox247.TextAlign = 'Right'
	#
	# label70
	#
	$label70.AutoSize = $True
	$label70.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label70.ForeColor = [System.Drawing.Color]::Gray 
	$label70.Location = New-Object System.Drawing.Point(279, 78)
	$label70.Margin = '4, 0, 4, 0'
	$label70.Name = 'label70'
	$label70.RightToLeft = 'No'
	$label70.Size = New-Object System.Drawing.Size(23, 16)
	$label70.TabIndex = 46
	$label70.Text = 'km'
	#
	# textbox248
	#
	$textbox248.BackColor = [System.Drawing.Color]::Black 
	$textbox248.BorderStyle = 'None'
	$textbox248.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox248.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox248.Location = New-Object System.Drawing.Point(237, 59)
	$textbox248.Margin = '0, 0, 0, 0'
	$textbox248.Name = 'textbox248'
	$textbox248.ReadOnly = $True
	$textbox248.RightToLeft = 'No'
	$textbox248.Size = New-Object System.Drawing.Size(39, 16)
	$textbox248.TabIndex = 56
	$textbox248.Text = '-'
	$textbox248.TextAlign = 'Right'
	#
	# textbox57
	#
	$textbox57.BackColor = [System.Drawing.Color]::Black 
	$textbox57.BorderStyle = 'None'
	$textbox57.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox57.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox57.Location = New-Object System.Drawing.Point(237, 78)
	$textbox57.Margin = '0, 0, 0, 0'
	$textbox57.Name = 'textbox57'
	$textbox57.ReadOnly = $True
	$textbox57.RightToLeft = 'No'
	$textbox57.Size = New-Object System.Drawing.Size(39, 16)
	$textbox57.TabIndex = 45
	$textbox57.Text = '-'
	$textbox57.TextAlign = 'Right'
	#
	# label68
	#
	$label68.AutoSize = $True
	$label68.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label68.ForeColor = [System.Drawing.Color]::Gray 
	$label68.Location = New-Object System.Drawing.Point(279, 40)
	$label68.Margin = '4, 0, 4, 0'
	$label68.Name = 'label68'
	$label68.RightToLeft = 'No'
	$label68.Size = New-Object System.Drawing.Size(23, 16)
	$label68.TabIndex = 43
	$label68.Text = 'km'
	#
	# textbox56
	#
	$textbox56.BackColor = [System.Drawing.Color]::Black 
	$textbox56.BorderStyle = 'None'
	$textbox56.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox56.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox56.Location = New-Object System.Drawing.Point(237, 40)
	$textbox56.Margin = '0, 0, 0, 0'
	$textbox56.Name = 'textbox56'
	$textbox56.ReadOnly = $True
	$textbox56.RightToLeft = 'No'
	$textbox56.Size = New-Object System.Drawing.Size(39, 16)
	$textbox56.TabIndex = 42
	$textbox56.Text = '-'
	$textbox56.TextAlign = 'Right'
	#
	# label69
	#
	$label69.Font = [System.Drawing.Font]::new('Arial Narrow', '15.75')
	$label69.ForeColor = [System.Drawing.Color]::Gray 
	$label69.Location = New-Object System.Drawing.Point(211, 70)
	$label69.Margin = '0, 0, 0, 0'
	$label69.Name = 'label69'
	$label69.RightToLeft = 'No'
	$label69.Size = New-Object System.Drawing.Size(26, 26)
	$label69.TabIndex = 41
	$label69.Text = '→'
	#
	# labelKm
	#
	$labelKm.AutoSize = $True
	$labelKm.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelKm.ForeColor = [System.Drawing.Color]::Gray 
	$labelKm.Location = New-Object System.Drawing.Point(279, 22)
	$labelKm.Margin = '4, 0, 4, 0'
	$labelKm.Name = 'labelKm'
	$labelKm.RightToLeft = 'No'
	$labelKm.Size = New-Object System.Drawing.Size(23, 16)
	$labelKm.TabIndex = 40
	$labelKm.Text = 'km'
	#
	# textbox55
	#
	$textbox55.BackColor = [System.Drawing.Color]::Black 
	$textbox55.BorderStyle = 'None'
	$textbox55.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox55.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox55.Location = New-Object System.Drawing.Point(237, 22)
	$textbox55.Margin = '0, 0, 0, 0'
	$textbox55.Name = 'textbox55'
	$textbox55.ReadOnly = $True
	$textbox55.RightToLeft = 'No'
	$textbox55.Size = New-Object System.Drawing.Size(39, 16)
	$textbox55.TabIndex = 39
	$textbox55.Text = '-'
	$textbox55.TextAlign = 'Right'
	#
	# labelOC
	#
	$labelOC.AutoSize = $True
	$labelOC.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOC.ForeColor = [System.Drawing.Color]::Gray 
	$labelOC.Location = New-Object System.Drawing.Point(15, 78)
	$labelOC.Margin = '4, 0, 4, 0'
	$labelOC.Name = 'labelOC'
	$labelOC.RightToLeft = 'No'
	$labelOC.Size = New-Object System.Drawing.Size(23, 16)
	$labelOC.TabIndex = 11
	$labelOC.Text = 'OC'
	#
	# label65
	#
	$label65.AutoSize = $True
	$label65.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label65.ForeColor = [System.Drawing.Color]::Gray 
	$label65.Location = New-Object System.Drawing.Point(15, 40)
	$label65.Margin = '4, 0, 4, 0'
	$label65.Name = 'label65'
	$label65.RightToLeft = 'No'
	$label65.Size = New-Object System.Drawing.Size(23, 16)
	$label65.TabIndex = 10
	$label65.Text = 'QT'
	#
	# label66
	#
	$label66.AutoSize = $True
	$label66.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label66.ForeColor = [System.Drawing.Color]::Gray 
	$label66.Location = New-Object System.Drawing.Point(15, 22)
	$label66.Margin = '4, 0, 4, 0'
	$label66.Name = 'label66'
	$label66.RightToLeft = 'No'
	$label66.Size = New-Object System.Drawing.Size(27, 16)
	$label66.TabIndex = 9
	$label66.Text = 'POI'
	#
	# textbox21
	#
	$textbox21.BackColor = [System.Drawing.Color]::Black 
	$textbox21.BorderStyle = 'None'
	$textbox21.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox21.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox21.Location = New-Object System.Drawing.Point(47, 22)
	$textbox21.Margin = '0, 0, 0, 0'
	$textbox21.Name = 'textbox21'
	$textbox21.ReadOnly = $True
	$textbox21.RightToLeft = 'No'
	$textbox21.Size = New-Object System.Drawing.Size(161, 16)
	$textbox21.TabIndex = 24
	$textbox21.Text = '-'
	$textbox21.TextAlign = 'Right'
	#
	# textbox20
	#
	$textbox20.BackColor = [System.Drawing.Color]::Black 
	$textbox20.BorderStyle = 'None'
	$textbox20.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox20.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox20.Location = New-Object System.Drawing.Point(47, 78)
	$textbox20.Margin = '0, 0, 0, 0'
	$textbox20.Name = 'textbox20'
	$textbox20.ReadOnly = $True
	$textbox20.RightToLeft = 'No'
	$textbox20.Size = New-Object System.Drawing.Size(161, 16)
	$textbox20.TabIndex = 26
	$textbox20.Text = '-'
	$textbox20.TextAlign = 'Right'
	#
	# textbox19
	#
	$textbox19.BackColor = [System.Drawing.Color]::Black 
	$textbox19.BorderStyle = 'None'
	$textbox19.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox19.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox19.Location = New-Object System.Drawing.Point(47, 40)
	$textbox19.Margin = '0, 0, 0, 0'
	$textbox19.Name = 'textbox19'
	$textbox19.ReadOnly = $True
	$textbox19.RightToLeft = 'No'
	$textbox19.Size = New-Object System.Drawing.Size(161, 16)
	$textbox19.TabIndex = 25
	$textbox19.Text = '-'
	$textbox19.TextAlign = 'Right'
	#
	# groupbox21
	#
	$groupbox21.Controls.Add($textbox42)
	$groupbox21.Controls.Add($label57)
	$groupbox21.Controls.Add($textbox43)
	$groupbox21.Controls.Add($label58)
	$groupbox21.Controls.Add($labelCondition)
	$groupbox21.Controls.Add($textbox44)
	$groupbox21.Controls.Add($label59)
	$groupbox21.Controls.Add($textbox45)
	$groupbox21.Controls.Add($textbox54)
	$groupbox21.Controls.Add($label60)
	$groupbox21.Controls.Add($label61)
	$groupbox21.Controls.Add($label62)
	$groupbox21.Controls.Add($label63)
	$groupbox21.BackColor = [System.Drawing.Color]::Black 
	$groupbox21.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox21.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox21.Location = New-Object System.Drawing.Point(37, 401)
	$groupbox21.Margin = '4, 3, 4, 3'
	$groupbox21.Name = 'groupbox21'
	$groupbox21.Padding = '4, 3, 4, 3'
	$groupbox21.RightToLeft = 'Yes'
	$groupbox21.Size = New-Object System.Drawing.Size(208, 105)
	$groupbox21.TabIndex = 38
	$groupbox21.TabStop = $False
	$groupbox21.Text = 'CONDITIONS '
	$tooltip.SetToolTip($groupbox21, 'Here we can see the next sunrise/ sunset and the duration until the event occurs.')
	#
	# textbox42
	#
	$textbox42.BackColor = [System.Drawing.Color]::Black 
	$textbox42.BorderStyle = 'None'
	$textbox42.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox42.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox42.Location = New-Object System.Drawing.Point(130, 40)
	$textbox42.Margin = '4, 3, 4, 3'
	$textbox42.Name = 'textbox42'
	$textbox42.ReadOnly = $True
	$textbox42.RightToLeft = 'No'
	$textbox42.Size = New-Object System.Drawing.Size(31, 16)
	$textbox42.TabIndex = 35
	$textbox42.Text = '-'
	$textbox42.TextAlign = 'Right'
	#
	# label57
	#
	$label57.AutoSize = $True
	$label57.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label57.ForeColor = [System.Drawing.Color]::Gray 
	$label57.Location = New-Object System.Drawing.Point(165, 40)
	$label57.Margin = '4, 0, 4, 0'
	$label57.Name = 'label57'
	$label57.RightToLeft = 'No'
	$label57.Size = New-Object System.Drawing.Size(27, 16)
	$label57.TabIndex = 37
	$label57.Text = 'min'
	#
	# textbox43
	#
	$textbox43.BackColor = [System.Drawing.Color]::Black 
	$textbox43.BorderStyle = 'None'
	$textbox43.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox43.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox43.Location = New-Object System.Drawing.Point(130, 20)
	$textbox43.Margin = '4, 3, 4, 3'
	$textbox43.Name = 'textbox43'
	$textbox43.ReadOnly = $True
	$textbox43.RightToLeft = 'No'
	$textbox43.Size = New-Object System.Drawing.Size(31, 16)
	$textbox43.TabIndex = 34
	$textbox43.Text = '-'
	$textbox43.TextAlign = 'Right'
	#
	# label58
	#
	$label58.AutoSize = $True
	$label58.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label58.ForeColor = [System.Drawing.Color]::Gray 
	$label58.Location = New-Object System.Drawing.Point(165, 20)
	$label58.Margin = '4, 0, 4, 0'
	$label58.Name = 'label58'
	$label58.RightToLeft = 'No'
	$label58.Size = New-Object System.Drawing.Size(27, 16)
	$label58.TabIndex = 36
	$label58.Text = 'min'
	#
	# labelCondition
	#
	$labelCondition.AutoSize = $True
	$labelCondition.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelCondition.ForeColor = [System.Drawing.Color]::Brown 
	$labelCondition.Location = New-Object System.Drawing.Point(15, 81)
	$labelCondition.Margin = '4, 0, 4, 0'
	$labelCondition.Name = 'labelCondition'
	$labelCondition.Size = New-Object System.Drawing.Size(71, 16)
	$labelCondition.TabIndex = 50
	$labelCondition.Text = 'Condition'
	#
	# textbox44
	#
	$textbox44.BackColor = [System.Drawing.Color]::Black 
	$textbox44.BorderStyle = 'None'
	$textbox44.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox44.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox44.Location = New-Object System.Drawing.Point(60, 40)
	$textbox44.Margin = '4, 3, 4, 3'
	$textbox44.Name = 'textbox44'
	$textbox44.ReadOnly = $True
	$textbox44.RightToLeft = 'No'
	$textbox44.Size = New-Object System.Drawing.Size(49, 16)
	$textbox44.TabIndex = 33
	$textbox44.Text = '00:00'
	$textbox44.TextAlign = 'Center'
	#
	# label59
	#
	$label59.AutoSize = $True
	$label59.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label59.ForeColor = [System.Drawing.Color]::Gray 
	$label59.Location = New-Object System.Drawing.Point(113, 40)
	$label59.Margin = '4, 0, 4, 0'
	$label59.Name = 'label59'
	$label59.RightToLeft = 'No'
	$label59.Size = New-Object System.Drawing.Size(19, 16)
	$label59.TabIndex = 35
	$label59.Text = 'in'
	#
	# textbox45
	#
	$textbox45.BackColor = [System.Drawing.Color]::Black 
	$textbox45.BorderStyle = 'None'
	$textbox45.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox45.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox45.Location = New-Object System.Drawing.Point(60, 20)
	$textbox45.Margin = '4, 3, 4, 3'
	$textbox45.Name = 'textbox45'
	$textbox45.ReadOnly = $True
	$textbox45.RightToLeft = 'No'
	$textbox45.Size = New-Object System.Drawing.Size(49, 16)
	$textbox45.TabIndex = 29
	$textbox45.Text = '00:00'
	$textbox45.TextAlign = 'Center'
	#
	# textbox54
	#
	$textbox54.BackColor = [System.Drawing.Color]::Black 
	$textbox54.BorderStyle = 'None'
	$textbox54.Font = [System.Drawing.Font]::new('DS-Digital', '12')
	$textbox54.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox54.Location = New-Object System.Drawing.Point(88, 60)
	$textbox54.Margin = '0, 0, 0, 0'
	$textbox54.Name = 'textbox54'
	$textbox54.ReadOnly = $True
	$textbox54.RightToLeft = 'No'
	$textbox54.Size = New-Object System.Drawing.Size(102, 16)
	$textbox54.TabIndex = 20
	$textbox54.Text = '-'
	$textbox54.TextAlign = 'Right'
	#
	# label60
	#
	$label60.AutoSize = $True
	$label60.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label60.ForeColor = [System.Drawing.Color]::Gray 
	$label60.Location = New-Object System.Drawing.Point(113, 20)
	$label60.Margin = '4, 0, 4, 0'
	$label60.Name = 'label60'
	$label60.RightToLeft = 'No'
	$label60.Size = New-Object System.Drawing.Size(19, 16)
	$label60.TabIndex = 34
	$label60.Text = 'in'
	#
	# label61
	#
	$label61.AutoSize = $True
	$label61.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label61.ForeColor = [System.Drawing.Color]::Gray 
	$label61.Location = New-Object System.Drawing.Point(15, 60)
	$label61.Margin = '4, 0, 4, 0'
	$label61.Name = 'label61'
	$label61.RightToLeft = 'No'
	$label61.Size = New-Object System.Drawing.Size(55, 16)
	$label61.TabIndex = 11
	$label61.Text = 'Planet'
	#
	# label62
	#
	$label62.AutoSize = $True
	$label62.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label62.ForeColor = [System.Drawing.Color]::Gray 
	$label62.Location = New-Object System.Drawing.Point(15, 40)
	$label62.Margin = '4, 0, 4, 0'
	$label62.Name = 'label62'
	$label62.RightToLeft = 'No'
	$label62.Size = New-Object System.Drawing.Size(31, 16)
	$label62.TabIndex = 10
	$label62.Text = 'Set'
	#
	# label63
	#
	$label63.AutoSize = $True
	$label63.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label63.ForeColor = [System.Drawing.Color]::Gray 
	$label63.Location = New-Object System.Drawing.Point(15, 20)
	$label63.Margin = '4, 0, 4, 0'
	$label63.Name = 'label63'
	$label63.RightToLeft = 'No'
	$label63.Size = New-Object System.Drawing.Size(35, 16)
	$label63.TabIndex = 9
	$label63.Text = 'Rise'
	#
	# groupbox20
	#
	$groupbox20.Controls.Add($labelMin)
	$groupbox20.Controls.Add($label56)
	$groupbox20.Controls.Add($labelDestDayCondition)
	$groupbox20.Controls.Add($label54)
	$groupbox20.Controls.Add($textbox27)
	$groupbox20.Controls.Add($labelIn)
	$groupbox20.Controls.Add($labelPlanet)
	$groupbox20.Controls.Add($label52)
	$groupbox20.Controls.Add($label53)
	$groupbox20.Controls.Add($textbox38)
	$groupbox20.Controls.Add($textbox39)
	$groupbox20.Controls.Add($textbox40)
	$groupbox20.Controls.Add($textbox41)
	$groupbox20.BackColor = [System.Drawing.Color]::Black 
	$groupbox20.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox20.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox20.Location = New-Object System.Drawing.Point(37, 143)
	$groupbox20.Margin = '4, 3, 4, 3'
	$groupbox20.Name = 'groupbox20'
	$groupbox20.Padding = '4, 3, 4, 3'
	$groupbox20.RightToLeft = 'Yes'
	$groupbox20.Size = New-Object System.Drawing.Size(208, 105)
	$groupbox20.TabIndex = 13
	$groupbox20.TabStop = $False
	$groupbox20.Text = 'CONDITIONS '
	$tooltip.SetToolTip($groupbox20, 'Here we can see the next sunrise/ sunset and the duration until the event occurs.')
	#
	# labelMin
	#
	$labelMin.AutoSize = $True
	$labelMin.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelMin.ForeColor = [System.Drawing.Color]::Gray 
	$labelMin.Location = New-Object System.Drawing.Point(165, 41)
	$labelMin.Margin = '4, 0, 4, 0'
	$labelMin.Name = 'labelMin'
	$labelMin.RightToLeft = 'No'
	$labelMin.Size = New-Object System.Drawing.Size(27, 16)
	$labelMin.TabIndex = 37
	$labelMin.Text = 'min'
	#
	# label56
	#
	$label56.AutoSize = $True
	$label56.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label56.ForeColor = [System.Drawing.Color]::Gray 
	$label56.Location = New-Object System.Drawing.Point(165, 21)
	$label56.Margin = '4, 0, 4, 0'
	$label56.Name = 'label56'
	$label56.RightToLeft = 'No'
	$label56.Size = New-Object System.Drawing.Size(27, 16)
	$label56.TabIndex = 36
	$label56.Text = 'min'
	#
	# labelDestDayCondition
	#
	$labelDestDayCondition.AutoSize = $True
	$labelDestDayCondition.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelDestDayCondition.ForeColor = [System.Drawing.Color]::Gray 
	$labelDestDayCondition.Location = New-Object System.Drawing.Point(15, 80)
	$labelDestDayCondition.Margin = '4, 0, 4, 0'
	$labelDestDayCondition.Name = 'labelDestDayCondition'
	$labelDestDayCondition.Size = New-Object System.Drawing.Size(71, 16)
	$labelDestDayCondition.TabIndex = 53
	$labelDestDayCondition.Text = 'Condition'
	#
	# label54
	#
	$label54.AutoSize = $True
	$label54.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label54.ForeColor = [System.Drawing.Color]::Gray 
	$label54.Location = New-Object System.Drawing.Point(113, 40)
	$label54.Margin = '4, 0, 4, 0'
	$label54.Name = 'label54'
	$label54.RightToLeft = 'No'
	$label54.Size = New-Object System.Drawing.Size(19, 16)
	$label54.TabIndex = 35
	$label54.Text = 'in'
	#
	# textbox27
	#
	$textbox27.BackColor = [System.Drawing.Color]::Black 
	$textbox27.BorderStyle = 'None'
	$textbox27.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox27.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox27.Location = New-Object System.Drawing.Point(87, 60)
	$textbox27.Margin = '0, 0, 0, 0'
	$textbox27.Name = 'textbox27'
	$textbox27.ReadOnly = $True
	$textbox27.RightToLeft = 'No'
	$textbox27.Size = New-Object System.Drawing.Size(102, 16)
	$textbox27.TabIndex = 20
	$textbox27.Text = '-'
	$textbox27.TextAlign = 'Right'
	#
	# labelIn
	#
	$labelIn.AutoSize = $True
	$labelIn.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelIn.ForeColor = [System.Drawing.Color]::Gray 
	$labelIn.Location = New-Object System.Drawing.Point(113, 20)
	$labelIn.Margin = '4, 0, 4, 0'
	$labelIn.Name = 'labelIn'
	$labelIn.RightToLeft = 'No'
	$labelIn.Size = New-Object System.Drawing.Size(19, 16)
	$labelIn.TabIndex = 34
	$labelIn.Text = 'in'
	#
	# labelPlanet
	#
	$labelPlanet.AutoSize = $True
	$labelPlanet.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelPlanet.ForeColor = [System.Drawing.Color]::Gray 
	$labelPlanet.Location = New-Object System.Drawing.Point(15, 60)
	$labelPlanet.Margin = '4, 0, 4, 0'
	$labelPlanet.Name = 'labelPlanet'
	$labelPlanet.RightToLeft = 'No'
	$labelPlanet.Size = New-Object System.Drawing.Size(55, 16)
	$labelPlanet.TabIndex = 11
	$labelPlanet.Text = 'Planet'
	#
	# label52
	#
	$label52.AutoSize = $True
	$label52.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label52.ForeColor = [System.Drawing.Color]::Gray 
	$label52.Location = New-Object System.Drawing.Point(15, 40)
	$label52.Margin = '4, 0, 4, 0'
	$label52.Name = 'label52'
	$label52.RightToLeft = 'No'
	$label52.Size = New-Object System.Drawing.Size(31, 16)
	$label52.TabIndex = 10
	$label52.Text = 'Set'
	#
	# label53
	#
	$label53.AutoSize = $True
	$label53.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label53.ForeColor = [System.Drawing.Color]::Gray 
	$label53.Location = New-Object System.Drawing.Point(15, 20)
	$label53.Margin = '4, 0, 4, 0'
	$label53.Name = 'label53'
	$label53.RightToLeft = 'No'
	$label53.Size = New-Object System.Drawing.Size(35, 16)
	$label53.TabIndex = 9
	$label53.Text = 'Rise'
	#
	# textbox38
	#
	$textbox38.BackColor = [System.Drawing.Color]::Black 
	$textbox38.BorderStyle = 'None'
	$textbox38.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox38.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox38.Location = New-Object System.Drawing.Point(60, 20)
	$textbox38.Margin = '4, 3, 4, 3'
	$textbox38.Name = 'textbox38'
	$textbox38.ReadOnly = $True
	$textbox38.RightToLeft = 'No'
	$textbox38.Size = New-Object System.Drawing.Size(46, 16)
	$textbox38.TabIndex = 29
	$textbox38.Text = '00:00'
	$textbox38.TextAlign = 'Center'
	#
	# textbox39
	#
	$textbox39.BackColor = [System.Drawing.Color]::Black 
	$textbox39.BorderStyle = 'None'
	$textbox39.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox39.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox39.Location = New-Object System.Drawing.Point(60, 40)
	$textbox39.Margin = '4, 3, 4, 3'
	$textbox39.Name = 'textbox39'
	$textbox39.ReadOnly = $True
	$textbox39.RightToLeft = 'No'
	$textbox39.Size = New-Object System.Drawing.Size(46, 16)
	$textbox39.TabIndex = 33
	$textbox39.Text = '00:00'
	$textbox39.TextAlign = 'Center'
	#
	# textbox40
	#
	$textbox40.BackColor = [System.Drawing.Color]::Black 
	$textbox40.BorderStyle = 'None'
	$textbox40.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox40.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox40.Location = New-Object System.Drawing.Point(130, 20)
	$textbox40.Margin = '4, 3, 4, 3'
	$textbox40.Name = 'textbox40'
	$textbox40.ReadOnly = $True
	$textbox40.RightToLeft = 'No'
	$textbox40.Size = New-Object System.Drawing.Size(31, 16)
	$textbox40.TabIndex = 34
	$textbox40.Text = '-'
	$textbox40.TextAlign = 'Right'
	#
	# textbox41
	#
	$textbox41.BackColor = [System.Drawing.Color]::Black 
	$textbox41.BorderStyle = 'None'
	$textbox41.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox41.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox41.Location = New-Object System.Drawing.Point(130, 40)
	$textbox41.Margin = '4, 3, 4, 3'
	$textbox41.Name = 'textbox41'
	$textbox41.ReadOnly = $True
	$textbox41.RightToLeft = 'No'
	$textbox41.Size = New-Object System.Drawing.Size(31, 16)
	$textbox41.TabIndex = 35
	$textbox41.Text = '-'
	$textbox41.TextAlign = 'Right'
	#
	# groupbox19
	#
	$groupbox19.Controls.Add($label45)
	$groupbox19.Controls.Add($textbox16)
	$groupbox19.Controls.Add($textbox17)
	$groupbox19.Controls.Add($textbox18)
	$groupbox19.Controls.Add($label46)
	$groupbox19.Controls.Add($label47)
	$groupbox19.Controls.Add($label48)
	$groupbox19.Controls.Add($label49)
	$groupbox19.Controls.Add($label50)
	$groupbox19.BackColor = [System.Drawing.Color]::Black 
	$groupbox19.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox19.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox19.Location = New-Object System.Drawing.Point(391, 303)
	$groupbox19.Margin = '4, 3, 4, 3'
	$groupbox19.Name = 'groupbox19'
	$groupbox19.Padding = '4, 3, 4, 3'
	$groupbox19.RightToLeft = 'Yes'
	$groupbox19.Size = New-Object System.Drawing.Size(180, 84)
	$groupbox19.TabIndex = 22
	$groupbox19.TabStop = $False
	$groupbox19.Text = 'GEO '
	$tooltip.SetToolTip($groupbox19, 'Similar to the GPS system on earth, the respective latitude, longitude and altitude (water level) are displayed here. ')
	#
	# label45
	#
	$label45.AutoSize = $True
	$label45.BackColor = [System.Drawing.Color]::Black 
	$label45.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label45.ForeColor = [System.Drawing.Color]::Gray 
	$label45.Location = New-Object System.Drawing.Point(147, 60)
	$label45.Margin = '4, 0, 4, 0'
	$label45.Name = 'label45'
	$label45.RightToLeft = 'No'
	$label45.Size = New-Object System.Drawing.Size(15, 16)
	$label45.TabIndex = 21
	$label45.Text = 'm'
	#
	# textbox16
	#
	$textbox16.BackColor = [System.Drawing.Color]::Black 
	$textbox16.BorderStyle = 'None'
	$textbox16.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox16.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox16.Location = New-Object System.Drawing.Point(68, 40)
	$textbox16.Margin = '0, 0, 0, 0'
	$textbox16.Name = 'textbox16'
	$textbox16.ReadOnly = $True
	$textbox16.RightToLeft = 'No'
	$textbox16.Size = New-Object System.Drawing.Size(79, 16)
	$textbox16.TabIndex = 25
	$textbox16.Text = '-'
	$textbox16.TextAlign = 'Right'
	#
	# textbox17
	#
	$textbox17.BackColor = [System.Drawing.Color]::Black 
	$textbox17.BorderStyle = 'None'
	$textbox17.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox17.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox17.Location = New-Object System.Drawing.Point(68, 60)
	$textbox17.Margin = '0, 0, 0, 0'
	$textbox17.Name = 'textbox17'
	$textbox17.ReadOnly = $True
	$textbox17.RightToLeft = 'No'
	$textbox17.Size = New-Object System.Drawing.Size(79, 16)
	$textbox17.TabIndex = 26
	$textbox17.Text = '-'
	$textbox17.TextAlign = 'Right'
	#
	# textbox18
	#
	$textbox18.BackColor = [System.Drawing.Color]::Black 
	$textbox18.BorderStyle = 'None'
	$textbox18.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox18.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox18.Location = New-Object System.Drawing.Point(68, 20)
	$textbox18.Margin = '0, 0, 0, 0'
	$textbox18.Name = 'textbox18'
	$textbox18.ReadOnly = $True
	$textbox18.RightToLeft = 'No'
	$textbox18.Size = New-Object System.Drawing.Size(79, 16)
	$textbox18.TabIndex = 24
	$textbox18.Text = '-'
	$textbox18.TextAlign = 'Right'
	#
	# label46
	#
	$label46.AutoSize = $True
	$label46.BackColor = [System.Drawing.Color]::Black 
	$label46.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label46.ForeColor = [System.Drawing.Color]::Gray 
	$label46.Location = New-Object System.Drawing.Point(146, 39)
	$label46.Margin = '4, 0, 4, 0'
	$label46.Name = 'label46'
	$label46.RightToLeft = 'No'
	$label46.Size = New-Object System.Drawing.Size(12, 16)
	$label46.TabIndex = 20
	$label46.Text = '°'
	#
	# label47
	#
	$label47.AutoSize = $True
	$label47.BackColor = [System.Drawing.Color]::Black 
	$label47.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label47.ForeColor = [System.Drawing.Color]::Gray 
	$label47.Location = New-Object System.Drawing.Point(146, 19)
	$label47.Margin = '4, 0, 4, 0'
	$label47.Name = 'label47'
	$label47.RightToLeft = 'No'
	$label47.Size = New-Object System.Drawing.Size(12, 16)
	$label47.TabIndex = 19
	$label47.Text = '°'
	#
	# label48
	#
	$label48.AutoSize = $True
	$label48.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label48.ForeColor = [System.Drawing.Color]::Gray 
	$label48.Location = New-Object System.Drawing.Point(15, 60)
	$label48.Margin = '4, 0, 4, 0'
	$label48.Name = 'label48'
	$label48.RightToLeft = 'No'
	$label48.Size = New-Object System.Drawing.Size(51, 16)
	$label48.TabIndex = 11
	$label48.Text = 'Height'
	#
	# label49
	#
	$label49.AutoSize = $True
	$label49.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label49.ForeColor = [System.Drawing.Color]::Gray 
	$label49.Location = New-Object System.Drawing.Point(15, 40)
	$label49.Margin = '4, 0, 4, 0'
	$label49.Name = 'label49'
	$label49.RightToLeft = 'No'
	$label49.Size = New-Object System.Drawing.Size(39, 16)
	$label49.TabIndex = 10
	$label49.Text = 'Long'
	#
	# label50
	#
	$label50.AutoSize = $True
	$label50.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label50.ForeColor = [System.Drawing.Color]::Gray 
	$label50.Location = New-Object System.Drawing.Point(15, 20)
	$label50.Margin = '4, 0, 4, 0'
	$label50.Name = 'label50'
	$label50.RightToLeft = 'No'
	$label50.Size = New-Object System.Drawing.Size(31, 16)
	$label50.TabIndex = 9
	$label50.Text = 'Lat'
	#
	# groupbox18
	#
	$groupbox18.Controls.Add($labelZ)
	$groupbox18.Controls.Add($labelY)
	$groupbox18.Controls.Add($labelX)
	$groupbox18.Controls.Add($textbox12)
	$groupbox18.Controls.Add($textbox10)
	$groupbox18.Controls.Add($textbox11)
	$groupbox18.BackColor = [System.Drawing.Color]::Black 
	$groupbox18.Font = [System.Drawing.Font]::new('Dungeon', '9')
	$groupbox18.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox18.Location = New-Object System.Drawing.Point(237, 303)
	$groupbox18.Margin = '4, 3, 4, 3'
	$groupbox18.Name = 'groupbox18'
	$groupbox18.Padding = '4, 3, 4, 3'
	$groupbox18.RightToLeft = 'Yes'
	$groupbox18.Size = New-Object System.Drawing.Size(135, 84)
	$groupbox18.TabIndex = 19
	$groupbox18.TabStop = $False
	$groupbox18.Text = 'LOCAL '
	$tooltip.SetToolTip($groupbox18, 'These are local coordinates. They refer to the respective planet or objectcontainer. Object containers in this tool can be planets, moons or lagrange points. Across the community and cig these values are given in kilometres.')
	#
	# labelZ
	#
	$labelZ.AutoSize = $True
	$labelZ.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelZ.ForeColor = [System.Drawing.Color]::Gray 
	$labelZ.Location = New-Object System.Drawing.Point(15, 60)
	$labelZ.Margin = '4, 0, 4, 0'
	$labelZ.Name = 'labelZ'
	$labelZ.RightToLeft = 'No'
	$labelZ.Size = New-Object System.Drawing.Size(15, 16)
	$labelZ.TabIndex = 11
	$labelZ.Text = 'Z'
	#
	# labelY
	#
	$labelY.AutoSize = $True
	$labelY.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelY.ForeColor = [System.Drawing.Color]::Gray 
	$labelY.Location = New-Object System.Drawing.Point(15, 40)
	$labelY.Margin = '4, 0, 4, 0'
	$labelY.Name = 'labelY'
	$labelY.RightToLeft = 'No'
	$labelY.Size = New-Object System.Drawing.Size(15, 16)
	$labelY.TabIndex = 10
	$labelY.Text = 'Y'
	#
	# labelX
	#
	$labelX.AutoSize = $True
	$labelX.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelX.ForeColor = [System.Drawing.Color]::Gray 
	$labelX.Location = New-Object System.Drawing.Point(15, 20)
	$labelX.Margin = '4, 0, 4, 0'
	$labelX.Name = 'labelX'
	$labelX.RightToLeft = 'No'
	$labelX.Size = New-Object System.Drawing.Size(15, 16)
	$labelX.TabIndex = 9
	$labelX.Text = 'X'
	#
	# textbox12
	#
	$textbox12.BackColor = [System.Drawing.Color]::Black 
	$textbox12.BorderStyle = 'None'
	$textbox12.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox12.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox12.Location = New-Object System.Drawing.Point(35, 20)
	$textbox12.Margin = '0, 0, 0, 0'
	$textbox12.Name = 'textbox12'
	$textbox12.ReadOnly = $True
	$textbox12.RightToLeft = 'No'
	$textbox12.Size = New-Object System.Drawing.Size(84, 16)
	$textbox12.TabIndex = 18
	$textbox12.Text = '-'
	$textbox12.TextAlign = 'Right'
	#
	# textbox10
	#
	$textbox10.BackColor = [System.Drawing.Color]::Black 
	$textbox10.BorderStyle = 'None'
	$textbox10.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox10.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox10.Location = New-Object System.Drawing.Point(35, 60)
	$textbox10.Margin = '0, 0, 0, 0'
	$textbox10.Name = 'textbox10'
	$textbox10.ReadOnly = $True
	$textbox10.RightToLeft = 'No'
	$textbox10.Size = New-Object System.Drawing.Size(84, 16)
	$textbox10.TabIndex = 20
	$textbox10.Text = '-'
	$textbox10.TextAlign = 'Right'
	#
	# textbox11
	#
	$textbox11.BackColor = [System.Drawing.Color]::Black 
	$textbox11.BorderStyle = 'None'
	$textbox11.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox11.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox11.Location = New-Object System.Drawing.Point(35, 40)
	$textbox11.Margin = '0, 0, 0, 0'
	$textbox11.Name = 'textbox11'
	$textbox11.ReadOnly = $True
	$textbox11.RightToLeft = 'No'
	$textbox11.Size = New-Object System.Drawing.Size(84, 16)
	$textbox11.TabIndex = 19
	$textbox11.Text = '-'
	$textbox11.TextAlign = 'Right'
	#
	# groupbox17
	#
	$groupbox17.Controls.Add($labelM)
	$groupbox17.Controls.Add($label2)
	$groupbox17.Controls.Add($label1)
	$groupbox17.Controls.Add($labelHeight)
	$groupbox17.Controls.Add($label5)
	$groupbox17.Controls.Add($label4)
	$groupbox17.Controls.Add($textbox51)
	$groupbox17.Controls.Add($textbox52)
	$groupbox17.Controls.Add($textbox53)
	$groupbox17.BackColor = [System.Drawing.Color]::Black 
	$groupbox17.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox17.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox17.Location = New-Object System.Drawing.Point(391, 50)
	$groupbox17.Margin = '4, 3, 4, 3'
	$groupbox17.Name = 'groupbox17'
	$groupbox17.Padding = '4, 3, 4, 3'
	$groupbox17.RightToLeft = 'Yes'
	$groupbox17.Size = New-Object System.Drawing.Size(180, 84)
	$groupbox17.TabIndex = 19
	$groupbox17.TabStop = $False
	$groupbox17.Text = 'GEO '
	$tooltip.SetToolTip($groupbox17, 'Similar to the GPS system on earth, the respective latitude, longitude and altitude (water level) are displayed here. 
Values are given in degrees decimal.')
	#
	# labelM
	#
	$labelM.AutoSize = $True
	$labelM.BackColor = [System.Drawing.Color]::Black 
	$labelM.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelM.ForeColor = [System.Drawing.Color]::Gray 
	$labelM.Location = New-Object System.Drawing.Point(148, 60)
	$labelM.Margin = '4, 0, 4, 0'
	$labelM.Name = 'labelM'
	$labelM.RightToLeft = 'No'
	$labelM.Size = New-Object System.Drawing.Size(15, 16)
	$labelM.TabIndex = 21
	$labelM.Text = 'm'
	#
	# label2
	#
	$label2.AutoSize = $True
	$label2.BackColor = [System.Drawing.Color]::Black 
	$label2.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label2.ForeColor = [System.Drawing.Color]::Gray 
	$label2.Location = New-Object System.Drawing.Point(146, 39)
	$label2.Margin = '4, 0, 4, 0'
	$label2.Name = 'label2'
	$label2.RightToLeft = 'No'
	$label2.Size = New-Object System.Drawing.Size(12, 16)
	$label2.TabIndex = 20
	$label2.Text = '°'
	#
	# label1
	#
	$label1.AutoSize = $True
	$label1.BackColor = [System.Drawing.Color]::Black 
	$label1.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1.ForeColor = [System.Drawing.Color]::Gray 
	$label1.Location = New-Object System.Drawing.Point(146, 19)
	$label1.Margin = '4, 0, 4, 0'
	$label1.Name = 'label1'
	$label1.RightToLeft = 'No'
	$label1.Size = New-Object System.Drawing.Size(12, 16)
	$label1.TabIndex = 19
	$label1.Text = '°'
	#
	# labelHeight
	#
	$labelHeight.AutoSize = $True
	$labelHeight.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelHeight.ForeColor = [System.Drawing.Color]::Gray 
	$labelHeight.Location = New-Object System.Drawing.Point(15, 60)
	$labelHeight.Margin = '4, 0, 4, 0'
	$labelHeight.Name = 'labelHeight'
	$labelHeight.RightToLeft = 'No'
	$labelHeight.Size = New-Object System.Drawing.Size(51, 16)
	$labelHeight.TabIndex = 11
	$labelHeight.Text = 'Height'
	#
	# label5
	#
	$label5.AutoSize = $True
	$label5.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label5.ForeColor = [System.Drawing.Color]::Gray 
	$label5.Location = New-Object System.Drawing.Point(15, 40)
	$label5.Margin = '4, 0, 4, 0'
	$label5.Name = 'label5'
	$label5.RightToLeft = 'No'
	$label5.Size = New-Object System.Drawing.Size(39, 16)
	$label5.TabIndex = 10
	$label5.Text = 'Long'
	#
	# label4
	#
	$label4.AutoSize = $True
	$label4.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label4.ForeColor = [System.Drawing.Color]::Gray 
	$label4.Location = New-Object System.Drawing.Point(15, 20)
	$label4.Margin = '4, 0, 4, 0'
	$label4.Name = 'label4'
	$label4.RightToLeft = 'No'
	$label4.Size = New-Object System.Drawing.Size(31, 16)
	$label4.TabIndex = 9
	$label4.Text = 'Lat'
	#
	# textbox51
	#
	$textbox51.BackColor = [System.Drawing.Color]::Black 
	$textbox51.BorderStyle = 'None'
	$textbox51.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox51.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox51.Location = New-Object System.Drawing.Point(68, 60)
	$textbox51.Margin = '0, 0, 0, 0'
	$textbox51.Name = 'textbox51'
	$textbox51.ReadOnly = $True
	$textbox51.RightToLeft = 'No'
	$textbox51.Size = New-Object System.Drawing.Size(79, 16)
	$textbox51.TabIndex = 18
	$textbox51.Text = '-'
	$textbox51.TextAlign = 'Right'
	#
	# textbox52
	#
	$textbox52.BackColor = [System.Drawing.Color]::Black 
	$textbox52.BorderStyle = 'None'
	$textbox52.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox52.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox52.Location = New-Object System.Drawing.Point(68, 40)
	$textbox52.Margin = '0, 0, 0, 0'
	$textbox52.Name = 'textbox52'
	$textbox52.ReadOnly = $True
	$textbox52.RightToLeft = 'No'
	$textbox52.Size = New-Object System.Drawing.Size(79, 16)
	$textbox52.TabIndex = 14
	$textbox52.Text = '-'
	$textbox52.TextAlign = 'Right'
	#
	# textbox53
	#
	$textbox53.BackColor = [System.Drawing.Color]::Black 
	$textbox53.BorderStyle = 'None'
	$textbox53.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox53.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox53.Location = New-Object System.Drawing.Point(68, 20)
	$textbox53.Margin = '0, 0, 0, 0'
	$textbox53.Name = 'textbox53'
	$textbox53.ReadOnly = $True
	$textbox53.RightToLeft = 'No'
	$textbox53.Size = New-Object System.Drawing.Size(79, 16)
	$textbox53.TabIndex = 13
	$textbox53.Text = '-'
	$textbox53.TextAlign = 'Right'
	#
	# groupbox16
	#
	$groupbox16.Controls.Add($label42)
	$groupbox16.Controls.Add($textbox6)
	$groupbox16.Controls.Add($label43)
	$groupbox16.Controls.Add($textbox5)
	$groupbox16.Controls.Add($label44)
	$groupbox16.Controls.Add($textbox4)
	$groupbox16.BackColor = [System.Drawing.Color]::Black 
	$groupbox16.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox16.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox16.Location = New-Object System.Drawing.Point(37, 303)
	$groupbox16.Margin = '4, 3, 4, 3'
	$groupbox16.Name = 'groupbox16'
	$groupbox16.Padding = '4, 3, 4, 3'
	$groupbox16.RightToLeft = 'Yes'
	$groupbox16.Size = New-Object System.Drawing.Size(177, 84)
	$groupbox16.TabIndex = 13
	$groupbox16.TabStop = $False
	$groupbox16.Text = 'GLOBAL '
	$tooltip.SetToolTip($groupbox16, 'These coordinates refer to the current system. They define a specific location in space. The unit of measurement is in metres.')
	#
	# label42
	#
	$label42.AutoSize = $True
	$label42.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label42.ForeColor = [System.Drawing.Color]::Gray 
	$label42.Location = New-Object System.Drawing.Point(15, 60)
	$label42.Margin = '4, 0, 4, 0'
	$label42.Name = 'label42'
	$label42.RightToLeft = 'No'
	$label42.Size = New-Object System.Drawing.Size(15, 16)
	$label42.TabIndex = 11
	$label42.Text = 'Z'
	#
	# textbox6
	#
	$textbox6.BackColor = [System.Drawing.Color]::Black 
	$textbox6.BorderStyle = 'None'
	$textbox6.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox6.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox6.Location = New-Object System.Drawing.Point(36, 20)
	$textbox6.Margin = '0, 0, 0, 0'
	$textbox6.Name = 'textbox6'
	$textbox6.ReadOnly = $True
	$textbox6.RightToLeft = 'No'
	$textbox6.Size = New-Object System.Drawing.Size(127, 16)
	$textbox6.TabIndex = 6
	$textbox6.Text = '-'
	$textbox6.TextAlign = 'Right'
	#
	# label43
	#
	$label43.AutoSize = $True
	$label43.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label43.ForeColor = [System.Drawing.Color]::Gray 
	$label43.Location = New-Object System.Drawing.Point(15, 40)
	$label43.Margin = '4, 0, 4, 0'
	$label43.Name = 'label43'
	$label43.RightToLeft = 'No'
	$label43.Size = New-Object System.Drawing.Size(15, 16)
	$label43.TabIndex = 10
	$label43.Text = 'Y'
	#
	# textbox5
	#
	$textbox5.BackColor = [System.Drawing.Color]::Black 
	$textbox5.BorderStyle = 'None'
	$textbox5.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox5.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox5.Location = New-Object System.Drawing.Point(36, 40)
	$textbox5.Margin = '0, 0, 0, 0'
	$textbox5.Name = 'textbox5'
	$textbox5.ReadOnly = $True
	$textbox5.RightToLeft = 'No'
	$textbox5.Size = New-Object System.Drawing.Size(127, 16)
	$textbox5.TabIndex = 7
	$textbox5.Text = '-'
	$textbox5.TextAlign = 'Right'
	#
	# label44
	#
	$label44.AutoSize = $True
	$label44.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label44.ForeColor = [System.Drawing.Color]::Gray 
	$label44.Location = New-Object System.Drawing.Point(15, 20)
	$label44.Margin = '4, 0, 4, 0'
	$label44.Name = 'label44'
	$label44.RightToLeft = 'No'
	$label44.Size = New-Object System.Drawing.Size(15, 16)
	$label44.TabIndex = 9
	$label44.Text = 'X'
	#
	# textbox4
	#
	$textbox4.BackColor = [System.Drawing.Color]::Black 
	$textbox4.BorderStyle = 'None'
	$textbox4.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox4.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox4.Location = New-Object System.Drawing.Point(36, 60)
	$textbox4.Margin = '0, 0, 0, 0'
	$textbox4.Name = 'textbox4'
	$textbox4.ReadOnly = $True
	$textbox4.RightToLeft = 'No'
	$textbox4.Size = New-Object System.Drawing.Size(127, 16)
	$textbox4.TabIndex = 8
	$textbox4.Text = '-'
	$textbox4.TextAlign = 'Right'
	#
	# groupbox15
	#
	$groupbox15.Controls.Add($label39)
	$groupbox15.Controls.Add($label40)
	$groupbox15.Controls.Add($label41)
	$groupbox15.Controls.Add($textbox23)
	$groupbox15.Controls.Add($textbox7)
	$groupbox15.Controls.Add($textbox8)
	$groupbox15.BackColor = [System.Drawing.Color]::Black 
	$groupbox15.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox15.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox15.Location = New-Object System.Drawing.Point(237, 50)
	$groupbox15.Margin = '4, 3, 4, 3'
	$groupbox15.Name = 'groupbox15'
	$groupbox15.Padding = '4, 3, 4, 3'
	$groupbox15.RightToLeft = 'Yes'
	$groupbox15.Size = New-Object System.Drawing.Size(135, 84)
	$groupbox15.TabIndex = 13
	$groupbox15.TabStop = $False
	$groupbox15.Text = 'LOCAL '
	$tooltip.SetToolTip($groupbox15, 'These are local coordinates. They refer to the respective planet or objectcontainer. Object containers in this tool can be planets, moons or lagrange points. Across the community and cig these values are given in kilometres.')
	#
	# label39
	#
	$label39.AutoSize = $True
	$label39.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label39.ForeColor = [System.Drawing.Color]::Gray 
	$label39.Location = New-Object System.Drawing.Point(15, 60)
	$label39.Margin = '4, 0, 4, 0'
	$label39.Name = 'label39'
	$label39.RightToLeft = 'No'
	$label39.Size = New-Object System.Drawing.Size(15, 16)
	$label39.TabIndex = 11
	$label39.Text = 'Z'
	#
	# label40
	#
	$label40.AutoSize = $True
	$label40.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label40.ForeColor = [System.Drawing.Color]::Gray 
	$label40.Location = New-Object System.Drawing.Point(15, 40)
	$label40.Margin = '4, 0, 4, 0'
	$label40.Name = 'label40'
	$label40.RightToLeft = 'No'
	$label40.Size = New-Object System.Drawing.Size(15, 16)
	$label40.TabIndex = 10
	$label40.Text = 'Y'
	#
	# label41
	#
	$label41.AutoSize = $True
	$label41.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label41.ForeColor = [System.Drawing.Color]::Gray 
	$label41.Location = New-Object System.Drawing.Point(15, 20)
	$label41.Margin = '4, 0, 4, 0'
	$label41.Name = 'label41'
	$label41.RightToLeft = 'No'
	$label41.Size = New-Object System.Drawing.Size(15, 16)
	$label41.TabIndex = 9
	$label41.Text = 'X'
	#
	# textbox23
	#
	$textbox23.BackColor = [System.Drawing.Color]::Black 
	$textbox23.BorderStyle = 'None'
	$textbox23.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox23.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox23.Location = New-Object System.Drawing.Point(35, 58)
	$textbox23.Margin = '0, 0, 0, 0'
	$textbox23.Name = 'textbox23'
	$textbox23.ReadOnly = $True
	$textbox23.RightToLeft = 'No'
	$textbox23.Size = New-Object System.Drawing.Size(84, 16)
	$textbox23.TabIndex = 18
	$textbox23.Text = '-'
	$textbox23.TextAlign = 'Right'
	#
	# textbox7
	#
	$textbox7.BackColor = [System.Drawing.Color]::Black 
	$textbox7.BorderStyle = 'None'
	$textbox7.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox7.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox7.Location = New-Object System.Drawing.Point(35, 40)
	$textbox7.Margin = '0, 0, 0, 0'
	$textbox7.Name = 'textbox7'
	$textbox7.ReadOnly = $True
	$textbox7.RightToLeft = 'No'
	$textbox7.Size = New-Object System.Drawing.Size(84, 16)
	$textbox7.TabIndex = 14
	$textbox7.Text = '-'
	$textbox7.TextAlign = 'Right'
	#
	# textbox8
	#
	$textbox8.BackColor = [System.Drawing.Color]::Black 
	$textbox8.BorderStyle = 'None'
	$textbox8.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox8.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox8.Location = New-Object System.Drawing.Point(35, 20)
	$textbox8.Margin = '0, 0, 0, 0'
	$textbox8.Name = 'textbox8'
	$textbox8.ReadOnly = $True
	$textbox8.RightToLeft = 'No'
	$textbox8.Size = New-Object System.Drawing.Size(84, 16)
	$textbox8.TabIndex = 13
	$textbox8.Text = '-'
	$textbox8.TextAlign = 'Right'
	#
	# groupbox1
	#
	$groupbox1.Controls.Add($label36)
	$groupbox1.Controls.Add($label37)
	$groupbox1.Controls.Add($label38)
	$groupbox1.Controls.Add($textbox2)
	$groupbox1.Controls.Add($textbox1)
	$groupbox1.Controls.Add($textbox3)
	$groupbox1.BackColor = [System.Drawing.Color]::Black 
	$groupbox1.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox1.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox1.Location = New-Object System.Drawing.Point(37, 50)
	$groupbox1.Margin = '4, 3, 4, 3'
	$groupbox1.Name = 'groupbox1'
	$groupbox1.Padding = '4, 3, 4, 3'
	$groupbox1.RightToLeft = 'Yes'
	$groupbox1.Size = New-Object System.Drawing.Size(177, 84)
	$groupbox1.TabIndex = 12
	$groupbox1.TabStop = $False
	$groupbox1.Text = 'GLOBAL '
	$tooltip.SetToolTip($groupbox1, 'These coordinates refer to the current system. They define a specific location in space. The unit of measurement is in metres.')
	#
	# label36
	#
	$label36.AutoSize = $True
	$label36.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label36.ForeColor = [System.Drawing.Color]::Gray 
	$label36.Location = New-Object System.Drawing.Point(15, 60)
	$label36.Margin = '4, 0, 4, 0'
	$label36.Name = 'label36'
	$label36.RightToLeft = 'No'
	$label36.Size = New-Object System.Drawing.Size(15, 16)
	$label36.TabIndex = 11
	$label36.Text = 'Z'
	#
	# label37
	#
	$label37.AutoSize = $True
	$label37.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label37.ForeColor = [System.Drawing.Color]::Gray 
	$label37.Location = New-Object System.Drawing.Point(15, 40)
	$label37.Margin = '4, 0, 4, 0'
	$label37.Name = 'label37'
	$label37.RightToLeft = 'No'
	$label37.Size = New-Object System.Drawing.Size(15, 16)
	$label37.TabIndex = 10
	$label37.Text = 'Y'
	#
	# label38
	#
	$label38.AutoSize = $True
	$label38.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label38.ForeColor = [System.Drawing.Color]::Gray 
	$label38.Location = New-Object System.Drawing.Point(15, 20)
	$label38.Margin = '4, 0, 4, 0'
	$label38.Name = 'label38'
	$label38.RightToLeft = 'No'
	$label38.Size = New-Object System.Drawing.Size(15, 16)
	$label38.TabIndex = 9
	$label38.Text = 'X'
	#
	# textbox2
	#
	$textbox2.BackColor = [System.Drawing.Color]::Black 
	$textbox2.BorderStyle = 'None'
	$textbox2.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox2.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox2.Location = New-Object System.Drawing.Point(35, 40)
	$textbox2.Margin = '0, 0, 0, 0'
	$textbox2.Name = 'textbox2'
	$textbox2.ReadOnly = $True
	$textbox2.RightToLeft = 'No'
	$textbox2.Size = New-Object System.Drawing.Size(127, 16)
	$textbox2.TabIndex = 1
	$textbox2.Text = '-'
	$textbox2.TextAlign = 'Right'
	#
	# textbox1
	#
	$textbox1.BackColor = [System.Drawing.Color]::Black 
	$textbox1.BorderStyle = 'None'
	$textbox1.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox1.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox1.Location = New-Object System.Drawing.Point(35, 20)
	$textbox1.Margin = '0, 0, 0, 0'
	$textbox1.Name = 'textbox1'
	$textbox1.ReadOnly = $True
	$textbox1.RightToLeft = 'No'
	$textbox1.Size = New-Object System.Drawing.Size(127, 16)
	$textbox1.TabIndex = 0
	$textbox1.Text = '-'
	$textbox1.TextAlign = 'Right'
	#
	# textbox3
	#
	$textbox3.BackColor = [System.Drawing.Color]::Black 
	$textbox3.BorderStyle = 'None'
	$textbox3.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox3.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox3.Location = New-Object System.Drawing.Point(35, 60)
	$textbox3.Margin = '0, 0, 0, 0'
	$textbox3.Name = 'textbox3'
	$textbox3.ReadOnly = $True
	$textbox3.RightToLeft = 'No'
	$textbox3.Size = New-Object System.Drawing.Size(127, 16)
	$textbox3.TabIndex = 2
	$textbox3.Text = '-'
	$textbox3.TextAlign = 'Right'
	#
	# picturebox7
	#
	$picturebox7.BackColor = [System.Drawing.Color]::Black 
	$picturebox7.BackgroundImageLayout = 'Stretch'
	$picturebox7.Location = New-Object System.Drawing.Point(0, 0)
	$picturebox7.Margin = '4, 3, 4, 3'
	$picturebox7.Name = 'picturebox7'
	$picturebox7.Size = New-Object System.Drawing.Size(1249, 538)
	$picturebox7.SizeMode = 'StretchImage'
	$picturebox7.TabIndex = 49
	$picturebox7.TabStop = $False
	#
	# tabpage2
	#
	$tabpage2.Controls.Add($groupbox26)
	$tabpage2.Controls.Add($groupbox42)
	$tabpage2.Controls.Add($groupbox41)
	$tabpage2.Controls.Add($groupbox32)
	$tabpage2.Controls.Add($groupbox31)
	$tabpage2.Controls.Add($groupbox40)
	$tabpage2.Controls.Add($groupbox30)
	$tabpage2.Controls.Add($groupbox33)
	$tabpage2.Controls.Add($groupbox29)
	$tabpage2.Controls.Add($picturebox8)
	$tabpage2.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$tabpage2.BackgroundImageLayout = 'Stretch'
	$tabpage2.Cursor = 'Default'
	$tabpage2.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage2.Margin = '4, 3, 4, 3'
	$tabpage2.Name = 'tabpage2'
	$tabpage2.Padding = '4, 3, 4, 3'
	$tabpage2.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage2.TabIndex = 1
	$tabpage2.Text = 'Navigation'
	#
	# groupbox26
	#
	$groupbox26.Controls.Add($labelTotal)
	$groupbox26.Controls.Add($textbox237)
	$groupbox26.Controls.Add($labelOCunt)
	$groupbox26.Controls.Add($labelSInce)
	$groupbox26.Controls.Add($labelLAST)
	$groupbox26.Controls.Add($textbox70)
	$groupbox26.Controls.Add($textbox71)
	$groupbox26.Controls.Add($textbox72)
	$groupbox26.BackColor = [System.Drawing.Color]::Black 
	$groupbox26.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox26.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox26.Location = New-Object System.Drawing.Point(940, 24)
	$groupbox26.Margin = '4, 3, 4, 3'
	$groupbox26.Name = 'groupbox26'
	$groupbox26.Padding = '4, 3, 4, 3'
	$groupbox26.RightToLeft = 'Yes'
	$groupbox26.Size = New-Object System.Drawing.Size(174, 111)
	$groupbox26.TabIndex = 14
	$groupbox26.TabStop = $False
	$groupbox26.Text = 'UPDATE'
	$tooltip.SetToolTip($groupbox26, 'Statistics about the update of the tool by the debug command /showlocation')
	#
	# labelTotal
	#
	$labelTotal.AutoSize = $True
	$labelTotal.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelTotal.ForeColor = [System.Drawing.Color]::Gray 
	$labelTotal.Location = New-Object System.Drawing.Point(15, 40)
	$labelTotal.Margin = '4, 0, 4, 0'
	$labelTotal.Name = 'labelTotal'
	$labelTotal.RightToLeft = 'No'
	$labelTotal.Size = New-Object System.Drawing.Size(47, 16)
	$labelTotal.TabIndex = 13
	$labelTotal.Text = 'Total'
	#
	# textbox237
	#
	$textbox237.BackColor = [System.Drawing.Color]::Black 
	$textbox237.BorderStyle = 'None'
	$textbox237.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox237.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox237.Location = New-Object System.Drawing.Point(75, 40)
	$textbox237.Margin = '0, 0, 0, 0'
	$textbox237.Name = 'textbox237'
	$textbox237.ReadOnly = $True
	$textbox237.RightToLeft = 'No'
	$textbox237.Size = New-Object System.Drawing.Size(80, 16)
	$textbox237.TabIndex = 12
	$textbox237.Text = '-'
	$textbox237.TextAlign = 'Right'
	#
	# labelOCunt
	#
	$labelOCunt.AutoSize = $True
	$labelOCunt.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOCunt.ForeColor = [System.Drawing.Color]::Gray 
	$labelOCunt.Location = New-Object System.Drawing.Point(15, 79)
	$labelOCunt.Margin = '4, 0, 4, 0'
	$labelOCunt.Name = 'labelOCunt'
	$labelOCunt.RightToLeft = 'No'
	$labelOCunt.Size = New-Object System.Drawing.Size(39, 16)
	$labelOCunt.TabIndex = 11
	$labelOCunt.Text = 'Last'
	#
	# labelSInce
	#
	$labelSInce.AutoSize = $True
	$labelSInce.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSInce.ForeColor = [System.Drawing.Color]::Gray 
	$labelSInce.Location = New-Object System.Drawing.Point(15, 59)
	$labelSInce.Margin = '4, 0, 4, 0'
	$labelSInce.Name = 'labelSInce'
	$labelSInce.RightToLeft = 'No'
	$labelSInce.Size = New-Object System.Drawing.Size(43, 16)
	$labelSInce.TabIndex = 10
	$labelSInce.Text = 'SInce'
	#
	# labelLAST
	#
	$labelLAST.AutoSize = $True
	$labelLAST.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelLAST.ForeColor = [System.Drawing.Color]::Gray 
	$labelLAST.Location = New-Object System.Drawing.Point(15, 20)
	$labelLAST.Margin = '4, 0, 4, 0'
	$labelLAST.Name = 'labelLAST'
	$labelLAST.RightToLeft = 'No'
	$labelLAST.Size = New-Object System.Drawing.Size(47, 16)
	$labelLAST.TabIndex = 9
	$labelLAST.Text = 'Count'
	#
	# textbox70
	#
	$textbox70.BackColor = [System.Drawing.Color]::Black 
	$textbox70.BorderStyle = 'None'
	$textbox70.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox70.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox70.Location = New-Object System.Drawing.Point(75, 59)
	$textbox70.Margin = '0, 0, 0, 0'
	$textbox70.Name = 'textbox70'
	$textbox70.ReadOnly = $True
	$textbox70.RightToLeft = 'No'
	$textbox70.Size = New-Object System.Drawing.Size(80, 16)
	$textbox70.TabIndex = 1
	$textbox70.Text = '-'
	$textbox70.TextAlign = 'Right'
	#
	# textbox71
	#
	$textbox71.BackColor = [System.Drawing.Color]::Black 
	$textbox71.BorderStyle = 'None'
	$textbox71.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox71.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox71.Location = New-Object System.Drawing.Point(75, 20)
	$textbox71.Margin = '0, 0, 0, 0'
	$textbox71.Name = 'textbox71'
	$textbox71.ReadOnly = $True
	$textbox71.RightToLeft = 'No'
	$textbox71.Size = New-Object System.Drawing.Size(80, 16)
	$textbox71.TabIndex = 0
	$textbox71.Text = '-'
	$textbox71.TextAlign = 'Right'
	#
	# textbox72
	#
	$textbox72.BackColor = [System.Drawing.Color]::Black 
	$textbox72.BorderStyle = 'None'
	$textbox72.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox72.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox72.Location = New-Object System.Drawing.Point(75, 79)
	$textbox72.Margin = '0, 0, 0, 0'
	$textbox72.Name = 'textbox72'
	$textbox72.ReadOnly = $True
	$textbox72.RightToLeft = 'No'
	$textbox72.Size = New-Object System.Drawing.Size(80, 16)
	$textbox72.TabIndex = 2
	$textbox72.Text = '-'
	$textbox72.TextAlign = 'Right'
	#
	# groupbox42
	#
	$groupbox42.Controls.Add($textbox165)
	$groupbox42.Controls.Add($textbox166)
	$groupbox42.Controls.Add($textbox167)
	$groupbox42.Controls.Add($label1013020)
	$groupbox42.Controls.Add($label1013021)
	$groupbox42.Controls.Add($label1013022)
	$groupbox42.Controls.Add($textbox168)
	$groupbox42.Controls.Add($textbox169)
	$groupbox42.Controls.Add($textbox170)
	$groupbox42.BackColor = [System.Drawing.Color]::Black 
	$groupbox42.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox42.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox42.Location = New-Object System.Drawing.Point(282, 141)
	$groupbox42.Margin = '4, 3, 4, 3'
	$groupbox42.Name = 'groupbox42'
	$groupbox42.Padding = '4, 3, 4, 3'
	$groupbox42.RightToLeft = 'Yes'
	$groupbox42.Size = New-Object System.Drawing.Size(349, 87)
	$groupbox42.TabIndex = 62
	$groupbox42.TabStop = $False
	$groupbox42.Text = 'GLOBAL COORDINATES'
	#
	# textbox165
	#
	$textbox165.BackColor = [System.Drawing.Color]::Black 
	$textbox165.BorderStyle = 'None'
	$textbox165.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox165.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox165.Location = New-Object System.Drawing.Point(184, 40)
	$textbox165.Margin = '0, 0, 0, 0'
	$textbox165.Name = 'textbox165'
	$textbox165.ReadOnly = $True
	$textbox165.RightToLeft = 'No'
	$textbox165.Size = New-Object System.Drawing.Size(150, 16)
	$textbox165.TabIndex = 13
	$textbox165.Text = '-'
	$textbox165.TextAlign = 'Right'
	#
	# textbox166
	#
	$textbox166.BackColor = [System.Drawing.Color]::Black 
	$textbox166.BorderStyle = 'None'
	$textbox166.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox166.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox166.Location = New-Object System.Drawing.Point(184, 20)
	$textbox166.Margin = '0, 0, 0, 0'
	$textbox166.Name = 'textbox166'
	$textbox166.ReadOnly = $True
	$textbox166.RightToLeft = 'No'
	$textbox166.Size = New-Object System.Drawing.Size(150, 16)
	$textbox166.TabIndex = 12
	$textbox166.Text = '-'
	$textbox166.TextAlign = 'Right'
	#
	# textbox167
	#
	$textbox167.BackColor = [System.Drawing.Color]::Black 
	$textbox167.BorderStyle = 'None'
	$textbox167.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox167.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox167.Location = New-Object System.Drawing.Point(184, 60)
	$textbox167.Margin = '0, 0, 0, 0'
	$textbox167.Name = 'textbox167'
	$textbox167.ReadOnly = $True
	$textbox167.RightToLeft = 'No'
	$textbox167.Size = New-Object System.Drawing.Size(150, 16)
	$textbox167.TabIndex = 14
	$textbox167.Text = '-'
	$textbox167.TextAlign = 'Right'
	#
	# label1013020
	#
	$label1013020.AutoSize = $True
	$label1013020.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013020.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013020.Location = New-Object System.Drawing.Point(15, 60)
	$label1013020.Margin = '4, 0, 4, 0'
	$label1013020.Name = 'label1013020'
	$label1013020.RightToLeft = 'No'
	$label1013020.Size = New-Object System.Drawing.Size(15, 16)
	$label1013020.TabIndex = 11
	$label1013020.Text = 'Z'
	#
	# label1013021
	#
	$label1013021.AutoSize = $True
	$label1013021.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013021.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013021.Location = New-Object System.Drawing.Point(15, 40)
	$label1013021.Margin = '4, 0, 4, 0'
	$label1013021.Name = 'label1013021'
	$label1013021.RightToLeft = 'No'
	$label1013021.Size = New-Object System.Drawing.Size(15, 16)
	$label1013021.TabIndex = 10
	$label1013021.Text = 'Y'
	#
	# label1013022
	#
	$label1013022.AutoSize = $True
	$label1013022.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013022.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013022.Location = New-Object System.Drawing.Point(15, 20)
	$label1013022.Margin = '4, 0, 4, 0'
	$label1013022.Name = 'label1013022'
	$label1013022.RightToLeft = 'No'
	$label1013022.Size = New-Object System.Drawing.Size(15, 16)
	$label1013022.TabIndex = 9
	$label1013022.Text = 'X'
	#
	# textbox168
	#
	$textbox168.BackColor = [System.Drawing.Color]::Black 
	$textbox168.BorderStyle = 'None'
	$textbox168.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox168.ForeColor = [System.Drawing.Color]::Gray 
	$textbox168.Location = New-Object System.Drawing.Point(34, 40)
	$textbox168.Margin = '0, 0, 0, 0'
	$textbox168.Name = 'textbox168'
	$textbox168.ReadOnly = $True
	$textbox168.RightToLeft = 'No'
	$textbox168.Size = New-Object System.Drawing.Size(145, 16)
	$textbox168.TabIndex = 1
	$textbox168.Text = '-'
	$textbox168.TextAlign = 'Right'
	#
	# textbox169
	#
	$textbox169.BackColor = [System.Drawing.Color]::Black 
	$textbox169.BorderStyle = 'None'
	$textbox169.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox169.ForeColor = [System.Drawing.Color]::FromArgb(255, 120, 120, 120)
	$textbox169.Location = New-Object System.Drawing.Point(34, 20)
	$textbox169.Margin = '0, 0, 0, 0'
	$textbox169.Name = 'textbox169'
	$textbox169.ReadOnly = $True
	$textbox169.RightToLeft = 'No'
	$textbox169.Size = New-Object System.Drawing.Size(145, 16)
	$textbox169.TabIndex = 0
	$textbox169.Text = '-'
	$textbox169.TextAlign = 'Right'
	#
	# textbox170
	#
	$textbox170.BackColor = [System.Drawing.Color]::Black 
	$textbox170.BorderStyle = 'None'
	$textbox170.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox170.ForeColor = [System.Drawing.Color]::Gray 
	$textbox170.Location = New-Object System.Drawing.Point(33, 60)
	$textbox170.Margin = '0, 0, 0, 0'
	$textbox170.Name = 'textbox170'
	$textbox170.ReadOnly = $True
	$textbox170.RightToLeft = 'No'
	$textbox170.Size = New-Object System.Drawing.Size(145, 16)
	$textbox170.TabIndex = 2
	$textbox170.Text = '-'
	$textbox170.TextAlign = 'Right'
	#
	# groupbox41
	#
	$groupbox41.Controls.Add($textbox159)
	$groupbox41.Controls.Add($textbox193)
	$groupbox41.Controls.Add($textbox160)
	$groupbox41.Controls.Add($textbox194)
	$groupbox41.Controls.Add($textbox161)
	$groupbox41.Controls.Add($textbox191)
	$groupbox41.Controls.Add($label1013017)
	$groupbox41.Controls.Add($label1013018)
	$groupbox41.Controls.Add($label1013019)
	$groupbox41.Controls.Add($textbox190)
	$groupbox41.Controls.Add($textbox192)
	$groupbox41.Controls.Add($textbox162)
	$groupbox41.Controls.Add($textbox163)
	$groupbox41.Controls.Add($textbox164)
	$groupbox41.Controls.Add($textbox189)
	$groupbox41.BackColor = [System.Drawing.Color]::Black 
	$groupbox41.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox41.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox41.Location = New-Object System.Drawing.Point(282, 236)
	$groupbox41.Margin = '4, 3, 4, 3'
	$groupbox41.Name = 'groupbox41'
	$groupbox41.Padding = '4, 3, 4, 3'
	$groupbox41.RightToLeft = 'Yes'
	$groupbox41.Size = New-Object System.Drawing.Size(349, 87)
	$groupbox41.TabIndex = 61
	$groupbox41.TabStop = $False
	$groupbox41.Text = 'LOCAL COORDINATES'
	#
	# textbox159
	#
	$textbox159.BackColor = [System.Drawing.Color]::Black 
	$textbox159.BorderStyle = 'None'
	$textbox159.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox159.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox159.Location = New-Object System.Drawing.Point(133, 63)
	$textbox159.Margin = '0, 0, 0, 0'
	$textbox159.Name = 'textbox159'
	$textbox159.ReadOnly = $True
	$textbox159.RightToLeft = 'No'
	$textbox159.Size = New-Object System.Drawing.Size(84, 16)
	$textbox159.TabIndex = 24
	$textbox159.Text = '-'
	$textbox159.TextAlign = 'Right'
	#
	# textbox193
	#
	$textbox193.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox193.BorderStyle = 'None'
	$textbox193.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox193.ForeColor = [System.Drawing.Color]::FromArgb(255, 250, 50, 50)
	$textbox193.Location = New-Object System.Drawing.Point(297, 63)
	$textbox193.Margin = '0, 0, 0, 0'
	$textbox193.Name = 'textbox193'
	$textbox193.ReadOnly = $True
	$textbox193.RightToLeft = 'No'
	$textbox193.Size = New-Object System.Drawing.Size(37, 16)
	$textbox193.TabIndex = 35
	$textbox193.Text = '-OM-2'
	$textbox193.TextAlign = 'Right'
	#
	# textbox160
	#
	$textbox160.BackColor = [System.Drawing.Color]::Black 
	$textbox160.BorderStyle = 'None'
	$textbox160.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox160.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox160.Location = New-Object System.Drawing.Point(133, 43)
	$textbox160.Margin = '0, 0, 0, 0'
	$textbox160.Name = 'textbox160'
	$textbox160.ReadOnly = $True
	$textbox160.RightToLeft = 'No'
	$textbox160.Size = New-Object System.Drawing.Size(84, 16)
	$textbox160.TabIndex = 23
	$textbox160.Text = '-'
	$textbox160.TextAlign = 'Right'
	#
	# textbox194
	#
	$textbox194.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox194.BorderStyle = 'None'
	$textbox194.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox194.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox194.Location = New-Object System.Drawing.Point(239, 63)
	$textbox194.Margin = '0, 0, 0, 0'
	$textbox194.Name = 'textbox194'
	$textbox194.ReadOnly = $True
	$textbox194.RightToLeft = 'No'
	$textbox194.Size = New-Object System.Drawing.Size(45, 16)
	$textbox194.TabIndex = 34
	$textbox194.Text = '+OM-1'
	$textbox194.TextAlign = 'Right'
	#
	# textbox161
	#
	$textbox161.BackColor = [System.Drawing.Color]::Black 
	$textbox161.BorderStyle = 'None'
	$textbox161.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox161.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox161.Location = New-Object System.Drawing.Point(133, 23)
	$textbox161.Margin = '0, 0, 0, 0'
	$textbox161.Name = 'textbox161'
	$textbox161.ReadOnly = $True
	$textbox161.RightToLeft = 'No'
	$textbox161.Size = New-Object System.Drawing.Size(84, 16)
	$textbox161.TabIndex = 22
	$textbox161.Text = '-'
	$textbox161.TextAlign = 'Right'
	#
	# textbox191
	#
	$textbox191.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox191.BorderStyle = 'None'
	$textbox191.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox191.ForeColor = [System.Drawing.Color]::FromArgb(255, 250, 50, 50)
	$textbox191.Location = New-Object System.Drawing.Point(297, 43)
	$textbox191.Margin = '0, 0, 0, 0'
	$textbox191.Name = 'textbox191'
	$textbox191.ReadOnly = $True
	$textbox191.RightToLeft = 'No'
	$textbox191.Size = New-Object System.Drawing.Size(37, 16)
	$textbox191.TabIndex = 31
	$textbox191.Text = '-OM-4'
	$textbox191.TextAlign = 'Right'
	#
	# label1013017
	#
	$label1013017.AutoSize = $True
	$label1013017.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013017.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013017.Location = New-Object System.Drawing.Point(15, 63)
	$label1013017.Margin = '4, 0, 4, 0'
	$label1013017.Name = 'label1013017'
	$label1013017.RightToLeft = 'No'
	$label1013017.Size = New-Object System.Drawing.Size(15, 16)
	$label1013017.TabIndex = 11
	$label1013017.Text = 'Z'
	#
	# label1013018
	#
	$label1013018.AutoSize = $True
	$label1013018.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013018.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013018.Location = New-Object System.Drawing.Point(15, 43)
	$label1013018.Margin = '4, 0, 4, 0'
	$label1013018.Name = 'label1013018'
	$label1013018.RightToLeft = 'No'
	$label1013018.Size = New-Object System.Drawing.Size(15, 16)
	$label1013018.TabIndex = 10
	$label1013018.Text = 'Y'
	#
	# label1013019
	#
	$label1013019.AutoSize = $True
	$label1013019.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013019.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013019.Location = New-Object System.Drawing.Point(15, 23)
	$label1013019.Margin = '4, 0, 4, 0'
	$label1013019.Name = 'label1013019'
	$label1013019.RightToLeft = 'No'
	$label1013019.Size = New-Object System.Drawing.Size(15, 16)
	$label1013019.TabIndex = 9
	$label1013019.Text = 'X'
	#
	# textbox190
	#
	$textbox190.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox190.BorderStyle = 'None'
	$textbox190.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox190.ForeColor = [System.Drawing.Color]::FromArgb(255, 250, 50, 50)
	$textbox190.Location = New-Object System.Drawing.Point(297, 23)
	$textbox190.Margin = '0, 0, 0, 0'
	$textbox190.Name = 'textbox190'
	$textbox190.ReadOnly = $True
	$textbox190.RightToLeft = 'No'
	$textbox190.Size = New-Object System.Drawing.Size(37, 16)
	$textbox190.TabIndex = 27
	$textbox190.Text = '-OM-6'
	$textbox190.TextAlign = 'Right'
	#
	# textbox192
	#
	$textbox192.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox192.BorderStyle = 'None'
	$textbox192.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox192.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox192.Location = New-Object System.Drawing.Point(239, 43)
	$textbox192.Margin = '0, 0, 0, 0'
	$textbox192.Name = 'textbox192'
	$textbox192.ReadOnly = $True
	$textbox192.RightToLeft = 'No'
	$textbox192.Size = New-Object System.Drawing.Size(45, 16)
	$textbox192.TabIndex = 30
	$textbox192.Text = '+OM-3'
	$textbox192.TextAlign = 'Right'
	#
	# textbox162
	#
	$textbox162.BackColor = [System.Drawing.Color]::Black 
	$textbox162.BorderStyle = 'None'
	$textbox162.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox162.ForeColor = [System.Drawing.Color]::Gray 
	$textbox162.Location = New-Object System.Drawing.Point(35, 63)
	$textbox162.Margin = '0, 0, 0, 0'
	$textbox162.Name = 'textbox162'
	$textbox162.ReadOnly = $True
	$textbox162.RightToLeft = 'No'
	$textbox162.Size = New-Object System.Drawing.Size(84, 16)
	$textbox162.TabIndex = 18
	$textbox162.Text = '-'
	$textbox162.TextAlign = 'Right'
	#
	# textbox163
	#
	$textbox163.BackColor = [System.Drawing.Color]::Black 
	$textbox163.BorderStyle = 'None'
	$textbox163.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox163.ForeColor = [System.Drawing.Color]::Gray 
	$textbox163.Location = New-Object System.Drawing.Point(35, 43)
	$textbox163.Margin = '0, 0, 0, 0'
	$textbox163.Name = 'textbox163'
	$textbox163.ReadOnly = $True
	$textbox163.RightToLeft = 'No'
	$textbox163.Size = New-Object System.Drawing.Size(84, 16)
	$textbox163.TabIndex = 14
	$textbox163.Text = '-'
	$textbox163.TextAlign = 'Right'
	#
	# textbox164
	#
	$textbox164.BackColor = [System.Drawing.Color]::Black 
	$textbox164.BorderStyle = 'None'
	$textbox164.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox164.ForeColor = [System.Drawing.Color]::Gray 
	$textbox164.Location = New-Object System.Drawing.Point(35, 23)
	$textbox164.Margin = '0, 0, 0, 0'
	$textbox164.Name = 'textbox164'
	$textbox164.ReadOnly = $True
	$textbox164.RightToLeft = 'No'
	$textbox164.Size = New-Object System.Drawing.Size(84, 16)
	$textbox164.TabIndex = 13
	$textbox164.Text = '-'
	$textbox164.TextAlign = 'Right'
	#
	# textbox189
	#
	$textbox189.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox189.BorderStyle = 'None'
	$textbox189.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox189.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox189.Location = New-Object System.Drawing.Point(239, 23)
	$textbox189.Margin = '0, 0, 0, 0'
	$textbox189.Name = 'textbox189'
	$textbox189.ReadOnly = $True
	$textbox189.RightToLeft = 'No'
	$textbox189.Size = New-Object System.Drawing.Size(45, 16)
	$textbox189.TabIndex = 26
	$textbox189.Text = '+OM-5'
	$textbox189.TextAlign = 'Right'
	#
	# groupbox32
	#
	$groupbox32.Controls.Add($textbox216)
	$groupbox32.Controls.Add($textbox215)
	$groupbox32.Controls.Add($textbox214)
	$groupbox32.Controls.Add($textbox180)
	$groupbox32.Controls.Add($textbox181)
	$groupbox32.Controls.Add($textbox182)
	$groupbox32.Controls.Add($textbox177)
	$groupbox32.Controls.Add($textbox178)
	$groupbox32.Controls.Add($textbox179)
	$groupbox32.Controls.Add($textbox174)
	$groupbox32.Controls.Add($textbox175)
	$groupbox32.Controls.Add($textbox176)
	$groupbox32.Controls.Add($textbox173)
	$groupbox32.Controls.Add($textbox172)
	$groupbox32.Controls.Add($textbox171)
	$groupbox32.Controls.Add($labelFinalDISTANCE)
	$groupbox32.Controls.Add($labelCurrentDistance)
	$groupbox32.Controls.Add($labelQuantumMarker)
	$groupbox32.BackColor = [System.Drawing.Color]::Black 
	$groupbox32.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox32.ForeColor = [System.Drawing.Color]::Brown 
	$groupbox32.Location = New-Object System.Drawing.Point(597, 319)
	$groupbox32.Margin = '4, 3, 4, 3'
	$groupbox32.Name = 'groupbox32'
	$groupbox32.Padding = '4, 3, 4, 3'
	$groupbox32.RightToLeft = 'Yes'
	$groupbox32.Size = New-Object System.Drawing.Size(517, 165)
	$groupbox32.TabIndex = 51
	$groupbox32.TabStop = $False
	$groupbox32.Text = 'QUANTUM DISTANCES'
	#
	# textbox216
	#
	$textbox216.BackColor = [System.Drawing.Color]::Black 
	$textbox216.BorderStyle = 'None'
	$textbox216.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox216.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox216.Location = New-Object System.Drawing.Point(339, 76)
	$textbox216.Margin = '0, 0, 0, 0'
	$textbox216.Name = 'textbox216'
	$textbox216.ReadOnly = $True
	$textbox216.RightToLeft = 'No'
	$textbox216.Size = New-Object System.Drawing.Size(137, 16)
	$textbox216.TabIndex = 73
	$textbox216.Text = '-'
	$textbox216.TextAlign = 'Right'
	#
	# textbox215
	#
	$textbox215.BackColor = [System.Drawing.Color]::Black 
	$textbox215.BorderStyle = 'None'
	$textbox215.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox215.ForeColor = [System.Drawing.Color]::Gray 
	$textbox215.Location = New-Object System.Drawing.Point(183, 76)
	$textbox215.Margin = '0, 0, 0, 0'
	$textbox215.Name = 'textbox215'
	$textbox215.ReadOnly = $True
	$textbox215.RightToLeft = 'No'
	$textbox215.Size = New-Object System.Drawing.Size(137, 16)
	$textbox215.TabIndex = 72
	$textbox215.Text = '-'
	$textbox215.TextAlign = 'Right'
	#
	# textbox214
	#
	$textbox214.BackColor = [System.Drawing.Color]::Black 
	$textbox214.BorderStyle = 'None'
	$textbox214.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox214.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox214.Location = New-Object System.Drawing.Point(18, 76)
	$textbox214.Margin = '0, 0, 0, 0'
	$textbox214.Name = 'textbox214'
	$textbox214.ReadOnly = $True
	$textbox214.RightToLeft = 'No'
	$textbox214.Size = New-Object System.Drawing.Size(137, 16)
	$textbox214.TabIndex = 71
	$textbox214.Text = '-'
	#
	# textbox180
	#
	$textbox180.BackColor = [System.Drawing.Color]::Black 
	$textbox180.BorderStyle = 'None'
	$textbox180.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox180.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox180.Location = New-Object System.Drawing.Point(339, 139)
	$textbox180.Margin = '0, 0, 0, 0'
	$textbox180.Name = 'textbox180'
	$textbox180.ReadOnly = $True
	$textbox180.RightToLeft = 'No'
	$textbox180.Size = New-Object System.Drawing.Size(137, 16)
	$textbox180.TabIndex = 39
	$textbox180.Text = '-'
	$textbox180.TextAlign = 'Right'
	#
	# textbox181
	#
	$textbox181.BackColor = [System.Drawing.Color]::Black 
	$textbox181.BorderStyle = 'None'
	$textbox181.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox181.ForeColor = [System.Drawing.Color]::Gray 
	$textbox181.Location = New-Object System.Drawing.Point(183, 139)
	$textbox181.Margin = '0, 0, 0, 0'
	$textbox181.Name = 'textbox181'
	$textbox181.ReadOnly = $True
	$textbox181.RightToLeft = 'No'
	$textbox181.Size = New-Object System.Drawing.Size(137, 16)
	$textbox181.TabIndex = 38
	$textbox181.Text = '-'
	$textbox181.TextAlign = 'Right'
	#
	# textbox182
	#
	$textbox182.BackColor = [System.Drawing.Color]::Black 
	$textbox182.BorderStyle = 'None'
	$textbox182.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox182.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox182.Location = New-Object System.Drawing.Point(18, 139)
	$textbox182.Margin = '0, 0, 0, 0'
	$textbox182.Name = 'textbox182'
	$textbox182.ReadOnly = $True
	$textbox182.RightToLeft = 'No'
	$textbox182.Size = New-Object System.Drawing.Size(137, 16)
	$textbox182.TabIndex = 37
	$textbox182.Text = '-'
	#
	# textbox177
	#
	$textbox177.BackColor = [System.Drawing.Color]::Black 
	$textbox177.BorderStyle = 'None'
	$textbox177.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox177.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox177.Location = New-Object System.Drawing.Point(339, 118)
	$textbox177.Margin = '0, 0, 0, 0'
	$textbox177.Name = 'textbox177'
	$textbox177.ReadOnly = $True
	$textbox177.RightToLeft = 'No'
	$textbox177.Size = New-Object System.Drawing.Size(137, 16)
	$textbox177.TabIndex = 36
	$textbox177.Text = '-'
	$textbox177.TextAlign = 'Right'
	#
	# textbox178
	#
	$textbox178.BackColor = [System.Drawing.Color]::Black 
	$textbox178.BorderStyle = 'None'
	$textbox178.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox178.ForeColor = [System.Drawing.Color]::Gray 
	$textbox178.Location = New-Object System.Drawing.Point(183, 118)
	$textbox178.Margin = '0, 0, 0, 0'
	$textbox178.Name = 'textbox178'
	$textbox178.ReadOnly = $True
	$textbox178.RightToLeft = 'No'
	$textbox178.Size = New-Object System.Drawing.Size(137, 16)
	$textbox178.TabIndex = 35
	$textbox178.Text = '-'
	$textbox178.TextAlign = 'Right'
	#
	# textbox179
	#
	$textbox179.BackColor = [System.Drawing.Color]::Black 
	$textbox179.BorderStyle = 'None'
	$textbox179.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox179.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox179.Location = New-Object System.Drawing.Point(18, 118)
	$textbox179.Margin = '0, 0, 0, 0'
	$textbox179.Name = 'textbox179'
	$textbox179.ReadOnly = $True
	$textbox179.RightToLeft = 'No'
	$textbox179.Size = New-Object System.Drawing.Size(137, 16)
	$textbox179.TabIndex = 34
	$textbox179.Text = '-'
	#
	# textbox174
	#
	$textbox174.BackColor = [System.Drawing.Color]::Black 
	$textbox174.BorderStyle = 'None'
	$textbox174.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox174.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox174.Location = New-Object System.Drawing.Point(339, 97)
	$textbox174.Margin = '0, 0, 0, 0'
	$textbox174.Name = 'textbox174'
	$textbox174.ReadOnly = $True
	$textbox174.RightToLeft = 'No'
	$textbox174.Size = New-Object System.Drawing.Size(137, 16)
	$textbox174.TabIndex = 33
	$textbox174.Text = '-'
	$textbox174.TextAlign = 'Right'
	#
	# textbox175
	#
	$textbox175.BackColor = [System.Drawing.Color]::Black 
	$textbox175.BorderStyle = 'None'
	$textbox175.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox175.ForeColor = [System.Drawing.Color]::Gray 
	$textbox175.Location = New-Object System.Drawing.Point(183, 97)
	$textbox175.Margin = '0, 0, 0, 0'
	$textbox175.Name = 'textbox175'
	$textbox175.ReadOnly = $True
	$textbox175.RightToLeft = 'No'
	$textbox175.Size = New-Object System.Drawing.Size(137, 16)
	$textbox175.TabIndex = 32
	$textbox175.Text = '-'
	$textbox175.TextAlign = 'Right'
	#
	# textbox176
	#
	$textbox176.BackColor = [System.Drawing.Color]::Black 
	$textbox176.BorderStyle = 'None'
	$textbox176.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox176.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox176.Location = New-Object System.Drawing.Point(18, 97)
	$textbox176.Margin = '0, 0, 0, 0'
	$textbox176.Name = 'textbox176'
	$textbox176.ReadOnly = $True
	$textbox176.RightToLeft = 'No'
	$textbox176.Size = New-Object System.Drawing.Size(137, 16)
	$textbox176.TabIndex = 31
	$textbox176.Text = '-'
	#
	# textbox173
	#
	$textbox173.BackColor = [System.Drawing.Color]::Black 
	$textbox173.BorderStyle = 'None'
	$textbox173.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox173.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox173.Location = New-Object System.Drawing.Point(339, 55)
	$textbox173.Margin = '0, 0, 0, 0'
	$textbox173.Name = 'textbox173'
	$textbox173.ReadOnly = $True
	$textbox173.RightToLeft = 'No'
	$textbox173.Size = New-Object System.Drawing.Size(137, 16)
	$textbox173.TabIndex = 30
	$textbox173.Text = '-'
	$textbox173.TextAlign = 'Right'
	#
	# textbox172
	#
	$textbox172.BackColor = [System.Drawing.Color]::Black 
	$textbox172.BorderStyle = 'None'
	$textbox172.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox172.ForeColor = [System.Drawing.Color]::Gray 
	$textbox172.Location = New-Object System.Drawing.Point(183, 55)
	$textbox172.Margin = '0, 0, 0, 0'
	$textbox172.Name = 'textbox172'
	$textbox172.ReadOnly = $True
	$textbox172.RightToLeft = 'No'
	$textbox172.Size = New-Object System.Drawing.Size(137, 16)
	$textbox172.TabIndex = 29
	$textbox172.Text = '-'
	$textbox172.TextAlign = 'Right'
	#
	# textbox171
	#
	$textbox171.BackColor = [System.Drawing.Color]::Black 
	$textbox171.BorderStyle = 'None'
	$textbox171.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox171.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox171.Location = New-Object System.Drawing.Point(18, 55)
	$textbox171.Margin = '0, 0, 0, 0'
	$textbox171.Name = 'textbox171'
	$textbox171.ReadOnly = $True
	$textbox171.RightToLeft = 'No'
	$textbox171.Size = New-Object System.Drawing.Size(137, 16)
	$textbox171.TabIndex = 26
	$textbox171.Text = '-'
	#
	# labelFinalDISTANCE
	#
	$labelFinalDISTANCE.AutoSize = $True
	$labelFinalDISTANCE.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelFinalDISTANCE.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelFinalDISTANCE.Location = New-Object System.Drawing.Point(373, 29)
	$labelFinalDISTANCE.Margin = '4, 0, 4, 0'
	$labelFinalDISTANCE.Name = 'labelFinalDISTANCE'
	$labelFinalDISTANCE.RightToLeft = 'No'
	$labelFinalDISTANCE.Size = New-Object System.Drawing.Size(107, 16)
	$labelFinalDISTANCE.TabIndex = 28
	$labelFinalDISTANCE.Text = 'Final DISTANCE'
	#
	# labelCurrentDistance
	#
	$labelCurrentDistance.AutoSize = $True
	$labelCurrentDistance.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelCurrentDistance.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelCurrentDistance.Location = New-Object System.Drawing.Point(209, 29)
	$labelCurrentDistance.Margin = '4, 0, 4, 0'
	$labelCurrentDistance.Name = 'labelCurrentDistance'
	$labelCurrentDistance.RightToLeft = 'No'
	$labelCurrentDistance.Size = New-Object System.Drawing.Size(127, 16)
	$labelCurrentDistance.TabIndex = 27
	$labelCurrentDistance.Text = 'Current distance'
	$labelCurrentDistance.TextAlign = 'MiddleRight'
	#
	# labelQuantumMarker
	#
	$labelQuantumMarker.AutoSize = $True
	$labelQuantumMarker.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelQuantumMarker.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelQuantumMarker.Location = New-Object System.Drawing.Point(15, 29)
	$labelQuantumMarker.Margin = '4, 0, 4, 0'
	$labelQuantumMarker.Name = 'labelQuantumMarker'
	$labelQuantumMarker.RightToLeft = 'No'
	$labelQuantumMarker.Size = New-Object System.Drawing.Size(115, 16)
	$labelQuantumMarker.TabIndex = 26
	$labelQuantumMarker.Text = 'Quantum marker'
	#
	# groupbox31
	#
	$groupbox31.Controls.Add($textbox89)
	$groupbox31.Controls.Add($textbox88)
	$groupbox31.Controls.Add($textbox87)
	$groupbox31.Controls.Add($labelSeconds)
	$groupbox31.Controls.Add($textbox86)
	$groupbox31.Controls.Add($labelMinutes)
	$groupbox31.Controls.Add($labelHours)
	$groupbox31.Controls.Add($labelDays)
	$groupbox31.BackColor = [System.Drawing.Color]::Black 
	$groupbox31.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox31.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox31.Location = New-Object System.Drawing.Point(36, 24)
	$groupbox31.Margin = '4, 3, 4, 3'
	$groupbox31.Name = 'groupbox31'
	$groupbox31.Padding = '4, 3, 4, 3'
	$groupbox31.RightToLeft = 'Yes'
	$groupbox31.Size = New-Object System.Drawing.Size(119, 108)
	$groupbox31.TabIndex = 51
	$groupbox31.TabStop = $False
	$groupbox31.Text = 'ETA'
	#
	# textbox89
	#
	$textbox89.BackColor = [System.Drawing.Color]::Black 
	$textbox89.BorderStyle = 'None'
	$textbox89.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox89.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox89.Location = New-Object System.Drawing.Point(1, 79)
	$textbox89.Margin = '0, 0, 0, 0'
	$textbox89.Name = 'textbox89'
	$textbox89.ReadOnly = $True
	$textbox89.RightToLeft = 'No'
	$textbox89.Size = New-Object System.Drawing.Size(34, 16)
	$textbox89.TabIndex = 30
	$textbox89.Text = '-'
	$textbox89.TextAlign = 'Right'
	#
	# textbox88
	#
	$textbox88.BackColor = [System.Drawing.Color]::Black 
	$textbox88.BorderStyle = 'None'
	$textbox88.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox88.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox88.Location = New-Object System.Drawing.Point(1, 60)
	$textbox88.Margin = '0, 0, 0, 0'
	$textbox88.Name = 'textbox88'
	$textbox88.ReadOnly = $True
	$textbox88.RightToLeft = 'No'
	$textbox88.Size = New-Object System.Drawing.Size(34, 16)
	$textbox88.TabIndex = 29
	$textbox88.Text = '-'
	$textbox88.TextAlign = 'Right'
	#
	# textbox87
	#
	$textbox87.BackColor = [System.Drawing.Color]::Black 
	$textbox87.BorderStyle = 'None'
	$textbox87.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox87.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox87.Location = New-Object System.Drawing.Point(1, 40)
	$textbox87.Margin = '0, 0, 0, 0'
	$textbox87.Name = 'textbox87'
	$textbox87.ReadOnly = $True
	$textbox87.RightToLeft = 'No'
	$textbox87.Size = New-Object System.Drawing.Size(34, 16)
	$textbox87.TabIndex = 28
	$textbox87.Text = '-'
	$textbox87.TextAlign = 'Right'
	#
	# labelSeconds
	#
	$labelSeconds.AutoSize = $True
	$labelSeconds.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSeconds.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelSeconds.Location = New-Object System.Drawing.Point(39, 79)
	$labelSeconds.Margin = '4, 0, 4, 0'
	$labelSeconds.Name = 'labelSeconds'
	$labelSeconds.RightToLeft = 'No'
	$labelSeconds.Size = New-Object System.Drawing.Size(63, 16)
	$labelSeconds.TabIndex = 27
	$labelSeconds.Text = 'Seconds'
	#
	# textbox86
	#
	$textbox86.BackColor = [System.Drawing.Color]::Black 
	$textbox86.BorderStyle = 'None'
	$textbox86.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox86.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox86.Location = New-Object System.Drawing.Point(1, 20)
	$textbox86.Margin = '0, 0, 0, 0'
	$textbox86.Name = 'textbox86'
	$textbox86.ReadOnly = $True
	$textbox86.RightToLeft = 'No'
	$textbox86.Size = New-Object System.Drawing.Size(34, 16)
	$textbox86.TabIndex = 26
	$textbox86.Text = '-'
	$textbox86.TextAlign = 'Right'
	#
	# labelMinutes
	#
	$labelMinutes.AutoSize = $True
	$labelMinutes.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelMinutes.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelMinutes.Location = New-Object System.Drawing.Point(39, 60)
	$labelMinutes.Margin = '4, 0, 4, 0'
	$labelMinutes.Name = 'labelMinutes'
	$labelMinutes.RightToLeft = 'No'
	$labelMinutes.Size = New-Object System.Drawing.Size(59, 16)
	$labelMinutes.TabIndex = 11
	$labelMinutes.Text = 'Minutes'
	#
	# labelHours
	#
	$labelHours.AutoSize = $True
	$labelHours.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelHours.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelHours.Location = New-Object System.Drawing.Point(39, 40)
	$labelHours.Margin = '4, 0, 4, 0'
	$labelHours.Name = 'labelHours'
	$labelHours.RightToLeft = 'No'
	$labelHours.Size = New-Object System.Drawing.Size(47, 16)
	$labelHours.TabIndex = 10
	$labelHours.Text = 'Hours'
	#
	# labelDays
	#
	$labelDays.AutoSize = $True
	$labelDays.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelDays.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelDays.Location = New-Object System.Drawing.Point(39, 20)
	$labelDays.Margin = '4, 0, 4, 0'
	$labelDays.Name = 'labelDays'
	$labelDays.RightToLeft = 'No'
	$labelDays.Size = New-Object System.Drawing.Size(39, 16)
	$labelDays.TabIndex = 9
	$labelDays.Text = 'Days'
	#
	# groupbox40
	#
	$groupbox40.Controls.Add($label1013050)
	$groupbox40.Controls.Add($label1013049)
	$groupbox40.Controls.Add($label1013048)
	$groupbox40.Controls.Add($label1013047)
	$groupbox40.Controls.Add($label1013046)
	$groupbox40.Controls.Add($label1013045)
	$groupbox40.Controls.Add($textbox147)
	$groupbox40.Controls.Add($textbox148)
	$groupbox40.Controls.Add($textbox149)
	$groupbox40.Controls.Add($textbox150)
	$groupbox40.Controls.Add($textbox151)
	$groupbox40.Controls.Add($textbox152)
	$groupbox40.Controls.Add($textbox153)
	$groupbox40.Controls.Add($textbox154)
	$groupbox40.Controls.Add($textbox155)
	$groupbox40.Controls.Add($textbox156)
	$groupbox40.Controls.Add($textbox157)
	$groupbox40.Controls.Add($textbox158)
	$groupbox40.BackColor = [System.Drawing.Color]::Black 
	$groupbox40.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox40.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox40.Location = New-Object System.Drawing.Point(36, 141)
	$groupbox40.Margin = '4, 3, 4, 3'
	$groupbox40.Name = 'groupbox40'
	$groupbox40.Padding = '4, 3, 4, 3'
	$groupbox40.RightToLeft = 'Yes'
	$groupbox40.Size = New-Object System.Drawing.Size(211, 182)
	$groupbox40.TabIndex = 60
	$groupbox40.TabStop = $False
	$groupbox40.Text = 'ORBITAL MARKER'
	#
	# label1013050
	#
	$label1013050.AutoSize = $True
	$label1013050.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013050.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013050.Location = New-Object System.Drawing.Point(19, 144)
	$label1013050.Margin = '4, 0, 4, 0'
	$label1013050.Name = 'label1013050'
	$label1013050.RightToLeft = 'No'
	$label1013050.Size = New-Object System.Drawing.Size(38, 16)
	$label1013050.TabIndex = 80
	$label1013050.Text = 'Om-6'
	#
	# label1013049
	#
	$label1013049.AutoSize = $True
	$label1013049.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013049.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013049.Location = New-Object System.Drawing.Point(19, 121)
	$label1013049.Margin = '4, 0, 4, 0'
	$label1013049.Name = 'label1013049'
	$label1013049.RightToLeft = 'No'
	$label1013049.Size = New-Object System.Drawing.Size(38, 16)
	$label1013049.TabIndex = 79
	$label1013049.Text = 'Om-5'
	#
	# label1013048
	#
	$label1013048.AutoSize = $True
	$label1013048.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013048.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013048.Location = New-Object System.Drawing.Point(19, 98)
	$label1013048.Margin = '4, 0, 4, 0'
	$label1013048.Name = 'label1013048'
	$label1013048.RightToLeft = 'No'
	$label1013048.Size = New-Object System.Drawing.Size(38, 16)
	$label1013048.TabIndex = 78
	$label1013048.Text = 'Om-4'
	#
	# label1013047
	#
	$label1013047.AutoSize = $True
	$label1013047.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013047.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013047.Location = New-Object System.Drawing.Point(19, 75)
	$label1013047.Margin = '4, 0, 4, 0'
	$label1013047.Name = 'label1013047'
	$label1013047.RightToLeft = 'No'
	$label1013047.Size = New-Object System.Drawing.Size(38, 16)
	$label1013047.TabIndex = 77
	$label1013047.Text = 'Om-3'
	#
	# label1013046
	#
	$label1013046.AutoSize = $True
	$label1013046.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013046.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013046.Location = New-Object System.Drawing.Point(19, 52)
	$label1013046.Margin = '4, 0, 4, 0'
	$label1013046.Name = 'label1013046'
	$label1013046.RightToLeft = 'No'
	$label1013046.Size = New-Object System.Drawing.Size(38, 16)
	$label1013046.TabIndex = 76
	$label1013046.Text = 'Om-2'
	#
	# label1013045
	#
	$label1013045.AutoSize = $True
	$label1013045.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013045.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013045.Location = New-Object System.Drawing.Point(19, 30)
	$label1013045.Margin = '4, 0, 4, 0'
	$label1013045.Name = 'label1013045'
	$label1013045.RightToLeft = 'No'
	$label1013045.Size = New-Object System.Drawing.Size(38, 16)
	$label1013045.TabIndex = 75
	$label1013045.Text = 'Om-1'
	#
	# textbox147
	#
	$textbox147.BackColor = [System.Drawing.Color]::Black 
	$textbox147.BorderStyle = 'None'
	$textbox147.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox147.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox147.Location = New-Object System.Drawing.Point(129, 144)
	$textbox147.Margin = '0, 0, 0, 0'
	$textbox147.Name = 'textbox147'
	$textbox147.ReadOnly = $True
	$textbox147.RightToLeft = 'No'
	$textbox147.Size = New-Object System.Drawing.Size(62, 16)
	$textbox147.TabIndex = 70
	$textbox147.Text = '-'
	$textbox147.TextAlign = 'Right'
	#
	# textbox148
	#
	$textbox148.BackColor = [System.Drawing.Color]::Black 
	$textbox148.BorderStyle = 'None'
	$textbox148.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox148.ForeColor = [System.Drawing.Color]::Gray 
	$textbox148.Location = New-Object System.Drawing.Point(60, 144)
	$textbox148.Margin = '0, 0, 0, 0'
	$textbox148.Name = 'textbox148'
	$textbox148.ReadOnly = $True
	$textbox148.RightToLeft = 'No'
	$textbox148.Size = New-Object System.Drawing.Size(62, 16)
	$textbox148.TabIndex = 68
	$textbox148.Text = '-'
	$textbox148.TextAlign = 'Right'
	#
	# textbox149
	#
	$textbox149.BackColor = [System.Drawing.Color]::Black 
	$textbox149.BorderStyle = 'None'
	$textbox149.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox149.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox149.Location = New-Object System.Drawing.Point(129, 121)
	$textbox149.Margin = '0, 0, 0, 0'
	$textbox149.Name = 'textbox149'
	$textbox149.ReadOnly = $True
	$textbox149.RightToLeft = 'No'
	$textbox149.Size = New-Object System.Drawing.Size(62, 16)
	$textbox149.TabIndex = 66
	$textbox149.Text = '-'
	$textbox149.TextAlign = 'Right'
	#
	# textbox150
	#
	$textbox150.BackColor = [System.Drawing.Color]::Black 
	$textbox150.BorderStyle = 'None'
	$textbox150.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox150.ForeColor = [System.Drawing.Color]::Gray 
	$textbox150.Location = New-Object System.Drawing.Point(60, 121)
	$textbox150.Margin = '0, 0, 0, 0'
	$textbox150.Name = 'textbox150'
	$textbox150.ReadOnly = $True
	$textbox150.RightToLeft = 'No'
	$textbox150.Size = New-Object System.Drawing.Size(62, 16)
	$textbox150.TabIndex = 64
	$textbox150.Text = '-'
	$textbox150.TextAlign = 'Right'
	#
	# textbox151
	#
	$textbox151.BackColor = [System.Drawing.Color]::Black 
	$textbox151.BorderStyle = 'None'
	$textbox151.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox151.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox151.Location = New-Object System.Drawing.Point(129, 98)
	$textbox151.Margin = '0, 0, 0, 0'
	$textbox151.Name = 'textbox151'
	$textbox151.ReadOnly = $True
	$textbox151.RightToLeft = 'No'
	$textbox151.Size = New-Object System.Drawing.Size(62, 16)
	$textbox151.TabIndex = 62
	$textbox151.Text = '-'
	$textbox151.TextAlign = 'Right'
	#
	# textbox152
	#
	$textbox152.BackColor = [System.Drawing.Color]::Black 
	$textbox152.BorderStyle = 'None'
	$textbox152.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox152.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox152.Location = New-Object System.Drawing.Point(129, 75)
	$textbox152.Margin = '0, 0, 0, 0'
	$textbox152.Name = 'textbox152'
	$textbox152.ReadOnly = $True
	$textbox152.RightToLeft = 'No'
	$textbox152.Size = New-Object System.Drawing.Size(62, 16)
	$textbox152.TabIndex = 30
	$textbox152.Text = '-'
	$textbox152.TextAlign = 'Right'
	#
	# textbox153
	#
	$textbox153.BackColor = [System.Drawing.Color]::Black 
	$textbox153.BorderStyle = 'None'
	$textbox153.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox153.ForeColor = [System.Drawing.Color]::Gray 
	$textbox153.Location = New-Object System.Drawing.Point(60, 98)
	$textbox153.Margin = '0, 0, 0, 0'
	$textbox153.Name = 'textbox153'
	$textbox153.ReadOnly = $True
	$textbox153.RightToLeft = 'No'
	$textbox153.Size = New-Object System.Drawing.Size(62, 16)
	$textbox153.TabIndex = 60
	$textbox153.Text = '-'
	$textbox153.TextAlign = 'Right'
	#
	# textbox154
	#
	$textbox154.BackColor = [System.Drawing.Color]::Black 
	$textbox154.BorderStyle = 'None'
	$textbox154.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox154.ForeColor = [System.Drawing.Color]::Gray 
	$textbox154.Location = New-Object System.Drawing.Point(60, 75)
	$textbox154.Margin = '0, 0, 0, 0'
	$textbox154.Name = 'textbox154'
	$textbox154.ReadOnly = $True
	$textbox154.RightToLeft = 'No'
	$textbox154.Size = New-Object System.Drawing.Size(62, 16)
	$textbox154.TabIndex = 28
	$textbox154.Text = '-'
	$textbox154.TextAlign = 'Right'
	#
	# textbox155
	#
	$textbox155.BackColor = [System.Drawing.Color]::Black 
	$textbox155.BorderStyle = 'None'
	$textbox155.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox155.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox155.Location = New-Object System.Drawing.Point(129, 51)
	$textbox155.Margin = '0, 0, 0, 0'
	$textbox155.Name = 'textbox155'
	$textbox155.ReadOnly = $True
	$textbox155.RightToLeft = 'No'
	$textbox155.Size = New-Object System.Drawing.Size(62, 16)
	$textbox155.TabIndex = 26
	$textbox155.Text = '-'
	$textbox155.TextAlign = 'Right'
	#
	# textbox156
	#
	$textbox156.BackColor = [System.Drawing.Color]::Black 
	$textbox156.BorderStyle = 'None'
	$textbox156.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox156.ForeColor = [System.Drawing.Color]::Gray 
	$textbox156.Location = New-Object System.Drawing.Point(60, 52)
	$textbox156.Margin = '0, 0, 0, 0'
	$textbox156.Name = 'textbox156'
	$textbox156.ReadOnly = $True
	$textbox156.RightToLeft = 'No'
	$textbox156.Size = New-Object System.Drawing.Size(62, 16)
	$textbox156.TabIndex = 24
	$textbox156.Text = '-'
	$textbox156.TextAlign = 'Right'
	#
	# textbox157
	#
	$textbox157.BackColor = [System.Drawing.Color]::Black 
	$textbox157.BorderStyle = 'None'
	$textbox157.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox157.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox157.Location = New-Object System.Drawing.Point(129, 30)
	$textbox157.Margin = '0, 0, 0, 0'
	$textbox157.Name = 'textbox157'
	$textbox157.ReadOnly = $True
	$textbox157.RightToLeft = 'No'
	$textbox157.Size = New-Object System.Drawing.Size(62, 16)
	$textbox157.TabIndex = 22
	$textbox157.Text = '-'
	$textbox157.TextAlign = 'Right'
	#
	# textbox158
	#
	$textbox158.BackColor = [System.Drawing.Color]::Black 
	$textbox158.BorderStyle = 'None'
	$textbox158.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox158.ForeColor = [System.Drawing.Color]::Gray 
	$textbox158.Location = New-Object System.Drawing.Point(60, 30)
	$textbox158.Margin = '0, 0, 0, 0'
	$textbox158.Name = 'textbox158'
	$textbox158.ReadOnly = $True
	$textbox158.RightToLeft = 'No'
	$textbox158.Size = New-Object System.Drawing.Size(62, 16)
	$textbox158.TabIndex = 13
	$textbox158.Text = '-'
	$textbox158.TextAlign = 'Right'
	#
	# groupbox30
	#
	$groupbox30.Controls.Add($label1013088)
	$groupbox30.Controls.Add($label1013089)
	$groupbox30.Controls.Add($textbox243)
	$groupbox30.Controls.Add($labelForecast)
	$groupbox30.Controls.Add($textbox244)
	$groupbox30.Controls.Add($label1013034)
	$groupbox30.Controls.Add($label1013033)
	$groupbox30.Controls.Add($label1013032)
	$groupbox30.Controls.Add($label1013031)
	$groupbox30.Controls.Add($textbox184)
	$groupbox30.Controls.Add($textbox185)
	$groupbox30.Controls.Add($textbox183)
	$groupbox30.Controls.Add($labelDelta)
	$groupbox30.Controls.Add($textbox84)
	$groupbox30.Controls.Add($labelCurrent)
	$groupbox30.BackColor = [System.Drawing.Color]::Black 
	$groupbox30.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox30.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox30.Location = New-Object System.Drawing.Point(469, 24)
	$groupbox30.Margin = '4, 3, 4, 3'
	$groupbox30.Name = 'groupbox30'
	$groupbox30.Padding = '4, 3, 4, 3'
	$groupbox30.RightToLeft = 'Yes'
	$groupbox30.Size = New-Object System.Drawing.Size(254, 111)
	$groupbox30.TabIndex = 50
	$groupbox30.TabStop = $False
	$groupbox30.Text = 'DISTANCE'
	#
	# label1013088
	#
	$label1013088.AutoSize = $True
	$label1013088.BackColor = [System.Drawing.Color]::Black 
	$label1013088.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013088.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013088.Location = New-Object System.Drawing.Point(181, 43)
	$label1013088.Margin = '4, 0, 4, 0'
	$label1013088.Name = 'label1013088'
	$label1013088.RightToLeft = 'No'
	$label1013088.Size = New-Object System.Drawing.Size(23, 16)
	$label1013088.TabIndex = 79
	$label1013088.Text = 'Km'
	#
	# label1013089
	#
	$label1013089.AutoSize = $True
	$label1013089.BackColor = [System.Drawing.Color]::Black 
	$label1013089.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013089.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013089.Location = New-Object System.Drawing.Point(234, 43)
	$label1013089.Margin = '4, 0, 4, 0'
	$label1013089.Name = 'label1013089'
	$label1013089.RightToLeft = 'No'
	$label1013089.Size = New-Object System.Drawing.Size(15, 16)
	$label1013089.TabIndex = 78
	$label1013089.Text = 'm'
	#
	# textbox243
	#
	$textbox243.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox243.BorderStyle = 'None'
	$textbox243.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox243.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox243.Location = New-Object System.Drawing.Point(203, 44)
	$textbox243.Margin = '0, 0, 0, 0'
	$textbox243.Name = 'textbox243'
	$textbox243.ReadOnly = $True
	$textbox243.RightToLeft = 'No'
	$textbox243.Size = New-Object System.Drawing.Size(27, 16)
	$textbox243.TabIndex = 77
	$textbox243.Text = '-'
	$textbox243.TextAlign = 'Right'
	#
	# labelForecast
	#
	$labelForecast.AutoSize = $True
	$labelForecast.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelForecast.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelForecast.Location = New-Object System.Drawing.Point(15, 44)
	$labelForecast.Margin = '4, 0, 4, 0'
	$labelForecast.Name = 'labelForecast'
	$labelForecast.RightToLeft = 'No'
	$labelForecast.Size = New-Object System.Drawing.Size(71, 16)
	$labelForecast.TabIndex = 76
	$labelForecast.Text = 'Forecast'
	#
	# textbox244
	#
	$textbox244.BackColor = [System.Drawing.Color]::Black 
	$textbox244.BorderStyle = 'None'
	$textbox244.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox244.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox244.Location = New-Object System.Drawing.Point(90, 44)
	$textbox244.Margin = '0, 0, 0, 0'
	$textbox244.Name = 'textbox244'
	$textbox244.ReadOnly = $True
	$textbox244.RightToLeft = 'No'
	$textbox244.Size = New-Object System.Drawing.Size(87, 16)
	$textbox244.TabIndex = 75
	$textbox244.Text = '-'
	$textbox244.TextAlign = 'Right'
	#
	# label1013034
	#
	$label1013034.AutoSize = $True
	$label1013034.BackColor = [System.Drawing.Color]::Black 
	$label1013034.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013034.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013034.Location = New-Object System.Drawing.Point(181, 61)
	$label1013034.Margin = '4, 0, 4, 0'
	$label1013034.Name = 'label1013034'
	$label1013034.RightToLeft = 'No'
	$label1013034.Size = New-Object System.Drawing.Size(23, 16)
	$label1013034.TabIndex = 74
	$label1013034.Text = 'Km'
	#
	# label1013033
	#
	$label1013033.AutoSize = $True
	$label1013033.BackColor = [System.Drawing.Color]::Black 
	$label1013033.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013033.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013033.Location = New-Object System.Drawing.Point(180, 24)
	$label1013033.Margin = '4, 0, 4, 0'
	$label1013033.Name = 'label1013033'
	$label1013033.RightToLeft = 'No'
	$label1013033.Size = New-Object System.Drawing.Size(23, 16)
	$label1013033.TabIndex = 73
	$label1013033.Text = 'Km'
	#
	# label1013032
	#
	$label1013032.AutoSize = $True
	$label1013032.BackColor = [System.Drawing.Color]::Black 
	$label1013032.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013032.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013032.Location = New-Object System.Drawing.Point(234, 24)
	$label1013032.Margin = '4, 0, 4, 0'
	$label1013032.Name = 'label1013032'
	$label1013032.RightToLeft = 'No'
	$label1013032.Size = New-Object System.Drawing.Size(15, 16)
	$label1013032.TabIndex = 72
	$label1013032.Text = 'm'
	#
	# label1013031
	#
	$label1013031.AutoSize = $True
	$label1013031.BackColor = [System.Drawing.Color]::Black 
	$label1013031.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013031.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013031.Location = New-Object System.Drawing.Point(234, 61)
	$label1013031.Margin = '4, 0, 4, 0'
	$label1013031.Name = 'label1013031'
	$label1013031.RightToLeft = 'No'
	$label1013031.Size = New-Object System.Drawing.Size(15, 16)
	$label1013031.TabIndex = 71
	$label1013031.Text = 'm'
	#
	# textbox184
	#
	$textbox184.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox184.BorderStyle = 'None'
	$textbox184.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox184.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox184.Location = New-Object System.Drawing.Point(203, 24)
	$textbox184.Margin = '0, 0, 0, 0'
	$textbox184.Name = 'textbox184'
	$textbox184.ReadOnly = $True
	$textbox184.RightToLeft = 'No'
	$textbox184.Size = New-Object System.Drawing.Size(27, 16)
	$textbox184.TabIndex = 28
	$textbox184.Text = '-'
	$textbox184.TextAlign = 'Right'
	#
	# textbox185
	#
	$textbox185.BackColor = [System.Drawing.Color]::Black 
	$textbox185.BorderStyle = 'None'
	$textbox185.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox185.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox185.Location = New-Object System.Drawing.Point(78, 24)
	$textbox185.Margin = '0, 0, 0, 0'
	$textbox185.Name = 'textbox185'
	$textbox185.ReadOnly = $True
	$textbox185.RightToLeft = 'No'
	$textbox185.Size = New-Object System.Drawing.Size(99, 16)
	$textbox185.TabIndex = 27
	$textbox185.Text = '-'
	$textbox185.TextAlign = 'Right'
	#
	# textbox183
	#
	$textbox183.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox183.BorderStyle = 'None'
	$textbox183.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox183.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox183.Location = New-Object System.Drawing.Point(203, 62)
	$textbox183.Margin = '0, 0, 0, 0'
	$textbox183.Name = 'textbox183'
	$textbox183.ReadOnly = $True
	$textbox183.RightToLeft = 'No'
	$textbox183.Size = New-Object System.Drawing.Size(27, 16)
	$textbox183.TabIndex = 26
	$textbox183.Text = '-'
	$textbox183.TextAlign = 'Right'
	#
	# labelDelta
	#
	$labelDelta.AutoSize = $True
	$labelDelta.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelDelta.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelDelta.Location = New-Object System.Drawing.Point(15, 62)
	$labelDelta.Margin = '4, 0, 4, 0'
	$labelDelta.Name = 'labelDelta'
	$labelDelta.RightToLeft = 'No'
	$labelDelta.Size = New-Object System.Drawing.Size(47, 16)
	$labelDelta.TabIndex = 25
	$labelDelta.Text = 'Delta'
	#
	# textbox84
	#
	$textbox84.BackColor = [System.Drawing.Color]::Black 
	$textbox84.BorderStyle = 'None'
	$textbox84.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox84.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox84.Location = New-Object System.Drawing.Point(78, 62)
	$textbox84.Margin = '0, 0, 0, 0'
	$textbox84.Name = 'textbox84'
	$textbox84.ReadOnly = $True
	$textbox84.RightToLeft = 'No'
	$textbox84.Size = New-Object System.Drawing.Size(99, 16)
	$textbox84.TabIndex = 24
	$textbox84.Text = '-'
	$textbox84.TextAlign = 'Right'
	#
	# labelCurrent
	#
	$labelCurrent.AutoSize = $True
	$labelCurrent.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelCurrent.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelCurrent.Location = New-Object System.Drawing.Point(15, 26)
	$labelCurrent.Margin = '4, 0, 4, 0'
	$labelCurrent.Name = 'labelCurrent'
	$labelCurrent.RightToLeft = 'No'
	$labelCurrent.Size = New-Object System.Drawing.Size(63, 16)
	$labelCurrent.TabIndex = 9
	$labelCurrent.Text = 'Current'
	#
	# groupbox33
	#
	$groupbox33.Controls.Add($label1013068)
	$groupbox33.Controls.Add($label1013067)
	$groupbox33.Controls.Add($label1013066)
	$groupbox33.Controls.Add($label1013065)
	$groupbox33.Controls.Add($label1013064)
	$groupbox33.Controls.Add($label1013063)
	$groupbox33.Controls.Add($textbox208)
	$groupbox33.Controls.Add($textbox209)
	$groupbox33.Controls.Add($textbox210)
	$groupbox33.Controls.Add($textbox211)
	$groupbox33.Controls.Add($textbox212)
	$groupbox33.Controls.Add($textbox213)
	$groupbox33.Controls.Add($textbox207)
	$groupbox33.Controls.Add($textbox206)
	$groupbox33.Controls.Add($textbox204)
	$groupbox33.Controls.Add($textbox203)
	$groupbox33.Controls.Add($textbox202)
	$groupbox33.Controls.Add($textbox201)
	$groupbox33.Controls.Add($textbox200)
	$groupbox33.Controls.Add($textbox199)
	$groupbox33.Controls.Add($textbox198)
	$groupbox33.Controls.Add($textbox197)
	$groupbox33.Controls.Add($textbox196)
	$groupbox33.Controls.Add($textbox195)
	$groupbox33.Controls.Add($label6)
	$groupbox33.Controls.Add($label1013058)
	$groupbox33.Controls.Add($label1013057)
	$groupbox33.Controls.Add($label3)
	$groupbox33.Controls.Add($label1013055)
	$groupbox33.Controls.Add($label1013054)
	$groupbox33.BackColor = [System.Drawing.Color]::Black 
	$groupbox33.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox33.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox33.Location = New-Object System.Drawing.Point(36, 344)
	$groupbox33.Margin = '4, 3, 4, 3'
	$groupbox33.Name = 'groupbox33'
	$groupbox33.Padding = '4, 3, 4, 3'
	$groupbox33.RightToLeft = 'Yes'
	$groupbox33.Size = New-Object System.Drawing.Size(380, 140)
	$groupbox33.TabIndex = 52
	$groupbox33.TabStop = $False
	$groupbox33.Text = 'INSTRUCTIONS'
	#
	# label1013068
	#
	$label1013068.AutoSize = $True
	$label1013068.BackColor = [System.Drawing.Color]::Black 
	$label1013068.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013068.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013068.Location = New-Object System.Drawing.Point(337, 113)
	$label1013068.Margin = '4, 0, 4, 0'
	$label1013068.Name = 'label1013068'
	$label1013068.RightToLeft = 'No'
	$label1013068.Size = New-Object System.Drawing.Size(23, 16)
	$label1013068.TabIndex = 108
	$label1013068.Text = 'Km'
	#
	# label1013067
	#
	$label1013067.AutoSize = $True
	$label1013067.BackColor = [System.Drawing.Color]::Black 
	$label1013067.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013067.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013067.Location = New-Object System.Drawing.Point(337, 94)
	$label1013067.Margin = '4, 0, 4, 0'
	$label1013067.Name = 'label1013067'
	$label1013067.RightToLeft = 'No'
	$label1013067.Size = New-Object System.Drawing.Size(23, 16)
	$label1013067.TabIndex = 107
	$label1013067.Text = 'Km'
	#
	# label1013066
	#
	$label1013066.AutoSize = $True
	$label1013066.BackColor = [System.Drawing.Color]::Black 
	$label1013066.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013066.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013066.Location = New-Object System.Drawing.Point(337, 75)
	$label1013066.Margin = '4, 0, 4, 0'
	$label1013066.Name = 'label1013066'
	$label1013066.RightToLeft = 'No'
	$label1013066.Size = New-Object System.Drawing.Size(23, 16)
	$label1013066.TabIndex = 106
	$label1013066.Text = 'Km'
	#
	# label1013065
	#
	$label1013065.AutoSize = $True
	$label1013065.BackColor = [System.Drawing.Color]::Black 
	$label1013065.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013065.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013065.Location = New-Object System.Drawing.Point(337, 57)
	$label1013065.Margin = '4, 0, 4, 0'
	$label1013065.Name = 'label1013065'
	$label1013065.RightToLeft = 'No'
	$label1013065.Size = New-Object System.Drawing.Size(23, 16)
	$label1013065.TabIndex = 105
	$label1013065.Text = 'Km'
	#
	# label1013064
	#
	$label1013064.AutoSize = $True
	$label1013064.BackColor = [System.Drawing.Color]::Black 
	$label1013064.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013064.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013064.Location = New-Object System.Drawing.Point(337, 37)
	$label1013064.Margin = '4, 0, 4, 0'
	$label1013064.Name = 'label1013064'
	$label1013064.RightToLeft = 'No'
	$label1013064.Size = New-Object System.Drawing.Size(23, 16)
	$label1013064.TabIndex = 104
	$label1013064.Text = 'Km'
	#
	# label1013063
	#
	$label1013063.AutoSize = $True
	$label1013063.BackColor = [System.Drawing.Color]::Black 
	$label1013063.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013063.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013063.Location = New-Object System.Drawing.Point(337, 18)
	$label1013063.Margin = '4, 0, 4, 0'
	$label1013063.Name = 'label1013063'
	$label1013063.RightToLeft = 'No'
	$label1013063.Size = New-Object System.Drawing.Size(23, 16)
	$label1013063.TabIndex = 75
	$label1013063.Text = 'Km'
	#
	# textbox208
	#
	$textbox208.BackColor = [System.Drawing.Color]::Black 
	$textbox208.BorderStyle = 'None'
	$textbox208.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox208.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox208.Location = New-Object System.Drawing.Point(292, 56)
	$textbox208.Margin = '0, 0, 0, 0'
	$textbox208.Name = 'textbox208'
	$textbox208.ReadOnly = $True
	$textbox208.RightToLeft = 'No'
	$textbox208.Size = New-Object System.Drawing.Size(42, 16)
	$textbox208.TabIndex = 103
	$textbox208.Text = '-'
	$textbox208.TextAlign = 'Right'
	#
	# textbox209
	#
	$textbox209.BackColor = [System.Drawing.Color]::Black 
	$textbox209.BorderStyle = 'None'
	$textbox209.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox209.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox209.Location = New-Object System.Drawing.Point(292, 113)
	$textbox209.Margin = '0, 0, 0, 0'
	$textbox209.Name = 'textbox209'
	$textbox209.ReadOnly = $True
	$textbox209.RightToLeft = 'No'
	$textbox209.Size = New-Object System.Drawing.Size(42, 16)
	$textbox209.TabIndex = 102
	$textbox209.Text = '-'
	$textbox209.TextAlign = 'Right'
	#
	# textbox210
	#
	$textbox210.BackColor = [System.Drawing.Color]::Black 
	$textbox210.BorderStyle = 'None'
	$textbox210.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox210.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox210.Location = New-Object System.Drawing.Point(292, 94)
	$textbox210.Margin = '0, 0, 0, 0'
	$textbox210.Name = 'textbox210'
	$textbox210.ReadOnly = $True
	$textbox210.RightToLeft = 'No'
	$textbox210.Size = New-Object System.Drawing.Size(42, 16)
	$textbox210.TabIndex = 101
	$textbox210.Text = '-'
	$textbox210.TextAlign = 'Right'
	#
	# textbox211
	#
	$textbox211.BackColor = [System.Drawing.Color]::Black 
	$textbox211.BorderStyle = 'None'
	$textbox211.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox211.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox211.Location = New-Object System.Drawing.Point(292, 75)
	$textbox211.Margin = '0, 0, 0, 0'
	$textbox211.Name = 'textbox211'
	$textbox211.ReadOnly = $True
	$textbox211.RightToLeft = 'No'
	$textbox211.Size = New-Object System.Drawing.Size(42, 16)
	$textbox211.TabIndex = 100
	$textbox211.Text = '-'
	$textbox211.TextAlign = 'Right'
	#
	# textbox212
	#
	$textbox212.BackColor = [System.Drawing.Color]::Black 
	$textbox212.BorderStyle = 'None'
	$textbox212.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox212.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox212.Location = New-Object System.Drawing.Point(292, 37)
	$textbox212.Margin = '0, 0, 0, 0'
	$textbox212.Name = 'textbox212'
	$textbox212.ReadOnly = $True
	$textbox212.RightToLeft = 'No'
	$textbox212.Size = New-Object System.Drawing.Size(42, 16)
	$textbox212.TabIndex = 99
	$textbox212.Text = '-'
	$textbox212.TextAlign = 'Right'
	#
	# textbox213
	#
	$textbox213.BackColor = [System.Drawing.Color]::Black 
	$textbox213.BorderStyle = 'None'
	$textbox213.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox213.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox213.Location = New-Object System.Drawing.Point(269, 18)
	$textbox213.Margin = '0, 0, 0, 0'
	$textbox213.Name = 'textbox213'
	$textbox213.ReadOnly = $True
	$textbox213.RightToLeft = 'No'
	$textbox213.Size = New-Object System.Drawing.Size(65, 16)
	$textbox213.TabIndex = 98
	$textbox213.Text = '-'
	$textbox213.TextAlign = 'Right'
	#
	# textbox207
	#
	$textbox207.BackColor = [System.Drawing.Color]::Black 
	$textbox207.BorderStyle = 'None'
	$textbox207.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox207.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox207.Location = New-Object System.Drawing.Point(116, 56)
	$textbox207.Margin = '0, 0, 0, 0'
	$textbox207.Name = 'textbox207'
	$textbox207.ReadOnly = $True
	$textbox207.RightToLeft = 'No'
	$textbox207.Size = New-Object System.Drawing.Size(176, 16)
	$textbox207.TabIndex = 97
	$textbox207.Text = '-'
	#
	# textbox206
	#
	$textbox206.BackColor = [System.Drawing.Color]::Black 
	$textbox206.BorderStyle = 'None'
	$textbox206.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox206.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox206.Location = New-Object System.Drawing.Point(30, 56)
	$textbox206.Margin = '0, 0, 0, 0'
	$textbox206.Name = 'textbox206'
	$textbox206.ReadOnly = $True
	$textbox206.RightToLeft = 'No'
	$textbox206.Size = New-Object System.Drawing.Size(84, 16)
	$textbox206.TabIndex = 96
	$textbox206.Text = '-'
	#
	# textbox204
	#
	$textbox204.BackColor = [System.Drawing.Color]::Black 
	$textbox204.BorderStyle = 'None'
	$textbox204.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox204.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox204.Location = New-Object System.Drawing.Point(116, 113)
	$textbox204.Margin = '0, 0, 0, 0'
	$textbox204.Name = 'textbox204'
	$textbox204.ReadOnly = $True
	$textbox204.RightToLeft = 'No'
	$textbox204.Size = New-Object System.Drawing.Size(176, 16)
	$textbox204.TabIndex = 94
	$textbox204.Text = '-'
	#
	# textbox203
	#
	$textbox203.BackColor = [System.Drawing.Color]::Black 
	$textbox203.BorderStyle = 'None'
	$textbox203.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox203.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox203.Location = New-Object System.Drawing.Point(116, 94)
	$textbox203.Margin = '0, 0, 0, 0'
	$textbox203.Name = 'textbox203'
	$textbox203.ReadOnly = $True
	$textbox203.RightToLeft = 'No'
	$textbox203.Size = New-Object System.Drawing.Size(176, 16)
	$textbox203.TabIndex = 93
	$textbox203.Text = '-'
	#
	# textbox202
	#
	$textbox202.BackColor = [System.Drawing.Color]::Black 
	$textbox202.BorderStyle = 'None'
	$textbox202.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox202.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox202.Location = New-Object System.Drawing.Point(116, 75)
	$textbox202.Margin = '0, 0, 0, 0'
	$textbox202.Name = 'textbox202'
	$textbox202.ReadOnly = $True
	$textbox202.RightToLeft = 'No'
	$textbox202.Size = New-Object System.Drawing.Size(176, 16)
	$textbox202.TabIndex = 92
	$textbox202.Text = '-'
	#
	# textbox201
	#
	$textbox201.BackColor = [System.Drawing.Color]::Black 
	$textbox201.BorderStyle = 'None'
	$textbox201.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox201.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox201.Location = New-Object System.Drawing.Point(116, 37)
	$textbox201.Margin = '0, 0, 0, 0'
	$textbox201.Name = 'textbox201'
	$textbox201.ReadOnly = $True
	$textbox201.RightToLeft = 'No'
	$textbox201.Size = New-Object System.Drawing.Size(176, 16)
	$textbox201.TabIndex = 91
	$textbox201.Text = '-'
	#
	# textbox200
	#
	$textbox200.BackColor = [System.Drawing.Color]::Black 
	$textbox200.BorderStyle = 'None'
	$textbox200.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox200.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$textbox200.Location = New-Object System.Drawing.Point(116, 18)
	$textbox200.Margin = '0, 0, 0, 0'
	$textbox200.Name = 'textbox200'
	$textbox200.ReadOnly = $True
	$textbox200.RightToLeft = 'No'
	$textbox200.Size = New-Object System.Drawing.Size(143, 16)
	$textbox200.TabIndex = 25
	$textbox200.Text = '-'
	#
	# textbox199
	#
	$textbox199.BackColor = [System.Drawing.Color]::Black 
	$textbox199.BorderStyle = 'None'
	$textbox199.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox199.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox199.Location = New-Object System.Drawing.Point(30, 113)
	$textbox199.Margin = '0, 0, 0, 0'
	$textbox199.Name = 'textbox199'
	$textbox199.ReadOnly = $True
	$textbox199.RightToLeft = 'No'
	$textbox199.Size = New-Object System.Drawing.Size(84, 16)
	$textbox199.TabIndex = 90
	$textbox199.Text = '-'
	#
	# textbox198
	#
	$textbox198.BackColor = [System.Drawing.Color]::Black 
	$textbox198.BorderStyle = 'None'
	$textbox198.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox198.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox198.Location = New-Object System.Drawing.Point(30, 94)
	$textbox198.Margin = '0, 0, 0, 0'
	$textbox198.Name = 'textbox198'
	$textbox198.ReadOnly = $True
	$textbox198.RightToLeft = 'No'
	$textbox198.Size = New-Object System.Drawing.Size(84, 16)
	$textbox198.TabIndex = 89
	$textbox198.Text = '-'
	#
	# textbox197
	#
	$textbox197.BackColor = [System.Drawing.Color]::Black 
	$textbox197.BorderStyle = 'None'
	$textbox197.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox197.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox197.Location = New-Object System.Drawing.Point(30, 75)
	$textbox197.Margin = '0, 0, 0, 0'
	$textbox197.Name = 'textbox197'
	$textbox197.ReadOnly = $True
	$textbox197.RightToLeft = 'No'
	$textbox197.Size = New-Object System.Drawing.Size(84, 16)
	$textbox197.TabIndex = 88
	$textbox197.Text = '-'
	#
	# textbox196
	#
	$textbox196.BackColor = [System.Drawing.Color]::Black 
	$textbox196.BorderStyle = 'None'
	$textbox196.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox196.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox196.Location = New-Object System.Drawing.Point(30, 37)
	$textbox196.Margin = '0, 0, 0, 0'
	$textbox196.Name = 'textbox196'
	$textbox196.ReadOnly = $True
	$textbox196.RightToLeft = 'No'
	$textbox196.Size = New-Object System.Drawing.Size(84, 16)
	$textbox196.TabIndex = 87
	$textbox196.Text = '-'
	#
	# textbox195
	#
	$textbox195.BackColor = [System.Drawing.Color]::Black 
	$textbox195.BorderStyle = 'None'
	$textbox195.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox195.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox195.Location = New-Object System.Drawing.Point(30, 18)
	$textbox195.Margin = '0, 0, 0, 0'
	$textbox195.Name = 'textbox195'
	$textbox195.ReadOnly = $True
	$textbox195.RightToLeft = 'No'
	$textbox195.Size = New-Object System.Drawing.Size(84, 16)
	$textbox195.TabIndex = 25
	$textbox195.Text = '-'
	#
	# label6
	#
	$label6.AutoSize = $True
	$label6.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label6.ForeColor = [System.Drawing.Color]::DarkGray 
	$label6.Location = New-Object System.Drawing.Point(8, 113)
	$label6.Margin = '4, 0, 4, 0'
	$label6.Name = 'label6'
	$label6.RightToLeft = 'No'
	$label6.Size = New-Object System.Drawing.Size(18, 16)
	$label6.TabIndex = 86
	$label6.Text = '6.'
	#
	# label1013058
	#
	$label1013058.AutoSize = $True
	$label1013058.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013058.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013058.Location = New-Object System.Drawing.Point(8, 94)
	$label1013058.Margin = '4, 0, 4, 0'
	$label1013058.Name = 'label1013058'
	$label1013058.RightToLeft = 'No'
	$label1013058.Size = New-Object System.Drawing.Size(18, 16)
	$label1013058.TabIndex = 85
	$label1013058.Text = '5.'
	#
	# label1013057
	#
	$label1013057.AutoSize = $True
	$label1013057.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013057.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013057.Location = New-Object System.Drawing.Point(8, 75)
	$label1013057.Margin = '4, 0, 4, 0'
	$label1013057.Name = 'label1013057'
	$label1013057.RightToLeft = 'No'
	$label1013057.Size = New-Object System.Drawing.Size(18, 16)
	$label1013057.TabIndex = 84
	$label1013057.Text = '4.'
	#
	# label3
	#
	$label3.AutoSize = $True
	$label3.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label3.ForeColor = [System.Drawing.Color]::DarkGray 
	$label3.Location = New-Object System.Drawing.Point(8, 56)
	$label3.Margin = '4, 0, 4, 0'
	$label3.Name = 'label3'
	$label3.RightToLeft = 'No'
	$label3.Size = New-Object System.Drawing.Size(18, 16)
	$label3.TabIndex = 83
	$label3.Text = '3.'
	#
	# label1013055
	#
	$label1013055.AutoSize = $True
	$label1013055.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013055.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013055.Location = New-Object System.Drawing.Point(8, 37)
	$label1013055.Margin = '4, 0, 4, 0'
	$label1013055.Name = 'label1013055'
	$label1013055.RightToLeft = 'No'
	$label1013055.Size = New-Object System.Drawing.Size(18, 16)
	$label1013055.TabIndex = 82
	$label1013055.Text = '2.'
	#
	# label1013054
	#
	$label1013054.AutoSize = $True
	$label1013054.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013054.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013054.Location = New-Object System.Drawing.Point(8, 18)
	$label1013054.Margin = '4, 0, 4, 0'
	$label1013054.Name = 'label1013054'
	$label1013054.RightToLeft = 'No'
	$label1013054.Size = New-Object System.Drawing.Size(18, 16)
	$label1013054.TabIndex = 81
	$label1013054.Text = '1.'
	#
	# groupbox29
	#
	$groupbox29.Controls.Add($label1013060)
	$groupbox29.Controls.Add($textbox219)
	$groupbox29.Controls.Add($label1013059)
	$groupbox29.Controls.Add($textbox218)
	$groupbox29.Controls.Add($labelCOmpass)
	$groupbox29.Controls.Add($label1012958)
	$groupbox29.Controls.Add($label1012957)
	$groupbox29.Controls.Add($label1012956)
	$groupbox29.Controls.Add($textbox80)
	$groupbox29.Controls.Add($textbox81)
	$groupbox29.Controls.Add($textbox82)
	$groupbox29.Controls.Add($labelRPEv)
	$groupbox29.Controls.Add($labelRePv)
	$groupbox29.Controls.Add($labelPrev)
	$groupbox29.Controls.Add($textbox79)
	$groupbox29.Controls.Add($textbox78)
	$groupbox29.Controls.Add($textbox77)
	$groupbox29.Controls.Add($labelOnGround)
	$groupbox29.Controls.Add($labelInOrbit)
	$groupbox29.Controls.Add($labelInSpace)
	$groupbox29.BackColor = [System.Drawing.Color]::Black 
	$groupbox29.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox29.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox29.Location = New-Object System.Drawing.Point(182, 24)
	$groupbox29.Margin = '4, 3, 4, 3'
	$groupbox29.Name = 'groupbox29'
	$groupbox29.Padding = '4, 3, 4, 3'
	$groupbox29.RightToLeft = 'Yes'
	$groupbox29.Size = New-Object System.Drawing.Size(254, 111)
	$groupbox29.TabIndex = 50
	$groupbox29.TabStop = $False
	$groupbox29.Text = 'DEVIATION'
	#
	# label1013060
	#
	$label1013060.AutoSize = $True
	$label1013060.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013060.ForeColor = [System.Drawing.Color]::Gray 
	$label1013060.Location = New-Object System.Drawing.Point(234, 79)
	$label1013060.Margin = '4, 0, 4, 0'
	$label1013060.Name = 'label1013060'
	$label1013060.RightToLeft = 'No'
	$label1013060.Size = New-Object System.Drawing.Size(12, 16)
	$label1013060.TabIndex = 30
	$label1013060.Text = '°'
	#
	# textbox219
	#
	$textbox219.BackColor = [System.Drawing.Color]::Black 
	$textbox219.BorderStyle = 'None'
	$textbox219.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox219.ForeColor = [System.Drawing.Color]::Gray 
	$textbox219.Location = New-Object System.Drawing.Point(187, 79)
	$textbox219.Margin = '0, 0, 0, 0'
	$textbox219.Name = 'textbox219'
	$textbox219.ReadOnly = $True
	$textbox219.RightToLeft = 'No'
	$textbox219.Size = New-Object System.Drawing.Size(47, 16)
	$textbox219.TabIndex = 29
	$textbox219.Text = '-'
	$textbox219.TextAlign = 'Right'
	#
	# label1013059
	#
	$label1013059.AutoSize = $True
	$label1013059.BackColor = [System.Drawing.Color]::Black 
	$label1013059.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013059.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013059.Location = New-Object System.Drawing.Point(136, 79)
	$label1013059.Margin = '4, 0, 4, 0'
	$label1013059.Name = 'label1013059'
	$label1013059.RightToLeft = 'No'
	$label1013059.Size = New-Object System.Drawing.Size(52, 16)
	$label1013059.TabIndex = 28
	$label1013059.Text = '°  PREV'
	#
	# textbox218
	#
	$textbox218.BackColor = [System.Drawing.Color]::Black 
	$textbox218.BorderStyle = 'None'
	$textbox218.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox218.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox218.Location = New-Object System.Drawing.Point(89, 79)
	$textbox218.Margin = '0, 0, 0, 0'
	$textbox218.Name = 'textbox218'
	$textbox218.ReadOnly = $True
	$textbox218.RightToLeft = 'No'
	$textbox218.Size = New-Object System.Drawing.Size(47, 16)
	$textbox218.TabIndex = 27
	$textbox218.Text = '-'
	$textbox218.TextAlign = 'Right'
	#
	# labelCOmpass
	#
	$labelCOmpass.AutoSize = $True
	$labelCOmpass.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelCOmpass.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelCOmpass.Location = New-Object System.Drawing.Point(15, 79)
	$labelCOmpass.Margin = '4, 0, 4, 0'
	$labelCOmpass.Name = 'labelCOmpass'
	$labelCOmpass.RightToLeft = 'No'
	$labelCOmpass.Size = New-Object System.Drawing.Size(63, 16)
	$labelCOmpass.TabIndex = 26
	$labelCOmpass.Text = 'COmpass'
	#
	# label1012958
	#
	$label1012958.AutoSize = $True
	$label1012958.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1012958.ForeColor = [System.Drawing.Color]::Gray 
	$label1012958.Location = New-Object System.Drawing.Point(234, 59)
	$label1012958.Margin = '4, 0, 4, 0'
	$label1012958.Name = 'label1012958'
	$label1012958.RightToLeft = 'No'
	$label1012958.Size = New-Object System.Drawing.Size(12, 16)
	$label1012958.TabIndex = 25
	$label1012958.Text = '°'
	#
	# label1012957
	#
	$label1012957.AutoSize = $True
	$label1012957.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1012957.ForeColor = [System.Drawing.Color]::Gray 
	$label1012957.Location = New-Object System.Drawing.Point(234, 39)
	$label1012957.Margin = '4, 0, 4, 0'
	$label1012957.Name = 'label1012957'
	$label1012957.RightToLeft = 'No'
	$label1012957.Size = New-Object System.Drawing.Size(12, 16)
	$label1012957.TabIndex = 24
	$label1012957.Text = '°'
	#
	# label1012956
	#
	$label1012956.AutoSize = $True
	$label1012956.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1012956.ForeColor = [System.Drawing.Color]::Gray 
	$label1012956.Location = New-Object System.Drawing.Point(234, 19)
	$label1012956.Margin = '4, 0, 4, 0'
	$label1012956.Name = 'label1012956'
	$label1012956.RightToLeft = 'No'
	$label1012956.Size = New-Object System.Drawing.Size(12, 16)
	$label1012956.TabIndex = 23
	$label1012956.Text = '°'
	#
	# textbox80
	#
	$textbox80.BackColor = [System.Drawing.Color]::Black 
	$textbox80.BorderStyle = 'None'
	$textbox80.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox80.ForeColor = [System.Drawing.Color]::Gray 
	$textbox80.Location = New-Object System.Drawing.Point(187, 20)
	$textbox80.Margin = '0, 0, 0, 0'
	$textbox80.Name = 'textbox80'
	$textbox80.ReadOnly = $True
	$textbox80.RightToLeft = 'No'
	$textbox80.Size = New-Object System.Drawing.Size(47, 16)
	$textbox80.TabIndex = 22
	$textbox80.Text = '-'
	$textbox80.TextAlign = 'Right'
	#
	# textbox81
	#
	$textbox81.BackColor = [System.Drawing.Color]::Black 
	$textbox81.BorderStyle = 'None'
	$textbox81.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox81.ForeColor = [System.Drawing.Color]::Gray 
	$textbox81.Location = New-Object System.Drawing.Point(187, 40)
	$textbox81.Margin = '0, 0, 0, 0'
	$textbox81.Name = 'textbox81'
	$textbox81.ReadOnly = $True
	$textbox81.RightToLeft = 'No'
	$textbox81.Size = New-Object System.Drawing.Size(47, 16)
	$textbox81.TabIndex = 21
	$textbox81.Text = '-'
	$textbox81.TextAlign = 'Right'
	#
	# textbox82
	#
	$textbox82.BackColor = [System.Drawing.Color]::Black 
	$textbox82.BorderStyle = 'None'
	$textbox82.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox82.ForeColor = [System.Drawing.Color]::Gray 
	$textbox82.Location = New-Object System.Drawing.Point(187, 60)
	$textbox82.Margin = '0, 0, 0, 0'
	$textbox82.Name = 'textbox82'
	$textbox82.ReadOnly = $True
	$textbox82.RightToLeft = 'No'
	$textbox82.Size = New-Object System.Drawing.Size(47, 16)
	$textbox82.TabIndex = 20
	$textbox82.Text = '-'
	$textbox82.TextAlign = 'Right'
	#
	# labelRPEv
	#
	$labelRPEv.AutoSize = $True
	$labelRPEv.BackColor = [System.Drawing.Color]::Black 
	$labelRPEv.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelRPEv.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelRPEv.Location = New-Object System.Drawing.Point(136, 60)
	$labelRPEv.Margin = '4, 0, 4, 0'
	$labelRPEv.Name = 'labelRPEv'
	$labelRPEv.RightToLeft = 'No'
	$labelRPEv.Size = New-Object System.Drawing.Size(52, 16)
	$labelRPEv.TabIndex = 19
	$labelRPEv.Text = '°  PREV'
	#
	# labelRePv
	#
	$labelRePv.AutoSize = $True
	$labelRePv.BackColor = [System.Drawing.Color]::Black 
	$labelRePv.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelRePv.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelRePv.Location = New-Object System.Drawing.Point(136, 40)
	$labelRePv.Margin = '4, 0, 4, 0'
	$labelRePv.Name = 'labelRePv'
	$labelRePv.RightToLeft = 'No'
	$labelRePv.Size = New-Object System.Drawing.Size(52, 16)
	$labelRePv.TabIndex = 18
	$labelRePv.Text = '°  PREV'
	#
	# labelPrev
	#
	$labelPrev.AutoSize = $True
	$labelPrev.BackColor = [System.Drawing.Color]::Black 
	$labelPrev.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelPrev.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelPrev.Location = New-Object System.Drawing.Point(136, 20)
	$labelPrev.Margin = '4, 0, 4, 0'
	$labelPrev.Name = 'labelPrev'
	$labelPrev.RightToLeft = 'No'
	$labelPrev.Size = New-Object System.Drawing.Size(52, 16)
	$labelPrev.TabIndex = 17
	$labelPrev.Text = '°  PREV'
	#
	# textbox79
	#
	$textbox79.BackColor = [System.Drawing.Color]::Black 
	$textbox79.BorderStyle = 'None'
	$textbox79.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox79.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox79.Location = New-Object System.Drawing.Point(89, 20)
	$textbox79.Margin = '0, 0, 0, 0'
	$textbox79.Name = 'textbox79'
	$textbox79.ReadOnly = $True
	$textbox79.RightToLeft = 'No'
	$textbox79.Size = New-Object System.Drawing.Size(47, 16)
	$textbox79.TabIndex = 16
	$textbox79.Text = '-'
	$textbox79.TextAlign = 'Right'
	#
	# textbox78
	#
	$textbox78.BackColor = [System.Drawing.Color]::Black 
	$textbox78.BorderStyle = 'None'
	$textbox78.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox78.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox78.Location = New-Object System.Drawing.Point(89, 41)
	$textbox78.Margin = '0, 0, 0, 0'
	$textbox78.Name = 'textbox78'
	$textbox78.ReadOnly = $True
	$textbox78.RightToLeft = 'No'
	$textbox78.Size = New-Object System.Drawing.Size(47, 16)
	$textbox78.TabIndex = 15
	$textbox78.Text = '-'
	$textbox78.TextAlign = 'Right'
	#
	# textbox77
	#
	$textbox77.BackColor = [System.Drawing.Color]::Black 
	$textbox77.BorderStyle = 'None'
	$textbox77.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox77.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox77.Location = New-Object System.Drawing.Point(89, 61)
	$textbox77.Margin = '0, 0, 0, 0'
	$textbox77.Name = 'textbox77'
	$textbox77.ReadOnly = $True
	$textbox77.RightToLeft = 'No'
	$textbox77.Size = New-Object System.Drawing.Size(47, 16)
	$textbox77.TabIndex = 14
	$textbox77.Text = '-'
	$textbox77.TextAlign = 'Right'
	#
	# labelOnGround
	#
	$labelOnGround.AutoSize = $True
	$labelOnGround.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOnGround.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOnGround.Location = New-Object System.Drawing.Point(15, 60)
	$labelOnGround.Margin = '4, 0, 4, 0'
	$labelOnGround.Name = 'labelOnGround'
	$labelOnGround.RightToLeft = 'No'
	$labelOnGround.Size = New-Object System.Drawing.Size(75, 16)
	$labelOnGround.TabIndex = 11
	$labelOnGround.Text = 'On ground'
	#
	# labelInOrbit
	#
	$labelInOrbit.AutoSize = $True
	$labelInOrbit.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelInOrbit.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelInOrbit.Location = New-Object System.Drawing.Point(15, 40)
	$labelInOrbit.Margin = '4, 0, 4, 0'
	$labelInOrbit.Name = 'labelInOrbit'
	$labelInOrbit.RightToLeft = 'No'
	$labelInOrbit.Size = New-Object System.Drawing.Size(59, 16)
	$labelInOrbit.TabIndex = 10
	$labelInOrbit.Text = 'In orbit'
	#
	# labelInSpace
	#
	$labelInSpace.AutoSize = $True
	$labelInSpace.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelInSpace.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelInSpace.Location = New-Object System.Drawing.Point(15, 20)
	$labelInSpace.Margin = '4, 0, 4, 0'
	$labelInSpace.Name = 'labelInSpace'
	$labelInSpace.RightToLeft = 'No'
	$labelInSpace.Size = New-Object System.Drawing.Size(63, 16)
	$labelInSpace.TabIndex = 9
	$labelInSpace.Text = 'In space'
	#
	# picturebox8
	#
	$picturebox8.BackgroundImageLayout = 'Stretch'
	$picturebox8.Location = New-Object System.Drawing.Point(-4, 1)
	$picturebox8.Margin = '4, 3, 4, 3'
	$picturebox8.Name = 'picturebox8'
	$picturebox8.Size = New-Object System.Drawing.Size(1247, 536)
	$picturebox8.SizeMode = 'StretchImage'
	$picturebox8.TabIndex = 57
	$picturebox8.TabStop = $False
	#
	# tabpage3
	#
	$tabpage3.Controls.Add($groupbox46)
	$tabpage3.Controls.Add($groupbox45)
	$tabpage3.Controls.Add($groupbox44)
	$tabpage3.Controls.Add($picturebox6)
	$tabpage3.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$tabpage3.BackgroundImageLayout = 'Stretch'
	$tabpage3.Cursor = 'Default'
	$tabpage3.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage3.Margin = '4, 3, 4, 3'
	$tabpage3.Name = 'tabpage3'
	$tabpage3.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage3.TabIndex = 2
	$tabpage3.Text = 'Orbital Drop'
	#
	# groupbox46
	#
	$groupbox46.Controls.Add($label1013085)
	$groupbox46.Controls.Add($textbox235)
	$groupbox46.Controls.Add($label1013086)
	$groupbox46.Controls.Add($textbox236)
	$groupbox46.Controls.Add($label1013087)
	$groupbox46.Controls.Add($label1013084)
	$groupbox46.Controls.Add($textbox234)
	$groupbox46.Controls.Add($labelSec)
	$groupbox46.Controls.Add($label1013083)
	$groupbox46.Controls.Add($textbox233)
	$groupbox46.Controls.Add($textbox230)
	$groupbox46.Controls.Add($labelExpected)
	$groupbox46.Controls.Add($labelEta)
	$groupbox46.Controls.Add($labelG)
	$groupbox46.Controls.Add($labelMS)
	$groupbox46.Controls.Add($textbox231)
	$groupbox46.Controls.Add($textbox232)
	$groupbox46.Controls.Add($labelCurrentSpeed)
	$groupbox46.Controls.Add($labelGRAVITY)
	$groupbox46.BackColor = [System.Drawing.Color]::Black 
	$groupbox46.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox46.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox46.Location = New-Object System.Drawing.Point(309, 134)
	$groupbox46.Margin = '4, 3, 4, 3'
	$groupbox46.Name = 'groupbox46'
	$groupbox46.Padding = '4, 3, 4, 3'
	$groupbox46.RightToLeft = 'Yes'
	$groupbox46.Size = New-Object System.Drawing.Size(442, 102)
	$groupbox46.TabIndex = 79
	$groupbox46.TabStop = $False
	$groupbox46.Text = 'SPEEDS AND DURATIONS'
	#
	# label1013085
	#
	$label1013085.AutoSize = $True
	$label1013085.BackColor = [System.Drawing.Color]::Black 
	$label1013085.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013085.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013085.Location = New-Object System.Drawing.Point(343, 67)
	$label1013085.Margin = '4, 0, 4, 0'
	$label1013085.Name = 'label1013085'
	$label1013085.RightToLeft = 'No'
	$label1013085.Size = New-Object System.Drawing.Size(27, 16)
	$label1013085.TabIndex = 88
	$label1013085.Text = 'Min'
	#
	# textbox235
	#
	$textbox235.BackColor = [System.Drawing.Color]::Black 
	$textbox235.BorderStyle = 'None'
	$textbox235.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox235.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox235.Location = New-Object System.Drawing.Point(309, 67)
	$textbox235.Margin = '0, 0, 0, 0'
	$textbox235.Name = 'textbox235'
	$textbox235.ReadOnly = $True
	$textbox235.RightToLeft = 'No'
	$textbox235.Size = New-Object System.Drawing.Size(30, 16)
	$textbox235.TabIndex = 87
	$textbox235.Text = '-'
	$textbox235.TextAlign = 'Right'
	#
	# label1013086
	#
	$label1013086.AutoSize = $True
	$label1013086.BackColor = [System.Drawing.Color]::Black 
	$label1013086.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013086.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013086.Location = New-Object System.Drawing.Point(401, 67)
	$label1013086.Margin = '4, 0, 4, 0'
	$label1013086.Name = 'label1013086'
	$label1013086.RightToLeft = 'No'
	$label1013086.Size = New-Object System.Drawing.Size(31, 16)
	$label1013086.TabIndex = 86
	$label1013086.Text = 'Sec'
	#
	# textbox236
	#
	$textbox236.BackColor = [System.Drawing.Color]::Black 
	$textbox236.BorderStyle = 'None'
	$textbox236.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox236.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox236.Location = New-Object System.Drawing.Point(372, 67)
	$textbox236.Margin = '0, 0, 0, 0'
	$textbox236.Name = 'textbox236'
	$textbox236.ReadOnly = $True
	$textbox236.RightToLeft = 'No'
	$textbox236.Size = New-Object System.Drawing.Size(25, 16)
	$textbox236.TabIndex = 85
	$textbox236.Text = '-'
	$textbox236.TextAlign = 'Right'
	#
	# label1013087
	#
	$label1013087.AutoSize = $True
	$label1013087.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013087.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013087.Location = New-Object System.Drawing.Point(270, 67)
	$label1013087.Margin = '4, 0, 4, 0'
	$label1013087.Name = 'label1013087'
	$label1013087.RightToLeft = 'No'
	$label1013087.Size = New-Object System.Drawing.Size(31, 16)
	$label1013087.TabIndex = 84
	$label1013087.Text = 'Eta'
	#
	# label1013084
	#
	$label1013084.AutoSize = $True
	$label1013084.BackColor = [System.Drawing.Color]::Black 
	$label1013084.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013084.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013084.Location = New-Object System.Drawing.Point(343, 45)
	$label1013084.Margin = '4, 0, 4, 0'
	$label1013084.Name = 'label1013084'
	$label1013084.RightToLeft = 'No'
	$label1013084.Size = New-Object System.Drawing.Size(27, 16)
	$label1013084.TabIndex = 83
	$label1013084.Text = 'Min'
	#
	# textbox234
	#
	$textbox234.BackColor = [System.Drawing.Color]::Black 
	$textbox234.BorderStyle = 'None'
	$textbox234.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox234.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox234.Location = New-Object System.Drawing.Point(309, 45)
	$textbox234.Margin = '0, 0, 0, 0'
	$textbox234.Name = 'textbox234'
	$textbox234.ReadOnly = $True
	$textbox234.RightToLeft = 'No'
	$textbox234.Size = New-Object System.Drawing.Size(30, 16)
	$textbox234.TabIndex = 82
	$textbox234.Text = '-'
	$textbox234.TextAlign = 'Right'
	#
	# labelSec
	#
	$labelSec.AutoSize = $True
	$labelSec.BackColor = [System.Drawing.Color]::Black 
	$labelSec.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSec.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelSec.Location = New-Object System.Drawing.Point(401, 45)
	$labelSec.Margin = '4, 0, 4, 0'
	$labelSec.Name = 'labelSec'
	$labelSec.RightToLeft = 'No'
	$labelSec.Size = New-Object System.Drawing.Size(31, 16)
	$labelSec.TabIndex = 81
	$labelSec.Text = 'Sec'
	#
	# label1013083
	#
	$label1013083.AutoSize = $True
	$label1013083.BackColor = [System.Drawing.Color]::Black 
	$label1013083.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013083.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013083.Location = New-Object System.Drawing.Point(219, 67)
	$label1013083.Margin = '4, 0, 4, 0'
	$label1013083.Name = 'label1013083'
	$label1013083.RightToLeft = 'No'
	$label1013083.Size = New-Object System.Drawing.Size(30, 16)
	$label1013083.TabIndex = 80
	$label1013083.Text = 'M/S'
	#
	# textbox233
	#
	$textbox233.BackColor = [System.Drawing.Color]::Black 
	$textbox233.BorderStyle = 'None'
	$textbox233.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox233.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox233.Location = New-Object System.Drawing.Point(126, 67)
	$textbox233.Margin = '0, 0, 0, 0'
	$textbox233.Name = 'textbox233'
	$textbox233.ReadOnly = $True
	$textbox233.RightToLeft = 'No'
	$textbox233.Size = New-Object System.Drawing.Size(89, 16)
	$textbox233.TabIndex = 79
	$textbox233.Text = '-'
	$textbox233.TextAlign = 'Right'
	#
	# textbox230
	#
	$textbox230.BackColor = [System.Drawing.Color]::Black 
	$textbox230.BorderStyle = 'None'
	$textbox230.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox230.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox230.Location = New-Object System.Drawing.Point(372, 45)
	$textbox230.Margin = '0, 0, 0, 0'
	$textbox230.Name = 'textbox230'
	$textbox230.ReadOnly = $True
	$textbox230.RightToLeft = 'No'
	$textbox230.Size = New-Object System.Drawing.Size(25, 16)
	$textbox230.TabIndex = 75
	$textbox230.Text = '-'
	$textbox230.TextAlign = 'Right'
	#
	# labelExpected
	#
	$labelExpected.AutoSize = $True
	$labelExpected.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelExpected.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelExpected.Location = New-Object System.Drawing.Point(15, 67)
	$labelExpected.Margin = '4, 0, 4, 0'
	$labelExpected.Name = 'labelExpected'
	$labelExpected.RightToLeft = 'No'
	$labelExpected.Size = New-Object System.Drawing.Size(71, 16)
	$labelExpected.TabIndex = 74
	$labelExpected.Text = 'Expected'
	#
	# labelEta
	#
	$labelEta.AutoSize = $True
	$labelEta.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelEta.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelEta.Location = New-Object System.Drawing.Point(270, 45)
	$labelEta.Margin = '4, 0, 4, 0'
	$labelEta.Name = 'labelEta'
	$labelEta.RightToLeft = 'No'
	$labelEta.Size = New-Object System.Drawing.Size(31, 16)
	$labelEta.TabIndex = 73
	$labelEta.Text = 'Eta'
	#
	# labelG
	#
	$labelG.AutoSize = $True
	$labelG.BackColor = [System.Drawing.Color]::Black 
	$labelG.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelG.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelG.Location = New-Object System.Drawing.Point(219, 24)
	$labelG.Margin = '4, 0, 4, 0'
	$labelG.Name = 'labelG'
	$labelG.RightToLeft = 'No'
	$labelG.Size = New-Object System.Drawing.Size(15, 16)
	$labelG.TabIndex = 72
	$labelG.Text = 'G'
	#
	# labelMS
	#
	$labelMS.AutoSize = $True
	$labelMS.BackColor = [System.Drawing.Color]::Black 
	$labelMS.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelMS.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelMS.Location = New-Object System.Drawing.Point(219, 45)
	$labelMS.Margin = '4, 0, 4, 0'
	$labelMS.Name = 'labelMS'
	$labelMS.RightToLeft = 'No'
	$labelMS.Size = New-Object System.Drawing.Size(30, 16)
	$labelMS.TabIndex = 71
	$labelMS.Text = 'M/S'
	#
	# textbox231
	#
	$textbox231.BackColor = [System.Drawing.Color]::Black 
	$textbox231.BorderStyle = 'None'
	$textbox231.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox231.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox231.Location = New-Object System.Drawing.Point(126, 24)
	$textbox231.Margin = '0, 0, 0, 0'
	$textbox231.Name = 'textbox231'
	$textbox231.ReadOnly = $True
	$textbox231.RightToLeft = 'No'
	$textbox231.Size = New-Object System.Drawing.Size(89, 16)
	$textbox231.TabIndex = 28
	$textbox231.Text = '-'
	$textbox231.TextAlign = 'Right'
	#
	# textbox232
	#
	$textbox232.BackColor = [System.Drawing.Color]::Black 
	$textbox232.BorderStyle = 'None'
	$textbox232.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox232.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox232.Location = New-Object System.Drawing.Point(126, 46)
	$textbox232.Margin = '0, 0, 0, 0'
	$textbox232.Name = 'textbox232'
	$textbox232.ReadOnly = $True
	$textbox232.RightToLeft = 'No'
	$textbox232.Size = New-Object System.Drawing.Size(89, 16)
	$textbox232.TabIndex = 26
	$textbox232.Text = '-'
	$textbox232.TextAlign = 'Right'
	#
	# labelCurrentSpeed
	#
	$labelCurrentSpeed.AutoSize = $True
	$labelCurrentSpeed.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelCurrentSpeed.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelCurrentSpeed.Location = New-Object System.Drawing.Point(15, 46)
	$labelCurrentSpeed.Margin = '4, 0, 4, 0'
	$labelCurrentSpeed.Name = 'labelCurrentSpeed'
	$labelCurrentSpeed.RightToLeft = 'No'
	$labelCurrentSpeed.Size = New-Object System.Drawing.Size(63, 16)
	$labelCurrentSpeed.TabIndex = 25
	$labelCurrentSpeed.Text = 'Current'
	#
	# labelGRAVITY
	#
	$labelGRAVITY.AutoSize = $True
	$labelGRAVITY.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelGRAVITY.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelGRAVITY.Location = New-Object System.Drawing.Point(15, 26)
	$labelGRAVITY.Margin = '4, 0, 4, 0'
	$labelGRAVITY.Name = 'labelGRAVITY'
	$labelGRAVITY.RightToLeft = 'No'
	$labelGRAVITY.Size = New-Object System.Drawing.Size(59, 16)
	$labelGRAVITY.TabIndex = 9
	$labelGRAVITY.Text = 'GRAVITY'
	#
	# groupbox45
	#
	$groupbox45.Controls.Add($label1013082)
	$groupbox45.Controls.Add($textbox228)
	$groupbox45.Controls.Add($label1013081)
	$groupbox45.Controls.Add($textbox227)
	$groupbox45.Controls.Add($labelBOmbMAXTIME)
	$groupbox45.Controls.Add($labelBombMAXDISTANCE)
	$groupbox45.Controls.Add($label1013077)
	$groupbox45.Controls.Add($label1013078)
	$groupbox45.Controls.Add($textbox224)
	$groupbox45.Controls.Add($textbox226)
	$groupbox45.Controls.Add($label1013079)
	$groupbox45.Controls.Add($label1013080)
	$groupbox45.BackColor = [System.Drawing.Color]::Black 
	$groupbox45.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox45.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox45.Location = New-Object System.Drawing.Point(24, 134)
	$groupbox45.Margin = '4, 3, 4, 3'
	$groupbox45.Name = 'groupbox45'
	$groupbox45.Padding = '4, 3, 4, 3'
	$groupbox45.RightToLeft = 'Yes'
	$groupbox45.Size = New-Object System.Drawing.Size(254, 115)
	$groupbox45.TabIndex = 75
	$groupbox45.TabStop = $False
	$groupbox45.Text = 'HEIGHT'
	#
	# label1013082
	#
	$label1013082.AutoSize = $True
	$label1013082.BackColor = [System.Drawing.Color]::Black 
	$label1013082.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013082.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013082.Location = New-Object System.Drawing.Point(234, 86)
	$label1013082.Margin = '4, 0, 4, 0'
	$label1013082.Name = 'label1013082'
	$label1013082.RightToLeft = 'No'
	$label1013082.Size = New-Object System.Drawing.Size(15, 16)
	$label1013082.TabIndex = 78
	$label1013082.Text = 'm'
	#
	# textbox228
	#
	$textbox228.BackColor = [System.Drawing.Color]::Black 
	$textbox228.BorderStyle = 'None'
	$textbox228.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox228.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox228.Location = New-Object System.Drawing.Point(167, 87)
	$textbox228.Margin = '0, 0, 0, 0'
	$textbox228.Name = 'textbox228'
	$textbox228.ReadOnly = $True
	$textbox228.RightToLeft = 'No'
	$textbox228.Size = New-Object System.Drawing.Size(63, 16)
	$textbox228.TabIndex = 77
	$textbox228.Text = '30000'
	$textbox228.TextAlign = 'Right'
	#
	# label1013081
	#
	$label1013081.AutoSize = $True
	$label1013081.BackColor = [System.Drawing.Color]::Black 
	$label1013081.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013081.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013081.Location = New-Object System.Drawing.Point(234, 66)
	$label1013081.Margin = '4, 0, 4, 0'
	$label1013081.Name = 'label1013081'
	$label1013081.RightToLeft = 'No'
	$label1013081.Size = New-Object System.Drawing.Size(15, 16)
	$label1013081.TabIndex = 76
	$label1013081.Text = 'm'
	#
	# textbox227
	#
	$textbox227.BackColor = [System.Drawing.Color]::Black 
	$textbox227.BorderStyle = 'None'
	$textbox227.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox227.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox227.Location = New-Object System.Drawing.Point(167, 67)
	$textbox227.Margin = '0, 0, 0, 0'
	$textbox227.Name = 'textbox227'
	$textbox227.ReadOnly = $True
	$textbox227.RightToLeft = 'No'
	$textbox227.Size = New-Object System.Drawing.Size(63, 16)
	$textbox227.TabIndex = 75
	$textbox227.Text = '-'
	$textbox227.TextAlign = 'Right'
	#
	# labelBOmbMAXTIME
	#
	$labelBOmbMAXTIME.AutoSize = $True
	$labelBOmbMAXTIME.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelBOmbMAXTIME.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelBOmbMAXTIME.Location = New-Object System.Drawing.Point(15, 86)
	$labelBOmbMAXTIME.Margin = '4, 0, 4, 0'
	$labelBOmbMAXTIME.Name = 'labelBOmbMAXTIME'
	$labelBOmbMAXTIME.RightToLeft = 'No'
	$labelBOmbMAXTIME.Size = New-Object System.Drawing.Size(99, 16)
	$labelBOmbMAXTIME.TabIndex = 74
	$labelBOmbMAXTIME.Text = 'BOmb lifetime'
	#
	# labelBombMAXDISTANCE
	#
	$labelBombMAXDISTANCE.AutoSize = $True
	$labelBombMAXDISTANCE.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelBombMAXDISTANCE.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelBombMAXDISTANCE.Location = New-Object System.Drawing.Point(15, 66)
	$labelBombMAXDISTANCE.Margin = '4, 0, 4, 0'
	$labelBombMAXDISTANCE.Name = 'labelBombMAXDISTANCE'
	$labelBombMAXDISTANCE.RightToLeft = 'No'
	$labelBombMAXDISTANCE.Size = New-Object System.Drawing.Size(47, 16)
	$labelBombMAXDISTANCE.TabIndex = 73
	$labelBombMAXDISTANCE.Text = 'Delta'
	#
	# label1013077
	#
	$label1013077.AutoSize = $True
	$label1013077.BackColor = [System.Drawing.Color]::Black 
	$label1013077.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013077.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013077.Location = New-Object System.Drawing.Point(234, 24)
	$label1013077.Margin = '4, 0, 4, 0'
	$label1013077.Name = 'label1013077'
	$label1013077.RightToLeft = 'No'
	$label1013077.Size = New-Object System.Drawing.Size(15, 16)
	$label1013077.TabIndex = 72
	$label1013077.Text = 'm'
	#
	# label1013078
	#
	$label1013078.AutoSize = $True
	$label1013078.BackColor = [System.Drawing.Color]::Black 
	$label1013078.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013078.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013078.Location = New-Object System.Drawing.Point(234, 45)
	$label1013078.Margin = '4, 0, 4, 0'
	$label1013078.Name = 'label1013078'
	$label1013078.RightToLeft = 'No'
	$label1013078.Size = New-Object System.Drawing.Size(15, 16)
	$label1013078.TabIndex = 71
	$label1013078.Text = 'm'
	#
	# textbox224
	#
	$textbox224.BackColor = [System.Drawing.Color]::Black 
	$textbox224.BorderStyle = 'None'
	$textbox224.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox224.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox224.Location = New-Object System.Drawing.Point(167, 24)
	$textbox224.Margin = '0, 0, 0, 0'
	$textbox224.Name = 'textbox224'
	$textbox224.ReadOnly = $True
	$textbox224.RightToLeft = 'No'
	$textbox224.Size = New-Object System.Drawing.Size(63, 16)
	$textbox224.TabIndex = 28
	$textbox224.Text = '-'
	$textbox224.TextAlign = 'Right'
	#
	# textbox226
	#
	$textbox226.BackColor = [System.Drawing.Color]::Black 
	$textbox226.BorderStyle = 'None'
	$textbox226.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox226.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox226.Location = New-Object System.Drawing.Point(167, 46)
	$textbox226.Margin = '0, 0, 0, 0'
	$textbox226.Name = 'textbox226'
	$textbox226.ReadOnly = $True
	$textbox226.RightToLeft = 'No'
	$textbox226.Size = New-Object System.Drawing.Size(63, 16)
	$textbox226.TabIndex = 26
	$textbox226.Text = '-'
	$textbox226.TextAlign = 'Right'
	#
	# label1013079
	#
	$label1013079.AutoSize = $True
	$label1013079.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013079.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013079.Location = New-Object System.Drawing.Point(15, 46)
	$label1013079.Margin = '4, 0, 4, 0'
	$label1013079.Name = 'label1013079'
	$label1013079.RightToLeft = 'No'
	$label1013079.Size = New-Object System.Drawing.Size(87, 16)
	$label1013079.TabIndex = 25
	$label1013079.Text = 'dESTINATION'
	#
	# label1013080
	#
	$label1013080.AutoSize = $True
	$label1013080.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013080.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013080.Location = New-Object System.Drawing.Point(15, 26)
	$label1013080.Margin = '4, 0, 4, 0'
	$label1013080.Name = 'label1013080'
	$label1013080.RightToLeft = 'No'
	$label1013080.Size = New-Object System.Drawing.Size(55, 16)
	$label1013080.TabIndex = 9
	$label1013080.Text = 'PLayer'
	#
	# groupbox44
	#
	$groupbox44.Controls.Add($labelWEST)
	$groupbox44.Controls.Add($labelEast)
	$groupbox44.Controls.Add($labelSOUTH)
	$groupbox44.Controls.Add($labelNORTH)
	$groupbox44.Controls.Add($label1013069)
	$groupbox44.Controls.Add($label1013070)
	$groupbox44.Controls.Add($label1013071)
	$groupbox44.Controls.Add($label1013072)
	$groupbox44.Controls.Add($textbox220)
	$groupbox44.Controls.Add($textbox221)
	$groupbox44.Controls.Add($textbox222)
	$groupbox44.Controls.Add($labelLongitudinal)
	$groupbox44.Controls.Add($textbox223)
	$groupbox44.Controls.Add($labelLATERAL)
	$groupbox44.BackColor = [System.Drawing.Color]::Black 
	$groupbox44.Font = [System.Drawing.Font]::new('Dungeon', '9.75')
	$groupbox44.ForeColor = [System.Drawing.Color]::DarkOrange 
	$groupbox44.Location = New-Object System.Drawing.Point(24, 29)
	$groupbox44.Margin = '4, 3, 4, 3'
	$groupbox44.Name = 'groupbox44'
	$groupbox44.Padding = '4, 3, 4, 3'
	$groupbox44.RightToLeft = 'Yes'
	$groupbox44.Size = New-Object System.Drawing.Size(394, 81)
	$groupbox44.TabIndex = 51
	$groupbox44.TabStop = $False
	$groupbox44.Text = 'DROP DISTANCES'
	#
	# labelWEST
	#
	$labelWEST.AutoSize = $True
	$labelWEST.BackColor = [System.Drawing.Color]::Black 
	$labelWEST.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelWEST.ForeColor = [System.Drawing.Color]::FromArgb(255, 250, 50, 50)
	$labelWEST.Location = New-Object System.Drawing.Point(323, 49)
	$labelWEST.Margin = '4, 0, 4, 0'
	$labelWEST.Name = 'labelWEST'
	$labelWEST.RightToLeft = 'No'
	$labelWEST.Size = New-Object System.Drawing.Size(46, 16)
	$labelWEST.TabIndex = 78
	$labelWEST.Text = '-WEST'
	#
	# labelEast
	#
	$labelEast.AutoSize = $True
	$labelEast.BackColor = [System.Drawing.Color]::Black 
	$labelEast.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelEast.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$labelEast.Location = New-Object System.Drawing.Point(257, 49)
	$labelEast.Margin = '4, 0, 4, 0'
	$labelEast.Name = 'labelEast'
	$labelEast.RightToLeft = 'No'
	$labelEast.Size = New-Object System.Drawing.Size(46, 16)
	$labelEast.TabIndex = 77
	$labelEast.Text = '+East'
	#
	# labelSOUTH
	#
	$labelSOUTH.AutoSize = $True
	$labelSOUTH.BackColor = [System.Drawing.Color]::Black 
	$labelSOUTH.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSOUTH.ForeColor = [System.Drawing.Color]::FromArgb(255, 250, 50, 50)
	$labelSOUTH.Location = New-Object System.Drawing.Point(323, 27)
	$labelSOUTH.Margin = '4, 0, 4, 0'
	$labelSOUTH.Name = 'labelSOUTH'
	$labelSOUTH.RightToLeft = 'No'
	$labelSOUTH.Size = New-Object System.Drawing.Size(54, 16)
	$labelSOUTH.TabIndex = 76
	$labelSOUTH.Text = '-SOUTH'
	#
	# labelNORTH
	#
	$labelNORTH.AutoSize = $True
	$labelNORTH.BackColor = [System.Drawing.Color]::Black 
	$labelNORTH.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelNORTH.ForeColor = [System.Drawing.Color]::FromArgb(255, 50, 250, 50)
	$labelNORTH.Location = New-Object System.Drawing.Point(257, 27)
	$labelNORTH.Margin = '4, 0, 4, 0'
	$labelNORTH.Name = 'labelNORTH'
	$labelNORTH.RightToLeft = 'No'
	$labelNORTH.Size = New-Object System.Drawing.Size(54, 16)
	$labelNORTH.TabIndex = 75
	$labelNORTH.Text = '+NORTH'
	#
	# label1013069
	#
	$label1013069.AutoSize = $True
	$label1013069.BackColor = [System.Drawing.Color]::Black 
	$label1013069.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013069.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013069.Location = New-Object System.Drawing.Point(181, 48)
	$label1013069.Margin = '4, 0, 4, 0'
	$label1013069.Name = 'label1013069'
	$label1013069.RightToLeft = 'No'
	$label1013069.Size = New-Object System.Drawing.Size(23, 16)
	$label1013069.TabIndex = 74
	$label1013069.Text = 'Km'
	#
	# label1013070
	#
	$label1013070.AutoSize = $True
	$label1013070.BackColor = [System.Drawing.Color]::Black 
	$label1013070.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013070.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013070.Location = New-Object System.Drawing.Point(180, 27)
	$label1013070.Margin = '4, 0, 4, 0'
	$label1013070.Name = 'label1013070'
	$label1013070.RightToLeft = 'No'
	$label1013070.Size = New-Object System.Drawing.Size(23, 16)
	$label1013070.TabIndex = 73
	$label1013070.Text = 'Km'
	#
	# label1013071
	#
	$label1013071.AutoSize = $True
	$label1013071.BackColor = [System.Drawing.Color]::Black 
	$label1013071.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013071.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013071.Location = New-Object System.Drawing.Point(234, 27)
	$label1013071.Margin = '4, 0, 4, 0'
	$label1013071.Name = 'label1013071'
	$label1013071.RightToLeft = 'No'
	$label1013071.Size = New-Object System.Drawing.Size(15, 16)
	$label1013071.TabIndex = 72
	$label1013071.Text = 'm'
	#
	# label1013072
	#
	$label1013072.AutoSize = $True
	$label1013072.BackColor = [System.Drawing.Color]::Black 
	$label1013072.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$label1013072.ForeColor = [System.Drawing.Color]::DarkGray 
	$label1013072.Location = New-Object System.Drawing.Point(234, 48)
	$label1013072.Margin = '4, 0, 4, 0'
	$label1013072.Name = 'label1013072'
	$label1013072.RightToLeft = 'No'
	$label1013072.Size = New-Object System.Drawing.Size(15, 16)
	$label1013072.TabIndex = 71
	$label1013072.Text = 'm'
	#
	# textbox220
	#
	$textbox220.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox220.BorderStyle = 'None'
	$textbox220.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox220.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox220.Location = New-Object System.Drawing.Point(203, 27)
	$textbox220.Margin = '0, 0, 0, 0'
	$textbox220.Name = 'textbox220'
	$textbox220.ReadOnly = $True
	$textbox220.RightToLeft = 'No'
	$textbox220.Size = New-Object System.Drawing.Size(27, 16)
	$textbox220.TabIndex = 28
	$textbox220.Text = '-'
	$textbox220.TextAlign = 'Right'
	#
	# textbox221
	#
	$textbox221.BackColor = [System.Drawing.Color]::Black 
	$textbox221.BorderStyle = 'None'
	$textbox221.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox221.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox221.Location = New-Object System.Drawing.Point(114, 27)
	$textbox221.Margin = '0, 0, 0, 0'
	$textbox221.Name = 'textbox221'
	$textbox221.ReadOnly = $True
	$textbox221.RightToLeft = 'No'
	$textbox221.Size = New-Object System.Drawing.Size(63, 16)
	$textbox221.TabIndex = 27
	$textbox221.Text = '-'
	$textbox221.TextAlign = 'Right'
	#
	# textbox222
	#
	$textbox222.BackColor = [System.Drawing.Color]::FromArgb(255, 16, 16, 16)
	$textbox222.BorderStyle = 'None'
	$textbox222.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox222.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox222.Location = New-Object System.Drawing.Point(203, 49)
	$textbox222.Margin = '0, 0, 0, 0'
	$textbox222.Name = 'textbox222'
	$textbox222.ReadOnly = $True
	$textbox222.RightToLeft = 'No'
	$textbox222.Size = New-Object System.Drawing.Size(27, 16)
	$textbox222.TabIndex = 26
	$textbox222.Text = '-'
	$textbox222.TextAlign = 'Right'
	#
	# labelLongitudinal
	#
	$labelLongitudinal.AutoSize = $True
	$labelLongitudinal.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelLongitudinal.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelLongitudinal.Location = New-Object System.Drawing.Point(15, 49)
	$labelLongitudinal.Margin = '4, 0, 4, 0'
	$labelLongitudinal.Name = 'labelLongitudinal'
	$labelLongitudinal.RightToLeft = 'No'
	$labelLongitudinal.Size = New-Object System.Drawing.Size(95, 16)
	$labelLongitudinal.TabIndex = 25
	$labelLongitudinal.Text = 'Longitudinal'
	#
	# textbox223
	#
	$textbox223.BackColor = [System.Drawing.Color]::Black 
	$textbox223.BorderStyle = 'None'
	$textbox223.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox223.ForeColor = [System.Drawing.Color]::FromArgb(255, 230, 230, 230)
	$textbox223.Location = New-Object System.Drawing.Point(114, 49)
	$textbox223.Margin = '0, 0, 0, 0'
	$textbox223.Name = 'textbox223'
	$textbox223.ReadOnly = $True
	$textbox223.RightToLeft = 'No'
	$textbox223.Size = New-Object System.Drawing.Size(63, 16)
	$textbox223.TabIndex = 24
	$textbox223.Text = '-'
	$textbox223.TextAlign = 'Right'
	#
	# labelLATERAL
	#
	$labelLATERAL.AutoSize = $True
	$labelLATERAL.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelLATERAL.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelLATERAL.Location = New-Object System.Drawing.Point(15, 29)
	$labelLATERAL.Margin = '4, 0, 4, 0'
	$labelLATERAL.Name = 'labelLATERAL'
	$labelLATERAL.RightToLeft = 'No'
	$labelLATERAL.Size = New-Object System.Drawing.Size(63, 16)
	$labelLATERAL.TabIndex = 9
	$labelLATERAL.Text = 'LATERAL'
	#
	# picturebox6
	#
	$picturebox6.Location = New-Object System.Drawing.Point(-4, 0)
	$picturebox6.Margin = '4, 3, 4, 3'
	$picturebox6.Name = 'picturebox6'
	$picturebox6.Size = New-Object System.Drawing.Size(1247, 537)
	$picturebox6.TabIndex = 1
	$picturebox6.TabStop = $False
	#
	# tabpage4
	#
	$tabpage4.Controls.Add($picturebox5)
	$tabpage4.BackColor = [System.Drawing.Color]::Black 
	$tabpage4.BackgroundImageLayout = 'Stretch'
	$tabpage4.Cursor = 'Default'
	$tabpage4.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage4.Margin = '4, 3, 4, 3'
	$tabpage4.Name = 'tabpage4'
	$tabpage4.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage4.TabIndex = 3
	$tabpage4.Text = 'System Map'
	#
	# picturebox5
	#
	$picturebox5.BackColor = [System.Drawing.Color]::Transparent 
	$picturebox5.BackgroundImageLayout = 'Stretch'
	$picturebox5.Dock = 'Fill'
	$picturebox5.Location = New-Object System.Drawing.Point(0, 0)
	$picturebox5.Margin = '4, 3, 4, 3'
	$picturebox5.Name = 'picturebox5'
	$picturebox5.Size = New-Object System.Drawing.Size(1247, 577)
	$picturebox5.SizeMode = 'StretchImage'
	$picturebox5.TabIndex = 0
	$picturebox5.TabStop = $False
	#
	# tabpage6
	#
	$tabpage6.Controls.Add($picturebox4)
	$tabpage6.BackColor = [System.Drawing.Color]::Black 
	$tabpage6.Cursor = 'Default'
	$tabpage6.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage6.Margin = '4, 3, 4, 3'
	$tabpage6.Name = 'tabpage6'
	$tabpage6.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage6.TabIndex = 5
	$tabpage6.Text = 'Planet Map'
	#
	# picturebox4
	#
	$picturebox4.BackColor = [System.Drawing.Color]::ForestGreen 
	$picturebox4.BackgroundImageLayout = 'Stretch'
	$picturebox4.Dock = 'Fill'
	$picturebox4.Location = New-Object System.Drawing.Point(0, 0)
	$picturebox4.Margin = '4, 3, 4, 3'
	$picturebox4.Name = 'picturebox4'
	$picturebox4.Size = New-Object System.Drawing.Size(1247, 577)
	$picturebox4.TabIndex = 0
	$picturebox4.TabStop = $False
	#
	# tabpage7
	#
	$tabpage7.Controls.Add($picturebox3)
	$tabpage7.BackColor = [System.Drawing.Color]::Black 
	$tabpage7.Cursor = 'Default'
	$tabpage7.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage7.Margin = '4, 3, 4, 3'
	$tabpage7.Name = 'tabpage7'
	$tabpage7.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage7.TabIndex = 6
	$tabpage7.Text = 'Local Map'
	#
	# picturebox3
	#
	$picturebox3.BackColor = [System.Drawing.Color]::SaddleBrown 
	$picturebox3.BackgroundImageLayout = 'Stretch'
	$picturebox3.Dock = 'Fill'
	$picturebox3.Location = New-Object System.Drawing.Point(0, 0)
	$picturebox3.Margin = '4, 3, 4, 3'
	$picturebox3.Name = 'picturebox3'
	$picturebox3.Size = New-Object System.Drawing.Size(1247, 577)
	$picturebox3.TabIndex = 0
	$picturebox3.TabStop = $False
	#
	# tabpage10
	#
	$tabpage10.Controls.Add($datagridview2)
	$tabpage10.Controls.Add($datagridview1)
	$tabpage10.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$tabpage10.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage10.Margin = '4, 3, 4, 3'
	$tabpage10.Name = 'tabpage10'
	$tabpage10.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage10.TabIndex = 9
	$tabpage10.Text = 'Versions'
	#
	# datagridview2
	#
	$datagridview2.AutoSizeColumnsMode = 'Fill'
	$datagridview2.BorderStyle = 'None'
	$datagridview2.ColumnHeadersBorderStyle = 'None'
	$datagridview2.ColumnHeadersHeightSizeMode = 'AutoSize'
	[void]$datagridview2.Columns.Add($Version)
	[void]$datagridview2.Columns.Add($Releases)
	[void]$datagridview2.Columns.Add($Durations)
	[void]$datagridview2.Columns.Add($Resets)
	[void]$datagridview2.Columns.Add($Contents)
	$datagridview2.Location = New-Object System.Drawing.Point(0, 0)
	$datagridview2.Margin = '4, 3, 4, 3'
	$datagridview2.Name = 'datagridview2'
	$datagridview2.ScrollBars = 'None'
	$datagridview2.Size = New-Object System.Drawing.Size(1242, 26)
	$datagridview2.TabIndex = 1
	$datagridview2.add_CellContentClick($datagridview2_CellContentClick)
	#
	# datagridview1
	#
	$datagridview1.AutoSizeColumnsMode = 'Fill'
	$datagridview1.BorderStyle = 'None'
	$datagridview1.ColumnHeadersHeightSizeMode = 'AutoSize'
	[void]$datagridview1.Columns.Add($Major)
	[void]$datagridview1.Columns.Add($i)
	[void]$datagridview1.Columns.Add($l)
	[void]$datagridview1.Columns.Add($Build)
	[void]$datagridview1.Columns.Add($Evocati)
	[void]$datagridview1.Columns.Add($Wave1)
	[void]$datagridview1.Columns.Add($PTUPublic)
	[void]$datagridview1.Columns.Add($Live)
	[void]$datagridview1.Columns.Add($Time)
	[void]$datagridview1.Columns.Add($Day)
	[void]$datagridview1.Columns.Add($EvocatiPhase)
	[void]$datagridview1.Columns.Add($Wave1Phase)
	[void]$datagridview1.Columns.Add($PTUPublicPhase)
	[void]$datagridview1.Columns.Add($Release)
	[void]$datagridview1.Columns.Add($Resets2)
	[void]$datagridview1.Columns.Add($Ships)
	[void]$datagridview1.Columns.Add($Features)
	$datagridview1.GridColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$datagridview1.Location = New-Object System.Drawing.Point(0, 26)
	$datagridview1.Margin = '4, 3, 4, 3'
	$datagridview1.MultiSelect = $False
	$datagridview1.Name = 'datagridview1'
	$datagridview1.ReadOnly = $True
	$datagridview1.RowHeadersWidthSizeMode = 'DisableResizing'
	$System_Windows_Forms_DataGridViewCellStyle_1 = New-Object 'System.Windows.Forms.DataGridViewCellStyle'
	$System_Windows_Forms_DataGridViewCellStyle_1.Alignment = 'MiddleCenter'
	$datagridview1.RowsDefaultCellStyle = $System_Windows_Forms_DataGridViewCellStyle_1
	$datagridview1.SelectionMode = 'FullRowSelect'
	$datagridview1.Size = New-Object System.Drawing.Size(1243, 511)
	$datagridview1.TabIndex = 0
	$datagridview1.add_CellContentClick($datagridview1_CellContentClick)
	#
	# tabpage8
	#
	$tabpage8.Controls.Add($buttonDebugMode)
	$tabpage8.Controls.Add($textbox242)
	$tabpage8.Controls.Add($labelLimits)
	$tabpage8.Controls.Add($labelScript)
	$tabpage8.Controls.Add($labelFunctions)
	$tabpage8.Controls.Add($labelDatapointsOnPlanetMa)
	$tabpage8.Controls.Add($labelDatapointsOnSystemMa)
	$tabpage8.Controls.Add($textbox239)
	$tabpage8.Controls.Add($textbox238)
	$tabpage8.Controls.Add($buttonAutoRunToggle)
	$tabpage8.Controls.Add($buttonToggleIngameOverlay)
	$tabpage8.Controls.Add($buttonClearStarCitizenCach)
	$tabpage8.Controls.Add($buttonAntiLogoffScript)
	$tabpage8.Controls.Add($buttonShowLocationHotKey)
	$tabpage8.Controls.Add($picturebox9)
	$tabpage8.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$tabpage8.Cursor = 'Default'
	$tabpage8.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage8.Margin = '4, 3, 4, 3'
	$tabpage8.Name = 'tabpage8'
	$tabpage8.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage8.TabIndex = 7
	$tabpage8.Text = 'Settings'
	#
	# buttonDebugMode
	#
	$buttonDebugMode.BackColor = [System.Drawing.Color]::Black 
	$buttonDebugMode.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$buttonDebugMode.Location = New-Object System.Drawing.Point(25, 407)
	$buttonDebugMode.Margin = '4, 3, 4, 3'
	$buttonDebugMode.Name = 'buttonDebugMode'
	$buttonDebugMode.Size = New-Object System.Drawing.Size(140, 44)
	$buttonDebugMode.TabIndex = 42
	$buttonDebugMode.Text = 'Debug Mode'
	$buttonDebugMode.UseVisualStyleBackColor = $False
	$buttonDebugMode.add_Click($buttonDebugMode_Click)
	#
	# textbox242
	#
	$textbox242.BackColor = [System.Drawing.Color]::FromArgb(255, 32, 32, 32)
	$textbox242.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$textbox242.ForeColor = [System.Drawing.SystemColors]::Control 
	$textbox242.Location = New-Object System.Drawing.Point(693, 21)
	$textbox242.Margin = '4, 3, 4, 3'
	$textbox242.Multiline = $True
	$textbox242.Name = 'textbox242'
	$textbox242.ReadOnly = $True
	$textbox242.Size = New-Object System.Drawing.Size(524, 457)
	$textbox242.TabIndex = 41
	$textbox242.Text = 'Debug WIndow'
	#
	# labelLimits
	#
	$labelLimits.AutoSize = $True
	$labelLimits.BackColor = [System.Drawing.Color]::Transparent 
	$labelLimits.Font = [System.Drawing.Font]::new('Dungeon', '15.75', [System.Drawing.FontStyle]'Bold')
	$labelLimits.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelLimits.Location = New-Object System.Drawing.Point(456, 19)
	$labelLimits.Margin = '4, 0, 4, 0'
	$labelLimits.Name = 'labelLimits'
	$labelLimits.Size = New-Object System.Drawing.Size(86, 23)
	$labelLimits.TabIndex = 40
	$labelLimits.Text = 'Limits'
	#
	# labelScript
	#
	$labelScript.AutoSize = $True
	$labelScript.BackColor = [System.Drawing.Color]::Transparent 
	$labelScript.Font = [System.Drawing.Font]::new('Dungeon', '15.75', [System.Drawing.FontStyle]'Bold')
	$labelScript.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelScript.Location = New-Object System.Drawing.Point(231, 19)
	$labelScript.Margin = '4, 0, 4, 0'
	$labelScript.Name = 'labelScript'
	$labelScript.Size = New-Object System.Drawing.Size(82, 23)
	$labelScript.TabIndex = 39
	$labelScript.Text = 'Script'
	#
	# labelFunctions
	#
	$labelFunctions.AutoSize = $True
	$labelFunctions.BackColor = [System.Drawing.Color]::Transparent 
	$labelFunctions.Font = [System.Drawing.Font]::new('Dungeon', '15.75', [System.Drawing.FontStyle]'Bold')
	$labelFunctions.ForeColor = [System.Drawing.Color]::DarkOrange 
	$labelFunctions.Location = New-Object System.Drawing.Point(48, 19)
	$labelFunctions.Margin = '4, 0, 4, 0'
	$labelFunctions.Name = 'labelFunctions'
	$labelFunctions.Size = New-Object System.Drawing.Size(83, 23)
	$labelFunctions.TabIndex = 38
	$labelFunctions.Text = 'Game'
	#
	# labelDatapointsOnPlanetMa
	#
	$labelDatapointsOnPlanetMa.AutoSize = $True
	$labelDatapointsOnPlanetMa.BackColor = [System.Drawing.Color]::Black 
	$labelDatapointsOnPlanetMa.ForeColor = [System.Drawing.Color]::Snow 
	$labelDatapointsOnPlanetMa.Location = New-Object System.Drawing.Point(392, 96)
	$labelDatapointsOnPlanetMa.Margin = '4, 0, 4, 0'
	$labelDatapointsOnPlanetMa.Name = 'labelDatapointsOnPlanetMa'
	$labelDatapointsOnPlanetMa.Size = New-Object System.Drawing.Size(190, 15)
	$labelDatapointsOnPlanetMa.TabIndex = 10
	$labelDatapointsOnPlanetMa.Text = 'Datapoints on PlanetMap'
	#
	# labelDatapointsOnSystemMa
	#
	$labelDatapointsOnSystemMa.AutoSize = $True
	$labelDatapointsOnSystemMa.BackColor = [System.Drawing.Color]::Black 
	$labelDatapointsOnSystemMa.ForeColor = [System.Drawing.Color]::White 
	$labelDatapointsOnSystemMa.Location = New-Object System.Drawing.Point(392, 67)
	$labelDatapointsOnSystemMa.Margin = '4, 0, 4, 0'
	$labelDatapointsOnSystemMa.Name = 'labelDatapointsOnSystemMa'
	$labelDatapointsOnSystemMa.Size = New-Object System.Drawing.Size(200, 15)
	$labelDatapointsOnSystemMa.TabIndex = 9
	$labelDatapointsOnSystemMa.Text = 'Datapoints on SystemMap'
	#
	# textbox239
	#
	$textbox239.BackColor = [System.Drawing.Color]::Black 
	$textbox239.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$textbox239.Location = New-Object System.Drawing.Point(600, 93)
	$textbox239.Margin = '4, 3, 4, 3'
	$textbox239.Name = 'textbox239'
	$textbox239.RightToLeft = 'Yes'
	$textbox239.Size = New-Object System.Drawing.Size(55, 22)
	$textbox239.TabIndex = 8
	$textbox239.Text = '100'
	#
	# textbox238
	#
	$textbox238.BackColor = [System.Drawing.Color]::Black 
	$textbox238.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$textbox238.Location = New-Object System.Drawing.Point(600, 64)
	$textbox238.Margin = '4, 3, 4, 3'
	$textbox238.Name = 'textbox238'
	$textbox238.RightToLeft = 'Yes'
	$textbox238.Size = New-Object System.Drawing.Size(55, 22)
	$textbox238.TabIndex = 7
	$textbox238.Text = '10'
	#
	# buttonAutoRunToggle
	#
	$buttonAutoRunToggle.BackColor = [System.Drawing.Color]::Black 
	$buttonAutoRunToggle.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$buttonAutoRunToggle.Location = New-Object System.Drawing.Point(25, 188)
	$buttonAutoRunToggle.Margin = '4, 3, 4, 3'
	$buttonAutoRunToggle.Name = 'buttonAutoRunToggle'
	$buttonAutoRunToggle.Size = New-Object System.Drawing.Size(140, 44)
	$buttonAutoRunToggle.TabIndex = 5
	$buttonAutoRunToggle.Text = 'AutoRun Toggle'
	$tooltip.SetToolTip($buttonAutoRunToggle, 'Enables to toggle Autorun by tapping W twice (continiously sends w key)
Stops if W or S is pressed again')
	$buttonAutoRunToggle.UseVisualStyleBackColor = $False
	$buttonAutoRunToggle.add_Click($buttonAutoRunToggle_Click)
	#
	# buttonToggleIngameOverlay
	#
	$buttonToggleIngameOverlay.BackColor = [System.Drawing.Color]::Black 
	$buttonToggleIngameOverlay.ForeColor = [System.Drawing.Color]::Red 
	$buttonToggleIngameOverlay.Location = New-Object System.Drawing.Point(202, 67)
	$buttonToggleIngameOverlay.Margin = '4, 3, 4, 3'
	$buttonToggleIngameOverlay.Name = 'buttonToggleIngameOverlay'
	$buttonToggleIngameOverlay.Size = New-Object System.Drawing.Size(140, 44)
	$buttonToggleIngameOverlay.TabIndex = 4
	$buttonToggleIngameOverlay.Text = 'Toggle Ingame Overlay'
	$tooltip.SetToolTip($buttonToggleIngameOverlay, 'Enables or disables the ingame overlay. Actual Status is shown in 
red=disabled
green = enabled
white = default (enabled)')
	$buttonToggleIngameOverlay.UseVisualStyleBackColor = $False
	$buttonToggleIngameOverlay.add_Click($buttonToggleIngameOverlay_Click)
	#
	# buttonClearStarCitizenCach
	#
	$buttonClearStarCitizenCach.BackColor = [System.Drawing.Color]::Black 
	$buttonClearStarCitizenCach.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$buttonClearStarCitizenCach.Location = New-Object System.Drawing.Point(25, 251)
	$buttonClearStarCitizenCach.Margin = '4, 3, 4, 3'
	$buttonClearStarCitizenCach.Name = 'buttonClearStarCitizenCach'
	$buttonClearStarCitizenCach.Size = New-Object System.Drawing.Size(140, 44)
	$buttonClearStarCitizenCach.TabIndex = 3
	$buttonClearStarCitizenCach.Text = 'Clear StarCitizen Cache'
	$tooltip.SetToolTip($buttonClearStarCitizenCach, 'Removes all folders that contain cache files from StarCitizen. Please close game and launcher before. 
Uses the gamedir of the last session only (LIVE/PTU)

The following folders are cleaned up:
*appdata\roaming\rsilauncher\Cache
*appdata\roaming\rsilauncher\GPUCache
*appdata\local\Star Citizen
*GameDir\USER\Client\0\shaders\cache

')
	$buttonClearStarCitizenCach.UseVisualStyleBackColor = $False
	$buttonClearStarCitizenCach.add_Click($buttonClearStarCitizenCach_Click)
	#
	# buttonAntiLogoffScript
	#
	$buttonAntiLogoffScript.BackColor = [System.Drawing.Color]::Black 
	$buttonAntiLogoffScript.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$buttonAntiLogoffScript.Location = New-Object System.Drawing.Point(25, 127)
	$buttonAntiLogoffScript.Margin = '4, 3, 4, 3'
	$buttonAntiLogoffScript.Name = 'buttonAntiLogoffScript'
	$buttonAntiLogoffScript.Size = New-Object System.Drawing.Size(140, 44)
	$buttonAntiLogoffScript.TabIndex = 2
	$buttonAntiLogoffScript.Text = 'AntiLogoffScript'
	$tooltip.SetToolTip($buttonAntiLogoffScript, 'Prevents User logoff due to inactivity. Suitable to record timelapses or if you have to wait on atmo esport events agin :-)
Toggles F12 (chat visibility) twice on a random intervall')
	$buttonAntiLogoffScript.UseVisualStyleBackColor = $False
	$buttonAntiLogoffScript.add_Click($buttonAntiLogoffScript_Click)
	#
	# buttonShowLocationHotKey
	#
	$buttonShowLocationHotKey.BackColor = [System.Drawing.Color]::Black 
	$buttonShowLocationHotKey.ForeColor = [System.Drawing.SystemColors]::ButtonFace 
	$buttonShowLocationHotKey.Location = New-Object System.Drawing.Point(25, 67)
	$buttonShowLocationHotKey.Margin = '4, 3, 4, 3'
	$buttonShowLocationHotKey.Name = 'buttonShowLocationHotKey'
	$buttonShowLocationHotKey.Size = New-Object System.Drawing.Size(140, 44)
	$buttonShowLocationHotKey.TabIndex = 0
	$buttonShowLocationHotKey.Text = 'ShowLocation HotKey'
	$tooltip.SetToolTip($buttonShowLocationHotKey, 'Allows the user to issue the /shiowlocation debug command send via chat on a single keypress.
This command is necessary to update the script with the current igname position of the player.
Chat (F12) needs to be enabled')
	$buttonShowLocationHotKey.UseVisualStyleBackColor = $False
	$buttonShowLocationHotKey.add_Click($buttonShowLocationHotKey_Click)
	#
	# picturebox9
	#
	$picturebox9.BackColor = [System.Drawing.Color]::Transparent 
	$picturebox9.BackgroundImageLayout = 'Stretch'
	$picturebox9.Location = New-Object System.Drawing.Point(-4, 0)
	$picturebox9.Margin = '4, 3, 4, 3'
	$picturebox9.Name = 'picturebox9'
	$picturebox9.Size = New-Object System.Drawing.Size(1247, 537)
	$picturebox9.SizeMode = 'StretchImage'
	$picturebox9.TabIndex = 1
	$picturebox9.TabStop = $False
	#
	# tabpage5
	#
	$tabpage5.Controls.Add($richtextbox2)
	$tabpage5.BackColor = [System.Drawing.Color]::Black 
	$tabpage5.BackgroundImageLayout = 'Stretch'
	$tabpage5.Cursor = 'No'
	$tabpage5.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage5.Margin = '4, 3, 4, 3'
	$tabpage5.Name = 'tabpage5'
	$tabpage5.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage5.TabIndex = 4
	$tabpage5.Text = 'Manual'
	#
	# richtextbox2
	#
	$richtextbox2.BackColor = [System.Drawing.Color]::Black 
	$richtextbox2.CausesValidation = $False
	$richtextbox2.Cursor = 'Default'
	$richtextbox2.Location = New-Object System.Drawing.Point(-4, 0)
	$richtextbox2.Margin = '4, 3, 4, 3'
	$richtextbox2.Name = 'richtextbox2'
	$richtextbox2.ScrollBars = 'Vertical'
	$richtextbox2.Size = New-Object System.Drawing.Size(1246, 537)
	$richtextbox2.TabIndex = 0
	$richtextbox2.Text = ''
	#
	# tabpage9
	#
	$tabpage9.Controls.Add($richtextbox1)
	$tabpage9.Controls.Add($picturebox10)
	$tabpage9.Cursor = 'No'
	$tabpage9.ForeColor = [System.Drawing.Color]::DarkOrange 
	$tabpage9.Location = New-Object System.Drawing.Point(4, 24)
	$tabpage9.Margin = '4, 3, 4, 3'
	$tabpage9.Name = 'tabpage9'
	$tabpage9.Size = New-Object System.Drawing.Size(1247, 577)
	$tabpage9.TabIndex = 8
	$tabpage9.Text = 'About'
	$tabpage9.UseVisualStyleBackColor = $True
	#
	# richtextbox1
	#
	$richtextbox1.BackColor = [System.Drawing.Color]::Black 
	$richtextbox1.BorderStyle = 'None'
	$richtextbox1.CausesValidation = $False
	$richtextbox1.Cursor = 'IBeam'
	$richtextbox1.DetectUrls = $False
	$richtextbox1.Font = [System.Drawing.Font]::new('Imprint MT Shadow', '14.25')
	$richtextbox1.HideSelection = $False
	$richtextbox1.ImeMode = 'Off'
	$richtextbox1.Location = New-Object System.Drawing.Point(15, 7)
	$richtextbox1.Margin = '4, 3, 4, 3'
	$richtextbox1.MaximumSize = New-Object System.Drawing.Size(1136, 505)
	$richtextbox1.MinimumSize = New-Object System.Drawing.Size(1136, 505)
	$richtextbox1.Name = 'richtextbox1'
	$richtextbox1.ReadOnly = $True
	$richtextbox1.ScrollBars = 'Vertical'
	$richtextbox1.Size = New-Object System.Drawing.Size(1136, 505)
	$richtextbox1.TabIndex = 2
	$richtextbox1.Text = ''
	#
	# picturebox10
	#
	$picturebox10.BackColor = [System.Drawing.Color]::Black 
	$picturebox10.BackgroundImageLayout = 'Stretch'
	$picturebox10.Cursor = 'Default'
	$picturebox10.Dock = 'Fill'
	$picturebox10.Location = New-Object System.Drawing.Point(0, 0)
	$picturebox10.Margin = '4, 3, 4, 3'
	$picturebox10.Name = 'picturebox10'
	$picturebox10.Size = New-Object System.Drawing.Size(1247, 577)
	$picturebox10.SizeMode = 'StretchImage'
	$picturebox10.TabIndex = 3
	$picturebox10.TabStop = $False
	#
	# picturebox2
	#
	$picturebox2.BackColor = [System.Drawing.Color]::Transparent 
	$picturebox2.BackgroundImageLayout = 'None'
	$picturebox2.Location = New-Object System.Drawing.Point(-23, 12)
	$picturebox2.Margin = '4, 3, 4, 3'
	$picturebox2.Name = 'picturebox2'
	$picturebox2.Size = New-Object System.Drawing.Size(400, 101)
	$picturebox2.SizeMode = 'Zoom'
	$picturebox2.TabIndex = 4
	$picturebox2.TabStop = $False
	$tooltip.SetToolTip($picturebox2, 'Named after the Naval Station INS-Jericho the first purpose of this tool was
to reliably find Jericho back in the times where it had no quantum travel beacon.')
	#
	# tooltip
	#
	$tooltip.BackColor = [System.Drawing.Color]::Black 
	$tooltip.ForeColor = [System.Drawing.Color]::DarkOrange 
	#
	# contextmenustrip1
	#
	$contextmenustrip1.Name = 'contextmenustrip1'
	$contextmenustrip1.Size = New-Object System.Drawing.Size(61, 4)
	#
	# labelLocal
	#
	$labelLocal.AutoSize = $True
	$labelLocal.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelLocal.ForeColor = [System.Drawing.Color]::Gray 
	$labelLocal.Location = New-Object System.Drawing.Point(15, 40)
	$labelLocal.Margin = '4, 0, 4, 0'
	$labelLocal.Name = 'labelLocal'
	$labelLocal.RightToLeft = 'No'
	$labelLocal.Size = New-Object System.Drawing.Size(47, 16)
	$labelLocal.TabIndex = 10
	$labelLocal.Text = 'Local'
	#
	# labelUTC
	#
	$labelUTC.AutoSize = $True
	$labelUTC.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelUTC.ForeColor = [System.Drawing.Color]::Gray 
	$labelUTC.Location = New-Object System.Drawing.Point(15, 60)
	$labelUTC.Margin = '4, 0, 4, 0'
	$labelUTC.Name = 'labelUTC'
	$labelUTC.RightToLeft = 'No'
	$labelUTC.Size = New-Object System.Drawing.Size(31, 16)
	$labelUTC.TabIndex = 11
	$labelUTC.Text = 'UTC'
	#
	# labelSession
	#
	$labelSession.AutoSize = $True
	$labelSession.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelSession.ForeColor = [System.Drawing.Color]::Gray 
	$labelSession.Location = New-Object System.Drawing.Point(15, 40)
	$labelSession.Margin = '4, 0, 4, 0'
	$labelSession.Name = 'labelSession'
	$labelSession.RightToLeft = 'No'
	$labelSession.Size = New-Object System.Drawing.Size(59, 16)
	$labelSession.TabIndex = 10
	$labelSession.Text = 'Session'
	#
	# labelOm1
	#
	$labelOm1.AutoSize = $True
	$labelOm1.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOm1.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOm1.Location = New-Object System.Drawing.Point(18, 30)
	$labelOm1.Margin = '4, 0, 4, 0'
	$labelOm1.Name = 'labelOm1'
	$labelOm1.RightToLeft = 'No'
	$labelOm1.Size = New-Object System.Drawing.Size(38, 16)
	$labelOm1.TabIndex = 9
	$labelOm1.Text = 'Om-1'
	#
	# labelOm2
	#
	$labelOm2.AutoSize = $True
	$labelOm2.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOm2.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOm2.Location = New-Object System.Drawing.Point(18, 52)
	$labelOm2.Margin = '4, 0, 4, 0'
	$labelOm2.Name = 'labelOm2'
	$labelOm2.RightToLeft = 'No'
	$labelOm2.Size = New-Object System.Drawing.Size(38, 16)
	$labelOm2.TabIndex = 23
	$labelOm2.Text = 'Om-2'
	#
	# labelOM3
	#
	$labelOM3.AutoSize = $True
	$labelOM3.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOM3.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOM3.Location = New-Object System.Drawing.Point(18, 75)
	$labelOM3.Margin = '4, 0, 4, 0'
	$labelOM3.Name = 'labelOM3'
	$labelOM3.RightToLeft = 'No'
	$labelOM3.Size = New-Object System.Drawing.Size(38, 16)
	$labelOM3.TabIndex = 27
	$labelOM3.Text = 'OM-3'
	#
	# labelOm4
	#
	$labelOm4.AutoSize = $True
	$labelOm4.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOm4.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOm4.Location = New-Object System.Drawing.Point(18, 98)
	$labelOm4.Margin = '4, 0, 4, 0'
	$labelOm4.Name = 'labelOm4'
	$labelOm4.RightToLeft = 'No'
	$labelOm4.Size = New-Object System.Drawing.Size(38, 16)
	$labelOm4.TabIndex = 59
	$labelOm4.Text = 'Om-4'
	#
	# labelOm5
	#
	$labelOm5.AutoSize = $True
	$labelOm5.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOm5.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOm5.Location = New-Object System.Drawing.Point(18, 121)
	$labelOm5.Margin = '4, 0, 4, 0'
	$labelOm5.Name = 'labelOm5'
	$labelOm5.RightToLeft = 'No'
	$labelOm5.Size = New-Object System.Drawing.Size(38, 16)
	$labelOm5.TabIndex = 63
	$labelOm5.Text = 'Om-5'
	#
	# labelOm6
	#
	$labelOm6.AutoSize = $True
	$labelOm6.Font = [System.Drawing.Font]::new('Jericho-Digital', '12')
	$labelOm6.ForeColor = [System.Drawing.Color]::DarkGray 
	$labelOm6.Location = New-Object System.Drawing.Point(18, 144)
	$labelOm6.Margin = '4, 0, 4, 0'
	$labelOm6.Name = 'labelOm6'
	$labelOm6.RightToLeft = 'No'
	$labelOm6.Size = New-Object System.Drawing.Size(38, 16)
	$labelOm6.TabIndex = 67
	$labelOm6.Text = 'Om-6'
	#
	# Version
	#
	$Version.HeaderText = 'Version'
	$Version.Name = 'Version'
	#
	# Releases
	#
	$Releases.HeaderText = 'Releases'
	$Releases.Name = 'Releases'
	#
	# Durations
	#
	$Durations.HeaderText = 'Durations'
	$Durations.Name = 'Durations'
	#
	# Resets
	#
	$Resets.HeaderText = 'Resets'
	$Resets.Name = 'Resets'
	#
	# Contents
	#
	$Contents.HeaderText = 'Contents'
	$Contents.Name = 'Contents'
	#
	# Major
	#
	$Major.HeaderText = 'Major'
	$Major.Name = 'Major'
	$Major.ReadOnly = $True
	#
	# i
	#
	$i.HeaderText = 'Minor'
	$i.Name = 'i'
	$i.ReadOnly = $True
	#
	# l
	#
	$l.HeaderText = 'Patch'
	$l.Name = 'l'
	$l.ReadOnly = $True
	#
	# Build
	#
	$Build.HeaderText = 'Build'
	$Build.Name = 'Build'
	$Build.ReadOnly = $True
	#
	# Evocati
	#
	$Evocati.HeaderText = 'Evocati'
	$Evocati.Name = 'Evocati'
	$Evocati.ReadOnly = $True
	#
	# Wave1
	#
	$Wave1.HeaderText = 'Wave1'
	$Wave1.Name = 'Wave1'
	$Wave1.ReadOnly = $True
	#
	# PTUPublic
	#
	$PTUPublic.HeaderText = 'PTU Public'
	$PTUPublic.Name = 'PTUPublic'
	$PTUPublic.ReadOnly = $True
	#
	# Live
	#
	$Live.HeaderText = 'Live'
	$Live.Name = 'Live'
	$Live.ReadOnly = $True
	#
	# Time
	#
	$Time.HeaderText = 'Time'
	$Time.Name = 'Time'
	$Time.ReadOnly = $True
	#
	# Day
	#
	$Day.HeaderText = 'Day'
	$Day.Name = 'Day'
	$Day.ReadOnly = $True
	#
	# EvocatiPhase
	#
	$EvocatiPhase.HeaderText = 'Evocati'
	$EvocatiPhase.Name = 'EvocatiPhase'
	$EvocatiPhase.ReadOnly = $True
	#
	# Wave1Phase
	#
	$Wave1Phase.HeaderText = 'Wave1'
	$Wave1Phase.Name = 'Wave1Phase'
	$Wave1Phase.ReadOnly = $True
	#
	# PTUPublicPhase
	#
	$PTUPublicPhase.HeaderText = 'PTU Public'
	$PTUPublicPhase.Name = 'PTUPublicPhase'
	$PTUPublicPhase.ReadOnly = $True
	#
	# Release
	#
	$Release.HeaderText = 'Release'
	$Release.Name = 'Release'
	$Release.ReadOnly = $True
	#
	# Resets2
	#
	$Resets2.HeaderText = 'Resets'
	$Resets2.Name = 'Resets2'
	$Resets2.ReadOnly = $True
	#
	# Ships
	#
	$Ships.HeaderText = 'Ships'
	$Ships.Name = 'Ships'
	$Ships.ReadOnly = $True
	#
	# Features
	#
	$Features.HeaderText = 'Features'
	$Features.Name = 'Features'
	$Features.ReadOnly = $True
	$tabpage9.ResumeLayout()
	$tabpage5.ResumeLayout()
	$tabpage8.ResumeLayout()
	$tabpage10.ResumeLayout()
	$tabpage7.ResumeLayout()
	$tabpage6.ResumeLayout()
	$tabpage4.ResumeLayout()
	$groupbox44.ResumeLayout()
	$groupbox45.ResumeLayout()
	$groupbox46.ResumeLayout()
	$tabpage3.ResumeLayout()
	$groupbox29.ResumeLayout()
	$groupbox33.ResumeLayout()
	$groupbox30.ResumeLayout()
	$groupbox40.ResumeLayout()
	$groupbox31.ResumeLayout()
	$groupbox32.ResumeLayout()
	$groupbox41.ResumeLayout()
	$groupbox42.ResumeLayout()
	$groupbox26.ResumeLayout()
	$tabpage2.ResumeLayout()
	$groupbox1.ResumeLayout()
	$groupbox15.ResumeLayout()
	$groupbox16.ResumeLayout()
	$groupbox17.ResumeLayout()
	$groupbox18.ResumeLayout()
	$groupbox19.ResumeLayout()
	$groupbox20.ResumeLayout()
	$groupbox21.ResumeLayout()
	$groupbox22.ResumeLayout()
	$groupbox23.ResumeLayout()
	$groupbox25.ResumeLayout()
	$groupbox27.ResumeLayout()
	$tabpage1.ResumeLayout()
	$tabcontrol1.ResumeLayout()
	$groupbox24.ResumeLayout()
	$formProjectJericho.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formProjectJericho.WindowState

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName Microsoft.VisualBasic

# IMPORTANT: Save this file as UTF-8 for emoji support!

# XAML UI with neon theme and emoji sidebar
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="The Circle Utility" Height="700" Width="1200" WindowStartupLocation="CenterScreen" Background="#101828" ResizeMode="NoResize">
    <Window.Resources>
        <Style x:Key="NeonButton" TargetType="Button">
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="Foreground" Value="#00FFFF"/>
            <Setter Property="Background" Value="#222"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="Margin" Value="8,8,8,8"/>
            <Setter Property="Padding" Value="8,4"/>
            <Setter Property="BorderBrush" Value="#00FFFF"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="Effect">
                <Setter.Value>
                    <DropShadowEffect Color="#00FFFF" BlurRadius="12" ShadowDepth="0" Opacity="0.7"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="TabButton" TargetType="Button">
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="Foreground" Value="#00FFFF"/>
            <Setter Property="Background" Value="#181C24"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="Margin" Value="4,8,4,8"/>
            <Setter Property="Padding" Value="20,8"/>
            <Setter Property="MinWidth" Value="160"/>
            <Setter Property="BorderBrush" Value="#00FFFF"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="Effect">
                <Setter.Value>
                    <DropShadowEffect Color="#00FFFF" BlurRadius="8" ShadowDepth="0" Opacity="0.5"/>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                    <Setter Property="FontWeight" Value="ExtraBold"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="DangerButton" TargetType="Button">
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="Foreground" Value="#FF5555"/>
            <Setter Property="Background" Value="#222"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="Margin" Value="8,8,8,8"/>
            <Setter Property="Padding" Value="8,4"/>
            <Setter Property="BorderBrush" Value="#FF5555"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="Effect">
                <Setter.Value>
                    <DropShadowEffect Color="#FF5555" BlurRadius="12" ShadowDepth="0" Opacity="0.7"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="TextBlock">
            <Setter Property="FontFamily" Value="Segoe UI"/>
        </Style>
    </Window.Resources>
    <DockPanel>
        <!-- Top Tab Bar -->
        <StackPanel Orientation="Horizontal" DockPanel.Dock="Top" Background="#181C24" Height="56">
            <Button x:Name="HomeTab" Content="[H] Home" Style="{StaticResource TabButton}"/>
            <Button x:Name="InputDelayTab" Content="[I] Input Delay Tweaks" Style="{StaticResource TabButton}"/>
            <Button x:Name="WindowsTweaksTab" Content="[W] Windows Tweaks" Style="{StaticResource TabButton}"/>
            <Button x:Name="LatencyTab" Content="[L] Latency Tweaks" Style="{StaticResource TabButton}"/>
            <Button x:Name="ControllerTab" Content="[C] Controller Tweaks" Style="{StaticResource TabButton}"/>
            <Button x:Name="UtilSettingsTab" Content="[S] Util Settings" Style="{StaticResource TabButton}" HorizontalAlignment="Right"/>
        </StackPanel>
        <!-- Recommended Selections Row -->
        <StackPanel Orientation="Horizontal" DockPanel.Dock="Top" Background="#101828" Height="48" Margin="0,0,0,8">
            <TextBlock Text="Recommended Selections:" Foreground="#00FFFF" FontWeight="Bold" FontSize="16" VerticalAlignment="Center" Margin="16,0,8,0"/>
            <Button x:Name="StandardBtn" Content="Standard" Style="{StaticResource NeonButton}" MinWidth="120"/>
            <Button x:Name="MinimalBtn" Content="Minimal" Style="{StaticResource NeonButton}" MinWidth="120"/>
            <Button x:Name="ClearBtn" Content="Clear" Style="{StaticResource NeonButton}" MinWidth="120"/>
        </StackPanel>
        <!-- Main Content Area -->
        <Grid x:Name="MainContent" Margin="16,0,16,0"/>
        <!-- Bottom Row: Actions -->
        <StackPanel Orientation="Horizontal" DockPanel.Dock="Bottom" HorizontalAlignment="Center" Margin="0,16,0,0">
            <Button x:Name="RunTweaksBtn" Content="Run Tweaks" Style="{StaticResource NeonButton}" MinWidth="180"/>
            <Button x:Name="UndoSelectedBtn" Content="Undo Selected Tweaks" Style="{StaticResource NeonButton}" MinWidth="220"/>
            <Button x:Name="UndoAllBtn" Content="Undo Everything" Style="{StaticResource DangerButton}" MinWidth="180"/>
        </StackPanel>
    </DockPanel>
</Window>
"@

# Load XAML (correct way for PowerShell)
$sr = New-Object System.IO.StringReader $xaml
$xr = [System.Xml.XmlReader]::Create($sr)
$window = [Windows.Markup.XamlReader]::Load($xr)

# Neon border pulse animation
function Start-NeonPulse {
    param($border)
    if ($border -and $border -is [Windows.Controls.Border]) {
        $anim = New-Object Windows.Media.Animation.ColorAnimation
        $anim.From = [Windows.Media.Color]::FromRgb(0,255,255)
        $anim.To = [Windows.Media.Color]::FromRgb(0,128,255)
        $anim.Duration = [Windows.Duration]::new([TimeSpan]::FromSeconds(1))
        $anim.AutoReverse = $true
        $anim.RepeatBehavior = [Windows.Media.Animation.RepeatBehavior]::Forever
        $brush = New-Object Windows.Media.SolidColorBrush ([Windows.Media.Color]::FromRgb(0,255,255))
        $border.BorderBrush = $brush
        $brush.BeginAnimation([Windows.Media.SolidColorBrush]::ColorProperty, $anim)
    }
}

# Sidebar emoji pulse
function Start-ButtonPulse {
    param($btn)
    $scale = New-Object Windows.Media.Animation.DoubleAnimation
    $scale.From = 1.0
    $scale.To = 1.2
    $scale.Duration = [Windows.Duration]::new([TimeSpan]::FromSeconds(0.2))
    $scale.AutoReverse = $true
    $scale.RepeatBehavior = [Windows.Media.Animation.RepeatBehavior]::Forever
    $trans = New-Object Windows.Media.ScaleTransform
    $trans.ScaleX = 1
    $trans.ScaleY = 1
    $btn.RenderTransform = $trans
    $btn.RenderTransformOrigin = "0.1,0.5"
    $trans.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $scale)
    $trans.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $scale)
}
function Stop-ButtonPulse {
    param($btn)
    if ($btn.RenderTransform -is [Windows.Media.ScaleTransform]) {
        $btn.RenderTransform.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $null)
        $btn.RenderTransform.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $null)
        $btn.RenderTransform = $null
    }
}

# Animated progress bar
function Set-AnimatedProgress {
    param($pb, $value)
    $anim = New-Object Windows.Media.Animation.DoubleAnimation
    $anim.To = $value
    $anim.Duration = [Windows.Duration]::new([TimeSpan]::FromSeconds(0.7))
    $pb.BeginAnimation([System.Windows.Controls.Primitives.RangeBase]::ValueProperty, $anim)
}

# System stats
function Get-SystemStats {
    $cpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
    $ram = Get-CimInstance Win32_OperatingSystem
    $ramUsed = [math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory)/1MB,1)
    $ramTotal = [math]::Round($ram.TotalVisibleMemorySize/1MB,1)
    $ramPct = [math]::Round(100*$ramUsed/$ramTotal,1)
    $gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
    $storage = (Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Measure-Object -Property FreeSpace -Sum)
    $storageFree = [math]::Round($storage.Sum/1GB,1)
    $storageTotal = (Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Measure-Object -Property Size -Sum).Sum
    $storageTotal = [math]::Round($storageTotal/1GB,1)
    $storagePct = if ($storageTotal -ne 0) { [math]::Round(100-($storageFree/$storageTotal*100),1) } else { 0 }
    return @{
        CPU = $cpu
        RAM = $ramPct
        RAMText = "$ramUsed / $ramTotal GB"
        GPU = $gpu
        Storage = $storagePct
        StorageText = "$storageFree / $storageTotal GB"
    }
}

# Home Page Content
function Show-Home {
    $main = $window.FindName('MainContent')
    $main.Children.Clear()
    $panel = New-Object Windows.Controls.StackPanel
    $panel.Margin = '32'
    $panel.HorizontalAlignment = 'Center'
    $panel.VerticalAlignment = 'Center'

    # User Profile Card (insert at top of Home panel)
    $userPanel = New-Object Windows.Controls.StackPanel
    $userPanel.Orientation = 'Horizontal'
    $userPanel.Margin = '0,0,0,16'
    $userPanel.VerticalAlignment = 'Top'

    # Only show avatar if user has uploaded one
    if ($global:profile.avatar -and (Test-Path $global:profile.avatar)) {
        $avatar = New-Object Windows.Controls.Image
        $avatar.Width = 48
        $avatar.Height = 48
        $avatar.Margin = '0,0,12,0'
        $bmp = New-Object Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit(); $bmp.UriSource = [Uri]::new((Resolve-Path $global:profile.avatar)); $bmp.DecodePixelWidth = 48; $bmp.EndInit()
        $avatar.Source = $bmp
        $userPanel.Children.Add($avatar)
    }

    # User info
    $userInfo = New-Object Windows.Controls.StackPanel
    $userInfo.Orientation = 'Vertical'
    $displayName = $global:profile.username
    $greeting = New-Object Windows.Controls.TextBlock
    $greeting.Text = "Welcome, $displayName!"
    $greeting.FontWeight = 'Bold'
    $greeting.FontSize = 16
    $greeting.Foreground = [Windows.Media.Brushes]::Cyan
    $machine = New-Object Windows.Controls.TextBlock
    $machine.Text = "Machine: $env:COMPUTERNAME"
    $machine.FontSize = 12
    $machine.Foreground = [Windows.Media.Brushes]::Gray
    $userInfo.Children.Add($greeting)
    $userInfo.Children.Add($machine)
    $userPanel.Children.Add($userInfo)
    $panel.Children.Insert(0, $userPanel)

    $welcome = New-Object Windows.Controls.TextBlock
    $welcome.Text = "Welcome to The Circle Utility!"
    $welcome.FontSize = 32
    $welcome.FontWeight = 'Bold'
    $welcome.Foreground = [Windows.Media.Brushes]::Cyan
    $welcome.HorizontalAlignment = 'Center'
    $panel.Children.Add($welcome)

    $subtitle = New-Object Windows.Controls.TextBlock
    $subtitle.Text = "Your all-in-one system dashboard"
    $subtitle.FontSize = 16
    $subtitle.Foreground = [Windows.Media.Brushes]::White
    $subtitle.HorizontalAlignment = 'Center'
    $panel.Children.Add($subtitle)

    $ver = New-Object Windows.Controls.TextBlock
    $ver.Text = "App Version 1.0.0"
    $ver.FontSize = 12
    $ver.Foreground = [Windows.Media.Brushes]::Gray
    $ver.HorizontalAlignment = 'Center'
    $panel.Children.Add($ver)

    # System Stats
    $stats = Get-SystemStats
    $statsPanel = New-Object Windows.Controls.StackPanel
    $statsPanel.Margin = '0,24,0,0'
    $statsPanel.Background = [Windows.Media.Brushes]::Transparent

    $cpuText = New-Object Windows.Controls.TextBlock
    $cpuText.Text = "CPU Usage: $($stats.CPU)%"
    $cpuText.Foreground = [Windows.Media.Brushes]::Cyan
    $statsPanel.Children.Add($cpuText)
    $cpuBar = New-Object Windows.Controls.ProgressBar
    $cpuBar.Width = 220; $cpuBar.Height = 16; $cpuBar.Maximum = 100
    Set-AnimatedProgress $cpuBar $stats.CPU
    $statsPanel.Children.Add($cpuBar)

    $ramText = New-Object Windows.Controls.TextBlock
    $ramText.Text = "RAM Usage: $($stats.RAM)% ($($stats.RAMText))"
    $ramText.Foreground = [Windows.Media.Brushes]::Cyan
    $statsPanel.Children.Add($ramText)
    $ramBar = New-Object Windows.Controls.ProgressBar
    $ramBar.Width = 220; $ramBar.Height = 16; $ramBar.Maximum = 100
    Set-AnimatedProgress $ramBar $stats.RAM
    $statsPanel.Children.Add($ramBar)

    $gpuText = New-Object Windows.Controls.TextBlock
    $gpuText.Text = "GPU: $($stats.GPU)"
    $gpuText.Foreground = [Windows.Media.Brushes]::Cyan
    $statsPanel.Children.Add($gpuText)

    $storageText = New-Object Windows.Controls.TextBlock
    $storageText.Text = "Storage Used: $($stats.Storage)% ($($stats.StorageText))"
    $storageText.Foreground = [Windows.Media.Brushes]::Cyan
    $statsPanel.Children.Add($storageText)
    $storageBar = New-Object Windows.Controls.ProgressBar
    $storageBar.Width = 220; $storageBar.Height = 16; $storageBar.Maximum = 100
    Set-AnimatedProgress $storageBar $stats.Storage
    $statsPanel.Children.Add($storageBar)

    $panel.Children.Add($statsPanel)

    # Discord Button with logo above text
    $discordBtn = New-Object Windows.Controls.Button
    $discordBtn.Style = $window.Resources['NeonButton']
    $discordBtn.Margin = '0,8,0,0'

    # Create a StackPanel for vertical layout
    $discordPanel = New-Object Windows.Controls.StackPanel
    $discordPanel.Orientation = 'Vertical'
    $discordPanel.HorizontalAlignment = 'Center'

    # Logo image
    $logo = New-Object Windows.Controls.Image
    $logoUrl = 'https://sdmntprsouthcentralus.oaiusercontent.com/files/00000000-5154-61f7-87f0-50f6f7987c77/raw?se=2025-06-02T17%3A57%3A46Z&sp=r&sv=2024-08-04&sr=b&scid=4c7ca2ac-39ae-55aa-9d71-50c8cc3afbac&skoid=732f244e-db13-47c3-bcc7-7ee02a9397bc&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-06-01T23%3A29%3A36Z&ske=2025-06-02T23%3A29%3A36Z&sks=b&skv=2024-08-04&sig=Ei7t7%2BbsHpH/pJJkYzMpL0bCEmKmm5bt7JxjgQzca34%3D'
    $logo.Source = [Windows.Media.Imaging.BitmapImage]::new([Uri]::new($logoUrl))
    $logo.Width = 60
    $logo.HorizontalAlignment = 'Center'
    $logo.Margin = '0,0,0,4'

    # Text
    $text = New-Object Windows.Controls.TextBlock
    $text.Text = "Join our Discord"
    $text.HorizontalAlignment = 'Center'
    $text.FontWeight = 'Bold'
    $text.FontSize = 18
    $text.Foreground = [Windows.Media.Brushes]::Cyan

    # Add image and text to panel
    $discordPanel.Children.Add($logo)
    $discordPanel.Children.Add($text)

    # Set button content
    $discordBtn.Content = $discordPanel
    $discordBtn.Add_Click({ Start-Process "https://discord.gg/yourdiscord" })
    $panel.Children.Add($discordBtn)

    $main.Children.Add($panel)
}

# Placeholder pages
function Show-Placeholder($title) {
    $main = $window.FindName('MainContent')
    $main.Children.Clear()
    $tb = New-Object Windows.Controls.TextBlock
    $tb.Text = "$title coming soon!"
    $tb.FontSize = 32
    $tb.FontWeight = 'Bold'
    $tb.Foreground = [Windows.Media.Brushes]::Cyan
    $tb.HorizontalAlignment = 'Center'
    $tb.VerticalAlignment = 'Center'
    $main.Children.Add($tb)
}

# Admin Dashboard UI
function Show-AdminDashboard {
    $main = $window.FindName('MainContent')
    $main.Children.Clear()
    $scroll = New-Object Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = 'Auto'
    $panel = New-Object Windows.Controls.StackPanel
    $panel.Margin = '24'
    $panel.HorizontalAlignment = 'Center'
    $panel.VerticalAlignment = 'Top'

    # Title
    $title = New-Object Windows.Controls.TextBlock
    $title.Text = 'Admin Dashboard'
    $title.FontSize = 28
    $title.FontWeight = 'Bold'
    $title.Foreground = [Windows.Media.Brushes]::Cyan
    $title.Margin = '0,0,0,16'
    $panel.Children.Add($title)

    # Users Section
    $usersTitle = New-Object Windows.Controls.TextBlock
    $usersTitle.Text = 'Users:'
    $usersTitle.FontSize = 20
    $usersTitle.FontWeight = 'Bold'
    $usersTitle.Foreground = [Windows.Media.Brushes]::White
    $usersTitle.Margin = '0,12,0,4'
    $panel.Children.Add($usersTitle)

    $profilesPath = "./profiles.json"
    if (-not (Test-Path $profilesPath)) { $profilesPath = "./profiles_template.json" }
    $profiles = Load-JsonFile $profilesPath
    $usersList = New-Object Windows.Controls.StackPanel
    $usersList.Orientation = 'Vertical'
    $usersList.MaxHeight = 180
    $usersList.Margin = '0,0,0,8'
    $usersList.Background = [Windows.Media.Brushes]::Transparent
    $usersScroll = New-Object Windows.Controls.ScrollViewer
    $usersScroll.Content = $usersList
    $usersScroll.VerticalScrollBarVisibility = 'Auto'
    foreach ($user in $profiles) {
        $row = New-Object Windows.Controls.StackPanel
        $row.Orientation = 'Horizontal'
        $row.Margin = '0,0,0,4'
        $avatar = New-Object Windows.Controls.Image
        $avatar.Width = 32; $avatar.Height = 32; $avatar.Margin = '0,0,8,0'
        if ($user.avatar -and (Test-Path $user.avatar)) {
            $bmp = New-Object Windows.Media.Imaging.BitmapImage
            $bmp.BeginInit(); $bmp.UriSource = [Uri]::new((Resolve-Path $user.avatar)); $bmp.DecodePixelWidth = 32; $bmp.EndInit()
            $avatar.Source = $bmp
        }
        $row.Children.Add($avatar)
        $info = New-Object Windows.Controls.TextBlock
        $info.Text = "$($user.username) | $($user.machineId) | $($user.created) | Admin: $($user.isAdmin)"
        $info.Foreground = [Windows.Media.Brushes]::White
        $info.VerticalAlignment = 'Center'
        $row.Children.Add($info)
        $revokeBtn = New-Object Windows.Controls.Button
        $revokeBtn.Content = 'Revoke'
        $revokeBtn.Margin = '8,0,0,0'
        $revokeBtn.Style = $window.Resources['DangerButton']
        $revokeBtn.IsEnabled = ($user.isAdmin -ne $true) -and ($user.isSuperAdmin -ne $true)
        $row.Children.Add($revokeBtn)
        # Add Make Admin button if current user is super admin and target is not admin
        if ($global:profile.isSuperAdmin -eq $true -and ($user.isAdmin -ne $true)) {
            $makeAdminBtn = New-Object Windows.Controls.Button
            $makeAdminBtn.Content = 'Make Admin'
            $makeAdminBtn.Margin = '8,0,0,0'
            $makeAdminBtn.Style = $window.Resources['NeonButton']
            $makeAdminBtn.Add_Click({
                $user.isAdmin = $true
                Save-JsonFile $profilesPath $profiles
                [System.Windows.MessageBox]::Show("$($user.username) is now an admin.")
                Show-AdminDashboard
            })
            $row.Children.Add($makeAdminBtn)
        }
        $usersList.Children.Add($row)
    }
    $panel.Children.Add($usersScroll)

    # Keys Section
    $keysTitle = New-Object Windows.Controls.TextBlock
    $keysTitle.Text = 'Keys:'
    $keysTitle.FontSize = 20
    $keysTitle.FontWeight = 'Bold'
    $keysTitle.Foreground = [Windows.Media.Brushes]::White
    $keysTitle.Margin = '0,12,0,4'
    $panel.Children.Add($keysTitle)

    $repo = "AquaknowsJava/CircleUtility"
    $keysJson = Get-GitHubFile -repo $repo -path "keys.json"
    $keys = $keysJson | ConvertFrom-Json
    $keysList = New-Object Windows.Controls.StackPanel
    $keysList.Orientation = 'Vertical'
    $keysList.MaxHeight = 180
    $keysList.Margin = '0,0,0,8'
    $keysList.Background = [Windows.Media.Brushes]::Transparent
    $keysScroll = New-Object Windows.Controls.ScrollViewer
    $keysScroll.Content = $keysList
    $keysScroll.VerticalScrollBarVisibility = 'Auto'
    foreach ($key in $keys) {
        $row = New-Object Windows.Controls.StackPanel
        $row.Orientation = 'Horizontal'
        $row.Margin = '0,0,0,4'
        $info = New-Object Windows.Controls.TextBlock
        $info.Text = "$($key.key) | Used: $($key.used) | By: $($key.usedBy)"
        $info.Foreground = [Windows.Media.Brushes]::White
        $info.VerticalAlignment = 'Center'
        $row.Children.Add($info)
        $revokeBtn = New-Object Windows.Controls.Button
        $revokeBtn.Content = 'Revoke'
        $revokeBtn.Margin = '8,0,0,0'
        $revokeBtn.Style = $window.Resources['DangerButton']
        $revokeBtn.IsEnabled = $key.used -eq $false
        $revokeBtn.Add_Click({
            $key.used = $true
            $key.usedBy = 'revoked'
            Update-GitHubFile -repo $repo -path "keys.json" -content ($keys | ConvertTo-Json -Depth 5) -message "Revoke key $($key.key)"
            [System.Windows.MessageBox]::Show('Key revoked and synced to GitHub!')
            Show-AdminDashboard
        })
        $row.Children.Add($revokeBtn)
        $keysList.Children.Add($row)
    }
    $panel.Children.Add($keysScroll)

    # Update Button (only for super admin)
    if ($global:profile.isSuperAdmin -eq $true) {
        $updateBtn = New-Object Windows.Controls.Button
        $updateBtn.Content = 'Update (Push to GitHub)'
        $updateBtn.Style = $window.Resources['NeonButton']
        $updateBtn.Margin = '0,16,0,0'
        $updateBtn.Add_Click({
            try {
                # Stage both profiles.json and keys.json
                git add profiles.json keys.json | Out-Null
                # Commit with a standard message
                git commit -m "Update profiles and keys from admin dashboard" | Out-Null
                # Push to GitHub
                git push | Out-Null
                [System.Windows.MessageBox]::Show('Profiles and keys pushed to GitHub!')
            } catch {
                [System.Windows.MessageBox]::Show('Error pushing to GitHub: ' + $_)
            }
        })
        $panel.Children.Add($updateBtn)
    }

    $scroll.Content = $panel
    $main.Children.Add($scroll)
}

# --- GitHub Cloud-First Auth & Profile Management ---

# Hard-coded GitHub token (for private repo use only)
$global:GITHUB_TOKEN = "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"

# Prompt for username using VisualBasic InputBox
if (-not $global:USERNAME) {
    $global:USERNAME = [Microsoft.VisualBasic.Interaction]::InputBox('Enter your username:', 'Username')
}

# GitHub API helpers
function Get-GitHubFile {
    param (
        [string]$repo,
        [string]$path,
        [string]$branch = "main"
    )
    $url = "https://api.github.com/repos/$repo/contents/$path?ref=$branch"
    $headers = @{ Authorization = "token $global:GITHUB_TOKEN"; "User-Agent" = "CircleUtility" }
    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers
        $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($response.content))
        return $content
    } catch {
        [System.Windows.MessageBox]::Show('Failed to fetch ' + $path + ' from GitHub. Check your token and network.')
        exit
    }
}

function Update-GitHubFile {
    param (
        [string]$repo,
        [string]$path,
        [string]$content,
        [string]$message = "Update via Circle Utility",
        [string]$branch = "main"
    )
    $url = "https://api.github.com/repos/$repo/contents/$path"
    $headers = @{ Authorization = "token $global:GITHUB_TOKEN"; "User-Agent" = "CircleUtility" }
    # Get current SHA
    $getResp = Invoke-RestMethod -Uri "$url?ref=$branch" -Headers $headers
    $sha = $getResp.sha
    $body = @{
        message = $message
        content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))
        branch = $branch
        sha = $sha
    } | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri $url -Headers $headers -Method Put -Body $body
    } catch {
        [System.Windows.MessageBox]::Show('Failed to update ' + $path + ' on GitHub. Check your token and network.')
        exit
    }
}

# Load profiles and keys from GitHub
$profilesJson = Get-GitHubFile -repo $repo -path "profiles.json"
$profiles = $profilesJson | ConvertFrom-Json

# Authenticate user
$global:profile = $profiles | Where-Object { $_.username -eq $global:USERNAME }
if (-not $global:profile) {
    [System.Windows.MessageBox]::Show('User not found in profiles.json!')
    exit
}

# Set rights
$isAdmin = $false
$isSuperAdmin = $false
if ($global:profile.isAdmin -eq $true) { $isAdmin = $true }
if ($global:profile.isSuperAdmin -eq $true) { $isSuperAdmin = $true }

# Main entry: show sign-up if no profile, else continue
$global:profile = Get-CurrentProfile
if (-not $global:profile) {
    Show-SignUpWindow
    $global:profile = Get-CurrentProfile
    if (-not $global:profile) { exit }
}

# Super Admin protection at startup
if (-not $global:profile -or $global:profile.isSuperAdmin -ne $true) {
    [System.Windows.MessageBox]::Show('Critical: Super admin profile missing or altered! Exiting for security.')
    exit
}

# Initial state
Show-Home
Start-NeonPulse ($window.FindName('MainBorder'))

# Show window
$window.ShowDialog() | Out-Null 
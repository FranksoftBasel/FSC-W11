# Franksoft Reboot Box V5
# FS-Shutdown.ico muss im gleichen Ordner wie diese PS1 liegen.
# V5: keine Effect-Fehler mehr, runde Glass-Buttons, Header-Drag, UTF8-safe via XML Entities.

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$timeout   = 15
$remaining = $timeout

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IconPath = Join-Path $ScriptDir "FS-Shutdown.ico"
$LogoPath = Join-Path $ScriptDir "FS-Shutdown.png"

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Width="720"
        Height="442"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        Topmost="True"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent">

    <Window.Resources>

        <!-- Blau: runder Glass Button -->
        <Style x:Key="BlueGlassButton" TargetType="Button">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Segoe UI Semibold"/>
            <Setter Property="FontSize" Value="20"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="RenderTransformOrigin" Value="0.5,0.5"/>
            <Setter Property="RenderTransform">
                <Setter.Value>
                    <TranslateTransform Y="0"/>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ButtonBorder"
                                CornerRadius="10"
                                BorderBrush="#0A4CA7"
                                BorderThickness="1"
                                SnapsToDevicePixels="True">

                            <Border.Background>
                                <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                                    <GradientStop Color="#39A0FF" Offset="0"/>
                                    <GradientStop Color="#0B6FE8" Offset="0.48"/>
                                    <GradientStop Color="#0054C7" Offset="1"/>
                                </LinearGradientBrush>
                            </Border.Background>

                            <Border.Effect>
                                <DropShadowEffect Color="#0058D6"
                                                  BlurRadius="14"
                                                  ShadowDepth="2"
                                                  Opacity="0.34"/>
                            </Border.Effect>

                            <Grid>
                                <!-- dezenter Glas-Overlay oben -->
                                <Border CornerRadius="10,10,0,0"
                                        Height="25"
                                        VerticalAlignment="Top"
                                        Opacity="0.22">
                                    <Border.Background>
                                        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                                            <GradientStop Color="#FFFFFF" Offset="0"/>
                                            <GradientStop Color="#00FFFFFF" Offset="1"/>
                                        </LinearGradientBrush>
                                    </Border.Background>
                                </Border>

                                <ContentPresenter HorizontalAlignment="Center"
                                                  VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Effect">
                                    <Setter.Value>
                                        <DropShadowEffect Color="#006CFF"
                                                          BlurRadius="24"
                                                          ShadowDepth="3"
                                                          Opacity="0.55"/>
                                    </Setter.Value>
                                </Setter>
                                <Setter Property="RenderTransform">
                                    <Setter.Value>
                                        <TranslateTransform Y="-2"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>

                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="RenderTransform">
                                    <Setter.Value>
                                        <TranslateTransform Y="1"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Rot: runder Glass Button -->
        <Style x:Key="RedGlassButton" TargetType="Button">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Segoe UI Semibold"/>
            <Setter Property="FontSize" Value="20"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="RenderTransformOrigin" Value="0.5,0.5"/>
            <Setter Property="RenderTransform">
                <Setter.Value>
                    <TranslateTransform Y="0"/>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ButtonBorder"
                                CornerRadius="10"
                                BorderBrush="#8A0010"
                                BorderThickness="1"
                                SnapsToDevicePixels="True">

                            <Border.Background>
                                <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                                    <GradientStop Color="#FF6666" Offset="0"/>
                                    <GradientStop Color="#E21D23" Offset="0.48"/>
                                    <GradientStop Color="#B30012" Offset="1"/>
                                </LinearGradientBrush>
                            </Border.Background>

                            <Border.Effect>
                                <DropShadowEffect Color="#B30012"
                                                  BlurRadius="14"
                                                  ShadowDepth="2"
                                                  Opacity="0.34"/>
                            </Border.Effect>

                            <Grid>
                                <!-- dezenter Glas-Overlay oben -->
                                <Border CornerRadius="10,10,0,0"
                                        Height="25"
                                        VerticalAlignment="Top"
                                        Opacity="0.20">
                                    <Border.Background>
                                        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                                            <GradientStop Color="#FFFFFF" Offset="0"/>
                                            <GradientStop Color="#00FFFFFF" Offset="1"/>
                                        </LinearGradientBrush>
                                    </Border.Background>
                                </Border>

                                <ContentPresenter HorizontalAlignment="Center"
                                                  VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Effect">
                                    <Setter.Value>
                                        <DropShadowEffect Color="#E00000"
                                                          BlurRadius="24"
                                                          ShadowDepth="3"
                                                          Opacity="0.52"/>
                                    </Setter.Value>
                                </Setter>
                                <Setter Property="RenderTransform">
                                    <Setter.Value>
                                        <TranslateTransform Y="-2"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>

                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="RenderTransform">
                                    <Setter.Value>
                                        <TranslateTransform Y="1"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>

    <Border CornerRadius="18"
            BorderBrush="#C7D8EC"
            BorderThickness="1"
            Background="#F3F7FC">

        <Border.Effect>
            <DropShadowEffect Color="#335577"
                              BlurRadius="30"
                              ShadowDepth="0"
                              Opacity="0.45"/>
        </Border.Effect>

        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="50"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="55"/>
            </Grid.RowDefinitions>

            <!-- HEADER -->
            <Border x:Name="HeaderBar"
                    Grid.Row="0"
                    CornerRadius="18,18,0,0"
                    Background="#0066CC">

                <Grid>
                    <Image x:Name="HeaderLogo"
                           Width="30"
                           Height="30"
                           Margin="26,0,0,0"
                           HorizontalAlignment="Left"
                           VerticalAlignment="Center"
                           Stretch="Uniform"/>

                    <TextBlock Text="Franksoft Client - Windows Neustart"
                               FontFamily="Segoe UI"
                               FontSize="18"
                               Foreground="White"
                               Margin="72,0,0,0"
                               VerticalAlignment="Center"/>

<Button x:Name="CloseButton"
        Width="32"
        Height="32"
        HorizontalAlignment="Right"
        VerticalAlignment="Center"
        Margin="0,0,14,0"
        Cursor="Hand"
        BorderThickness="0"
        Background="Transparent"
        FocusVisualStyle="{x:Null}">

    <Button.Template>
        <ControlTemplate TargetType="Button">
            <Border x:Name="CloseBorder"
                    CornerRadius="6"
                    BorderBrush="#8A1C12"
                    BorderThickness="2">

                <Border.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                        <GradientStop Color="#FF7A5C" Offset="0"/>
                        <GradientStop Color="#E43A20" Offset="0.45"/>
                        <GradientStop Color="#B91408" Offset="1"/>
                    </LinearGradientBrush>
                </Border.Background>

                <Grid>
                    <Border CornerRadius="6,6,0,0"
                            Height="14"
                            VerticalAlignment="Top"
                            Opacity="0.35">
                        <Border.Background>
                            <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                                <GradientStop Color="#FFFFFF" Offset="0"/>
                                <GradientStop Color="#00FFFFFF" Offset="1"/>
                            </LinearGradientBrush>
                        </Border.Background>
                    </Border>

                    <TextBlock Text="X"
                               FontFamily="Segoe UI"
                               FontSize="22"
                               FontWeight="Bold"
                               Foreground="White"
                               HorizontalAlignment="Center"
                               VerticalAlignment="Center"
                               Margin="0,-2,0,0"/>
                </Grid>
            </Border>

<ControlTemplate.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="CloseBorder"
                    Property="BorderBrush"
                    Value="#FFFFFF"/>
            <Setter TargetName="CloseBorder"
                    Property="Background">
                <Setter.Value>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
                        <GradientStop Color="#FF9A7A" Offset="0"/>
                        <GradientStop Color="#FF5533" Offset="0.45"/>
                        <GradientStop Color="#D51F10" Offset="1"/>
                    </LinearGradientBrush>
                </Setter.Value>
            </Setter>

            <Setter TargetName="CloseBorder"
                    Property="Effect">
                <Setter.Value>
                    <DropShadowEffect Color="#FFE0D0"
                                    BlurRadius="10"
                                    ShadowDepth="0"
                                    Opacity="0.5"/>
                </Setter.Value>
            </Setter>

        </Trigger>

        <Trigger Property="IsPressed" Value="True">
            <Setter TargetName="CloseBorder"
                    Property="RenderTransform">
                <Setter.Value>
                    <TranslateTransform Y="1"/>
                </Setter.Value>
            </Setter>
        </Trigger>

        </ControlTemplate.Triggers>
        </ControlTemplate>
    </Button.Template>
</Button>               
</Grid>
</Border>

            <!-- CONTENT -->
            <Grid Grid.Row="1" Margin="30,25,30,-0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="80"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

<Image x:Name="MainLogo"
       Width="95"
       Height="95"
       Grid.Column="0"
       Stretch="Uniform"
       HorizontalAlignment="Left"
       Margin="-15,0,0,0"
       VerticalAlignment="Top"/>

                <StackPanel Grid.Column="1"
                            Margin="20,10,10,0">

                    <TextBlock Text="Der Neustart wird vorbereitet."
                               FontFamily="Segoe UI Semibold"
                               FontSize="28"
                               FontWeight="SemiBold"
                               Foreground="#202020"
                               Margin="0,0,0,18"/>

<TextBlock Text="Die Franksoft Deployment-Phase wurde erfolgreich abgeschlossen.&#10;Nach dem Neustart wird die Installation automatisch fortgesetzt."
           FontFamily="Segoe UI"
           FontSize="16"
           FontWeight="Normal"
           Foreground="#404040"
           LineHeight="28"
           TextWrapping="Wrap"
           Margin="0,0,0,28"/>
           
                    <ProgressBar x:Name="Progress"
                                 Width="515"
                                 Height="16"
                                 Minimum="0"
                                 Maximum="100"
                                 Value="100"
                                 Foreground="#0A4FBF"
                                 Background="#E5EEF8"
                                 BorderBrush="#A0B7D8"/>

                    <TextBlock x:Name="CountdownText"
                               Text="Neustart in 15 Sekunden"
                               FontFamily="Segoe UI Semibold"
                               FontSize="20"
                               Foreground="#003e92"
                               HorizontalAlignment="Center"
                               Margin="0,12,0,12"/>

<Grid Margin="0,10,0,0">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="15"/>
        <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    
                        <Button x:Name="RestartButton"
                                Grid.Column="0"
                                Height="60"
                                Style="{StaticResource BlueGlassButton}"
                                Content="Jetzt neu starten"/>

                        <Button x:Name="CancelButton"
                                Grid.Column="2"
                                Height="60"
                                Style="{StaticResource RedGlassButton}"
                                Content="Abbrechen"
                                IsDefault="True"
                                IsCancel="True"/>
                    </Grid>
                </StackPanel>
            </Grid>

            <!-- FOOTER -->
            <Border Grid.Row="2"
                    Background="#F8FBFE"
                    BorderBrush="#C8D6EA"
                    BorderThickness="0,1,0,0"
                    CornerRadius="0,0,18,18">

                <StackPanel Orientation="Horizontal"
            VerticalAlignment="Center"
            Margin="22,0,0,0">

<TextBlock Text="Der Neustart erfolgt automatisch, wenn keine Aktion ausgef&#xFC;hrt wird."
           FontFamily="Segoe UI"
           FontSize="14"
           Foreground="#0A1E5A"/>
</StackPanel>

            </Border>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$HeaderBar     = $window.FindName("HeaderBar")
$HeaderLogo    = $window.FindName("HeaderLogo")
$MainLogo      = $window.FindName("MainLogo")
$CloseButton   = $window.FindName("CloseButton")
$RestartButton = $window.FindName("RestartButton")
$CancelButton  = $window.FindName("CancelButton")
$CountdownText = $window.FindName("CountdownText")
$Progress      = $window.FindName("Progress")

# Logo laden
# Header: bevorzugt ICO
# Grosses Logo: bevorzugt PNG, Fallback auf ICO
function New-BitmapImageFromPath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $bitmap.BeginInit()
    $bitmap.UriSource = New-Object System.Uri($Path)
    $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $bitmap.EndInit()

    return $bitmap
}

if((Test-Path $IconPath) -and $HeaderLogo){
    $HeaderLogo.Source = New-BitmapImageFromPath -Path $IconPath
}
elseif((Test-Path $LogoPath) -and $HeaderLogo){
    $HeaderLogo.Source = New-BitmapImageFromPath -Path $LogoPath
}

if((Test-Path $LogoPath) -and $MainLogo){
    $MainLogo.Source = New-BitmapImageFromPath -Path $LogoPath
}
elseif((Test-Path $IconPath) -and $MainLogo){
    $MainLogo.Source = New-BitmapImageFromPath -Path $IconPath
}

# Fenster nur am blauen Header bewegen
$HeaderBar.Add_MouseLeftButtonDown({
    $window.DragMove()
})

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(1)

$timer.Add_Tick({
    $script:remaining--

    $CountdownText.Text = "Neustart in $script:remaining Sekunden"
    # Button bleibt statisch
    $RestartButton.Content = "Jetzt neu starten"

    if($script:remaining -ge 0){
        $Progress.Value = ($script:remaining / $timeout) * 100
    }

    if($script:remaining -le 0){
        $timer.Stop()
        $window.Close()
        Restart-Computer -Force
    }
})

$RestartButton.Add_Click({
    $timer.Stop()
    $window.Close()
    Restart-Computer -Force
})

$CancelButton.Add_Click({
    $timer.Stop()
    $window.Close()
})

# Close Hover weich rot
$CloseButton.Add_MouseEnter({
    $CloseButton.Foreground = "#FFD6D6"
})

$CloseButton.Add_MouseLeave({
    $CloseButton.Foreground = "White"
})

$CloseButton.Add_Click({
    $timer.Stop()
    $window.Close()
})

$window.Add_Loaded({
    $CancelButton.Focus()
    [System.Windows.Input.Keyboard]::Focus($CancelButton)
    $timer.Start()
})

[void]$window.ShowDialog()

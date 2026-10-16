Get-CimInstance Win32_Processor |
    Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

Get-ChildItem "C:\ProgramData\LocalAI\llama.cpp" `
    -Filter "ggml-cpu-*.dll" |
    Select-Object Name, Length
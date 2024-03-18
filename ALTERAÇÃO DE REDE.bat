@echo off

chcp 65001 > nul

goto :menu

:menu
cls

call :cor 01 "          ALTERAR MODO DE CONEXAO"
call :cor 08 "-------------------------------------------"
echo ESCOLHA UMA OPÇÃO:
call :cor 08 "1. MODO HOME OFFICE"
call :cor 08 "2. MODO PRESENCIAL WIFI"
call :cor 08 "3. MODO PRESENCIAL CABEADO"
call :cor 04 "0. SAIR"
call :cor 08 "-------------------------------------------"
set /p opcao1=Opcao:

if %opcao1%==1 (
    goto :mode_home
) else if %opcao1%==2 (
    set /p ip=INFORME SEU NUMERO:
    goto :mode_wifi
) else if %opcao1%==3 (
    set /p ip=INFORME SEU NUMERO:
    goto :mode_cabeado
) else if %opcao1%==0 (
    exit /b
) else (
    goto :menu
)

:menu2 
echo Escolha uma opcao:
echo 1. VOLTAR PARA O MENU
echo 2. SAIR
set /p opcao2=Opcao:

if %opcao2%==1 (
    cls
    goto :menu
) else if %opcao2%==2 (
    exit /b
) else (
    cls
    goto :menu2
)

goto :menu2

:mode_home
    @echo off
    call :cor 06 "ALTERANDO PARA MODO HOME OFFICE..."

    ::Define o adaptador que será configurado
    set adaptador="Wi-Fi" 
    
    ::Define o IP como automático
    netsh interface ipv4 set address name=%adaptador% source=dhcp

    call :cor 20 "ALTERADO PARA O MODO HOME OFFICE."

    goto :menu2

:mode_wifi
    @echo off

    call :cor 06 "Alterando para o MODO PRESENCIAL WIFI..."

    :: TIRANDO OS IPS PARA NÃO TER CONFLITO
    set adaptador="Wi-Fi" 
    set adaptador2="Ethernet" 
    
    :: Define o IP como automático
    netsh interface ipv4 set address name=%adaptador% source=dhcp > nul
    netsh interface ipv4 set dns name=%adaptador% dhcp > nul

    netsh interface ipv4 set address name=%adaptador2% source=dhcp > nul
    netsh interface ipv4 set dns name=%adaptador2% dhcp > nul

    ::Define o endereço IP, máscara de sub-rede e gateway
    set endereco_ip=192.168.0.%ip%
    set mascara_subrede=255.255.255.0
    set gateway=192.168.0.1
    set dns_primario=192.168.0.8
    set dns_secundario=8.8.8.8

    ::Configura o IP, máscara de sub-rede e gateway
    netsh interface ipv4 set address name=%adaptador% source=static address=%endereco_ip%  mask=%mascara_subrede% gateway=%gateway%
    netsh interface ipv4 set dns name=%adaptador% static %dns_primario% > nul
    netsh interface ipv4 add dns name=%adaptador% %dns_secundario% index=2 > nul

    call :cor 20 "ALTERADO PARA O MODO PRESENCIAL WIFI."

    goto :menu2

:mode_cabeado
    @echo off

    call :cor 06 "Alterando para o MODO PRESENCIAL CABEADO..."

    :: TIRANDO OS IPS PARA NÃO TER CONFLITO
    set adaptador="Ethernet" 
    set adaptador2="Wi-Fi" 
    
    :: Define o IP como automático
    netsh interface ipv4 set address name=%adaptador% source=dhcp > nul
    netsh interface ipv4 set dns name=%adaptador% dhcp > nul

    netsh interface ipv4 set address name=%adaptador2% source=dhcp > nul
    netsh interface ipv4 set dns name=%adaptador2% dhcp > nul

    ::Define o endereço IP, máscara de sub-rede e gateway
    set endereco_ip=192.168.0.%ip%
    set mascara_subrede=255.255.255.0
    set gateway=192.168.0.1
    set dns_primario=192.168.0.8
    set dns_secundario=8.8.8.8

    ::Configura o IP, máscara de sub-rede e gateway
    netsh interface ipv4 set address name=%adaptador% source=static address=%endereco_ip%  mask=%mascara_subrede% gateway=%gateway%
    netsh interface ipv4 set dns name=%adaptador% static %dns_primario% > nul
    netsh interface ipv4 add dns name=%adaptador% %dns_secundario% index=2 > nul

    call :cor 20 "ALTERADO PARA O MODO PRESENCIAL CABEADO."

    goto :menu2

:cor
>%2 set /p=.<&1
findstr /a:%1 "." %2 con
del %2
for /f "tokens=*" %%a in ('cmd /k prompt $h$h ^<^&1') do echo %%a
exit /b

::40 - VERMELHO E LETRA PRETA
:: 20 - VERDE E LETRA PRETA
:: 03 - FUNDO PRETO LETRA AZUL
:: 06 - FUNDO PRETO E LETRA AMARELA

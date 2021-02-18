@echo off

::��https://www.51it.wang�����棩
::��ȡ����·��
setlocal EnableDelayedExpansion
cd /d "%~dp0"


::����bat���
title Windows ��Officeȫ�׼���ű���Я��V1.0
MODE con: COLS=88 lines=16
color 0a


::���xpϵͳ
ver | find "5." > nul && goto :xptooff


::��ȡ����ԱȨ��
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit


::���� ���������
set kmsroot=kms.51it.wang
::������վ��ַ�� https://www.51it.wang
::����kms0.51it.wang��kms1.51it.wang��kms2.51it.wang


::�˵�
:begin
cls
echo.
echo.
echo.
echo.	===== Windows ��Officeȫ�׼���ű���Я��V1.0   =====
echo.
echo. --[1]--���� Windows ϵͳ��֧�� Windows Vista/7/8/8.1/10 2008/2008R2/2012/2012R2/2016��
echo. --[2]--���� Office��֧�� Office 2010/2013/2016  Office365��
echo. --[3]--ж�� Windowsϵͳ����
echo. --[4]--ж�� Office����
echo. --[5]--�鿴 Windows ϵͳ״̬
echo. --[6]--�˳�
echo.
echo. --�İ����ߣ�xx
echo.
echo.
choice /c 123456 /n /m "��ѡ��1-6����"

echo. %errorlevel%
if %errorlevel% == 1 goto start
if %errorlevel% == 2 goto office
if %errorlevel% == 3 goto unwindows
if %errorlevel% == 4 goto officeun
if %errorlevel% == 5 goto zhuangtai
if %errorlevel% == 6 goto end


::��� ���������
:check
cls
echo.
echo.
echo.
echo. ���ڼ�鼤������������Ժ�.....
ping %kmsroot% | find /i "����" >nul && ( goto :EOF ) || ( goto fail )


::����Windows
:start
cls
echo.
echo.
echo.
call :check
echo.
echo. �����ӷ�����....
cscript //Nologo %windir%\system32\slmgr.vbs /xpr | find "�����ü���" > NUL && goto wintooff

::���ϵͳ�汾
ver | find "6.0." > NUL &&  goto winvista
ver | find "6.1." > NUL &&  goto win7
ver | find "6.2." > NUL &&  goto win8
ver | find "6.3." > NUL &&  goto win81
ver | find "10.0." > NUL &&  goto win10
echo.
echo. ��Ĳ���ϵͳ��֧�ּ���(������WinXP��Win2003)��
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::���뼤����Կ
:winvista
echo.
echo. ��ǰΪWindows Vista/2008����ʼ���Լ���.....
echo.

::vista

set Business=YFKBB-PQJJV-G996G-VWGXY-2V3X8
set BusinessN=HMBQG-8H2RH-C77VX-27R82-VMQBT

set Enterprise=VKK3X-68KWM-X2YGT-QR4M6-4BWMV
set EnterpriseN=VTC42-BM838-43QHV-84HX6-XJXKV

::2008

set ServerWeb=WYR28-R7TFJ-3X2YQ-YCY4H-M249D
set ServerStandard=TM24T-X9RMF-VWXK6-X8JC9-BFGM2

set ServerStandardV=W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ
set ServerEnterprise=YQGMW-MPWTJ-34KDK-48M3W-X4Q6V

set ServerEnterpriseV=39BXF-X8Q23-P2WWT-38T2F-G3FPG
set ServerWeb=RCTX3-KWVHP-BR6TB-RB6DM-6X7HP

set ServerDatacenter=7M67G-PC374-GR742-YH8V4-TCBY3
set ServerDatacenterV=22XQ2-VRXRG-P8D42-K34TD-G3QQC

set ServerEnterpriseIA64=4DWFP-JF3DJ-B7DTH-78FJB-PDRHK

goto windowsstart


::���뼤����Կ
:win7
echo.

::win7

echo. ��ǰΪWindows 7/2008 R2����ʼ���Լ���.....
echo.
set Professional=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
set ProfessionalN=MRPKT-YTG23-K7D7T-X2JMM-QY7MG
set ProfessionalE=W82YF-2Q76Y-63HXB-FGJG9-GF7QX

set Enterprise=33PXH-7Y6KF-2VJC9-XBBR8-HVTHH
set EnterpriseN=YDRBP-3D83W-TY26F-D46B2-XCKRJ
set EnterpriseE=C29WB-22CC8-VJ326-GHFJW-H9DH4

::2008R2

set ServerWeb=6TPJF-RBVHG-WBW2R-86QPH-6RTM4
set ServerHPC=TT8MH-CG224-D3D7Q-498W2-9QCTX

set ServerStandard=YC6KT-GKW9T-YTKYR-T4X34-R7VHC
set ServerEnterprise=489J6-VHDMP-X63PK-3K798-CPX3Y

set ServerDatacenter=74YFP-3QFB3-KQT8W-PMXWJ-7M648
set ServerEnterpriseIA64=GT63C-RJFQ3-4GMB6-BRFB9-CB83V

goto windowsstart


::���뼤����Կ
:win8
echo.
echo. ��ǰΪWindows 8/2012����ʼ���Լ���.....
echo.

::win8

set Professional=NG4HW-VH26C-733KW-K6F98-J8CK4
set ProfessionalN=XCVCF-2NXM9-723PB-MHCB7-2RYQQ

set Enterprise=32JNW-9KQ84-P47T8-D8GGY-CWCK7
set EnterpriseN=JMNMF-RHW7P-DMY6X-RF3DR-X2BQT

::2012

set Core=BN3D2-R7TKB-3YPBD-8DRP2-27GG4
set CoreN=8N2M2-HWPGY-7PGT9-HGDD8-GVGGY

set CoreSingleLanguage=2WN2H-YGCQR-KFX6K-CD6TF-84YXQ
set CoreCountrySpecific=4K36P-JN4VD-GDC6V-KDT89-DYFKP

set ServerStandard=XC9B7-NBPP2-83J2H-RHMBY-92BT4
set ServerMultiPointStandard=HM7DN-YVMH3-46JC3-XYTG7-CYQJJ

set ServerMultiPointPremium=XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G
set ServerDatacenter=48HP8-DN98B-MYWDG-T2DCC-8W83P

goto windowsstart


::���뼤����Կ
:win81
echo.
echo. ��ǰΪWindows 8.1����ʼ���Լ���.....
echo.

::win8.1

set Professional=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
set ProfessionalN=HMCNV-VVBFX-7HMBH-CTY9B-B4FXY

set Enterprise=MHF9N-XY6XB-WVXMC-BTDCT-MKKG7
set EnterpriseN=TT4HM-HN7YT-62K67-RGRQJ-JFFXW

::2012R2

set ServerDatacenter=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set ServerStandard=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set ServerSolution=KNC87-3J2TX-XB4WP-VCPJV-M4FWM

goto windowsstart


::���뼤����Կ
:win10
echo.
echo. ��ǰΪWindows 10����ʼ���Լ���.....
echo.

::win10

set Professional=W269N-WFGWX-YVC9B-4J6C9-T83GX
set ProfessionalN=MH37W-N47XK-V7XM9-C7227-GCQG9

set Enterprise=NPPR9-FWDCX-D2C8J-H872K-2YT43
set EnterpriseN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4

set Education=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
set EducationN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ


set EnterpriseS=WNMTR-4C88C-JK8YV-HQ7T2-76DF9
set EnterpriseSN=2F77B-TNFGY-69QQF-B8YKP-D69TJ

set EnterpriseN=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
set EnterpriseSN=QFFDN-GRT3P-VKWWX-X7T3R-8B639

set EnterpriseG=YYVX9-NTFWV-6MDM3-9PT4T-4M68B
set EnterpriseGN=44RPN-FTY23-9VTTB-MP9BX-T84FV

::2016

set ServerDatacenter=CB7KF-BWN84-R7R2Y-793K2-8XDDG
set ServerStandard=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
set ServerEssentials=JCKRF-N37P4-C2D82-9YXRT-4M63B

goto windowsstart


::����ϵͳ
:windowsstart
cls
echo.
echo.
echo.
echo. ���ڼ������ϵͳ�����Ժ�.....
for /f "tokens=3 delims= " %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set EditionID=%%i
if defined %EditionID% (
	cscript //Nologo %windir%\system32\slmgr.vbs /ipk !%EditionID%! >nul
	cscript //Nologo %windir%\system32\slmgr.vbs /skms %kmsroot% >nul
	cscript //Nologo %windir%\system32\slmgr.vbs /ato >nul
	cscript //Nologo %windir%\system32\slmgr.vbs /xpr | find /i "����" >nul && (
	echo. & echo. ***** ����ϵͳ ����ɹ� ***** & echo.) || (echo. & echo. ***** ����ϵͳ ����ʧ�� ***** & echo.)
) else (
	echo.
	echo. ����ʧ�ܣ�����������Ĳ���ϵͳΪ����VL�汾��
)
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::�������ü���
:wintooff
cls
echo.
echo.
echo.
echo. ϵͳ�Ѿ����ü�����輤������������ؿ�ʼ�˵���
echo.
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::���office�汾
:office
cls
echo.
echo.
echo.
call :check
echo.
echo. �����ӷ�����....
echo.
echo. ���ڼ�鰲װ�� Office �汾.....
call :GetOfficePath 14 Office2010
call :ActOffice 14 Office2010
call :GetOfficePath 15 Office2013
call :ActOffice 15 Office2013
echo.
echo. ���ڼ�� Office2016 ϵ�в�Ʒ�İ�װ·��.....
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles%\Microsoft Office\Office16
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles(x86)%\Microsoft Office\Office16
if DEFINED _Office16Path (cls & echo. & echo. & echo. & echo. �ѷ��� Office2016
	call :ActOffice 16 Office2016
  ) else (cls & echo. & echo. & echo. & echo. δ����ϵͳ��װ Office������������޸���Ĭ�ϰ�װ·���� & echo. & echo. ����ʣ�https://www.51it.wang/ll/776 ���̳��ֶ���� &echo.)
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::���office·��
:GetOfficePath
echo.
echo. ���ڼ�� %2 ϵ�в�Ʒ�İ�װ·��.....
set _Office%1Path=
set _Reg32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\%1.0\Common\InstallRoot
set _Reg64=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Office\%1.0\Common\InstallRoot
reg query "%_Reg32%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg32%" /v "Path"') do SET "_OfficePath1=%%b"
reg query "%_Reg64%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg64%" /v "Path"') do SET "_OfficePath2=%%b"
if DEFINED _OfficePath1 (if exist "%_OfficePath1%ospp.vbs" set _Office%1Path=!_OfficePath1!)
if DEFINED _OfficePath2 (if exist "%_OfficePath2%ospp.vbs" set _Office%1Path=!_OfficePath2!)
set _OfficePath1=
set _OfficePath2=
if DEFINED _Office%1Path (cls & echo. & echo. & echo. & echo. �ѷ��� %2) else (cls & echo. & echo. & echo. & echo. δ���� %2)
goto :EOF


::����office
:ActOffice
if DEFINED _Office%1Path (
	cd /d "!_Office%1Path!"
	echo.
	echo. ���ڼ�� %2 �ļ���״̬�����Ժ�.....
	cscript //nologo ospp.vbs /act | find /i "successful" > NUL && (
		echo. & echo. ***** %2 �Ѿ�����Զ����� ***** & echo.) || (
		echo. & echo. %2 δ��������Խ��м�����Ժ�.....
		if %1 EQU 14 call :Licens14
		if %1 EQU 15 call :Licens15
		if %1 EQU 16 call :Licens16
		cscript //nologo ospp.vbs /sethst:%kmsroot% >nul
		cscript //nologo ospp.vbs /act | find /i "successful" >nul && (
		echo. & echo. ***** %2 ����ɹ� ***** & echo.) || (echo. & echo. ***** %2 ����ʧ�� ***** & echo.)
		)
cd /d "%~dp0"
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin
)
cd /d "%~dp0"
goto :EOF


::����office������Կ
:Licens14
for /f %%x in ('dir /b ..\root\Licenses14\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses14\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses14\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses14\%%x" >nul

cscript ospp.vbs /inpkey:VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB >nul
cscript ospp.vbs /inpkey:V7QKV-4XVVR-XYV4D-F7DFM-8R6BM >nul
cscript ospp.vbs /inpkey:D6QFG-VBYP2-XQHM7-J97RH-VVRCK >nul
goto :EOF


::����office������Կ
:Licens15
for /f %%x in ('dir /b ..\root\Licenses15\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses15\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses15\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses15\%%x" >nul

cscript ospp.vbs /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT >nul
cscript ospp.vbs /inpkey:KBKQT-2NMXY-JJWGP-M62JB-92CD4 >nul
goto :EOF


::����office������Կ
:Licens16
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul

cscript ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul
cscript ospp.vbs /inpkey:JNRGM-WHDWX-FJJG3-K47QV-DRTFM >nul
goto :EOF


::��⵽xp�˳�
:xptooff
cls
echo.
echo.
echo.
echo. ***** ��ǰϵͳΪ WinXP �� Win2003����֧�� ���� *****
echo.
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::���ʧ��
:fail
cls
echo.
echo.
echo.
echo. ***** �޷����ӵ������������������ټ�������������绹�ǲ�������� https://www.51it.wang ��ȡ���°漤���ַ *****
echo.
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::ж��Windows����
:unwindows
cls
echo.
echo.
echo.
echo. ����ж�� Windows ������Ժ�.....
	cscript //Nologo %windir%\system32\slmgr.vbs /upk >nul
	cscript //Nologo %windir%\system32\slmgr.vbs /c���� >nul
	cscript //Nologo %windir%\system32\slmgr.vbs /xpr | find /i "����" >nul && (
	echo. & echo. ***** ���� ж�سɹ� ***** & echo.) || (echo. & echo. ***** ���� ж��ʧ�� ***** & echo.)	
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::ж��office����
:officeun
cls
echo.
echo.
echo.
echo. ���ڼ�鰲װ�� Office �汾.....
call :GetOfficePath 14 Office2010
call :unoffice 14 Office2010
call :GetOfficePath 15 Office2013
call :unoffice 15 Office2013
echo.
echo. ���ڼ�� Office2016 ϵ�в�Ʒ�İ�װ·��.....
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles%\Microsoft Office\Office16
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles(x86)%\Microsoft Office\Office16
if DEFINED _Office16Path (cls & echo. & echo. & echo. & echo. �ѷ��� Office2016
	call :unoffice 16 Office2016
  ) else (cls & echo. & echo. & echo. & echo. δ����ϵͳ��װ Office������������޸���Ĭ�ϰ�װ·���� & echo. & echo. ����ʣ�https://www.51it.wang/ll/776 ���̳��ֶ�ж�ؼ�� & echo.)
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin


::ж��office����
:unoffice
if DEFINED _Office%1Path (
	cd /d "!_Office%1Path!"
	echo.
	echo. ����ж�� %2  ������Ժ�.....
		cscript //nologo ospp.vbs /unpkey:H3GVB >nul
		cscript //nologo ospp.vbs /unpkey:8R6BM >nul
		cscript //nologo ospp.vbs /unpkey:VVRCK >nul
		cscript //nologo ospp.vbs /unpkey:T7DDX >nul
		cscript //nologo ospp.vbs /unpkey:CW9BM >nul
		cscript //nologo ospp.vbs /unpkey:4T3J4 >nul
		cscript //nologo ospp.vbs /unpkey:BT37T >nul
		cscript //nologo ospp.vbs /unpkey:D3XHX >nul
		cscript //nologo ospp.vbs /unpkey:X3DWQ >nul
		cscript //nologo ospp.vbs /unpkey:P4VTT >nul
		cscript //nologo ospp.vbs /unpkey:VHKC6 >nul
		cscript //nologo ospp.vbs /unpkey:F9PGB >nul
		cscript //nologo ospp.vbs /unpkey:83YTP >nul
		cscript //nologo ospp.vbs /unpkey:CRY7T >nul
		cscript //nologo ospp.vbs /unpkey:WX8BJ >nul
		cscript //nologo ospp.vbs /unpkey:Q8TCP >nul
		cscript //nologo ospp.vbs /unpkey:KHFGJ >nul

		cscript //nologo ospp.vbs /unpkey:GVGXT >nul
		cscript //nologo ospp.vbs /unpkey:92CD4 >nul
		cscript //nologo ospp.vbs /unpkey:2342K >nul
		cscript //nologo ospp.vbs /unpkey:8QHTT >nul
		cscript //nologo ospp.vbs /unpkey:RM3B3 >nul
		cscript //nologo ospp.vbs /unpkey:PGWR7 >nul
		cscript //nologo ospp.vbs /unpkey:4JM2D >nul
		cscript //nologo ospp.vbs /unpkey:BG7GB >nul
		cscript //nologo ospp.vbs /unpkey:F8894 >nul
		cscript //nologo ospp.vbs /unpkey:TCK7R >nul
		cscript //nologo ospp.vbs /unpkey:P34VW >nul
		cscript //nologo ospp.vbs /unpkey:2PMBT >nul
		cscript //nologo ospp.vbs /unpkey:4RD4F >nul
		cscript //nologo ospp.vbs /unpkey:FCXK4 >nul
		cscript //nologo ospp.vbs /unpkey:4GBJ7 >nul

		cscript //nologo ospp.vbs /unpkey:WFG99 >nul
		cscript //nologo ospp.vbs /unpkey:DRTFM >nul
		cscript //nologo ospp.vbs /unpkey:G83KT >nul
		cscript //nologo ospp.vbs /unpkey:KQBVC >nul
		cscript //nologo ospp.vbs /unpkey:RJRJK >nul
		cscript //nologo ospp.vbs /unpkey:W8GF4 >nul
		cscript //nologo ospp.vbs /unpkey:QPFDW >nul
		cscript //nologo ospp.vbs /unpkey:7FTBF >nul
		cscript //nologo ospp.vbs /unpkey:XW3J6 >nul
		cscript //nologo ospp.vbs /unpkey:6MT9B >nul
		cscript //nologo ospp.vbs /unpkey:BY6C6 >nul
		cscript //nologo ospp.vbs /unpkey:8837K >nul
		cscript //nologo ospp.vbs /unpkey:DDBV6 >nul
		cscript //nologo ospp.vbs /unpkey:3PFJ6 >nul
		cscript //nologo ospp.vbs /remhst | find /i "successful" >nul && (
		echo. & echo. ***** %2 ж�سɹ� ***** & echo.) || (echo. & echo. ***** %2 ж��ʧ�� ***** & echo.)
cd /d "%~dp0"
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin
)
cd /d "%~dp0"
goto :EOF

::�鿴windows����״̬
:zhuangtai
cls
slmgr.vbs -dlv
echo.
echo. ��������ɣ�����������ؿ�ʼ�˵���
pause>nul
goto begin

::�˳�
:end
MODE con: COLS=60 lines=9
exit


#ԭ���ߣ�https://v0v.bid/
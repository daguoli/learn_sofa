@ECHO OFF
SET SCRIPT_DIR=%~dp0%

for %%I in ("%SCRIPT_DIR%..") do set KERNEL_HOME=%%~dpfsI

set KERNEL_HOME=%KERNEL_HOME%

rem set up the classpath (check result)
  call "%KERNEL_HOME%\bin\setupClasspath.bat"
  if not "%ERRORLEVEL%" == "0" exit /B %ERRORLEVEL%

set TMP_DIR="%KERNEL_HOME%\temp"
if exist "%TMP_DIR%" rmdir /Q /S "%TMP_DIR%"

set WORK_DIR="%KERNEL_HOME%\work"
if exist "%WORK_DIR%" rmdir /Q /S "%WORK_DIR%"

set LOG_DIR="%KERNEL_HOME%\logs"
if not exist "%LOG_DIR%" mkdir %LOG_DIR%

set launcher_mode=%~1
set LAUNCHER_OPTS=%KERNEL_HOME%\server\profile.core.properties
if "%launcher_mode%" == "-web" (
    set LAUNCHER_OPTS=%KERNEL_HOME%\server\profile.web.properties
)

if exist %ORACLE_HOME%\lib\win32 set LD_LIBRARY_PATH=%ORACLE_HOME%\lib\win32
if not exist %ORACLE_HOME%\lib\win32 set LD_LIBRARY_PATH=%ORACLE_HOME%\lib
set TNS_ADMIN=%KERNEL_HOME%\oracle
set NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
set LANG=zh_CN.GB18030
set PATH=%ORACLE_HOME%;%ORACLE_HOME%\bin;%LD_LIBRARY_PATH%;%PATH%

set JAVA_OPTS="-server -Xms460m -Xmx460m -Xmn140m -XX:PermSize=100m -XX:MaxPermSize=100m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+DisableExplicitGC"

set CONFIG_DIR="%KERNEL_HOME%\config"

set ZMODE="false"
set ZONE="GZ00A"

set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Djava.io.tmpdir="%TMP_DIR%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Dzmode="%ZMODE%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Dcom.alipay.ldc.zone="%ZONE%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Dcom.alipay.cloudengine.kernel.home="%KERNEL_HOME%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Dorg.eclipse.gemini.web.tomcat.config.path="%KERNEL_HOME%\config\tomcat-config-local.xml" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% "%JAVA_OPTS%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -classpath "%CLASSPATH%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% com.alipay.cloudengine.launcher.CELauncher 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -config "%LAUNCHER_OPTS%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Fcom.alipay.cloudengine.kernel.home="%KERNEL_HOME%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Fcom.alipay.cloudengine.kernel.config="%CONFIG_DIR%" 
set KERNEL_JAVA_PARMS=%KERNEL_JAVA_PARMS% -Fosgi.configuration.area="%KERNEL_HOME%\work\osgi\configuration" 

rem Now run it

set DEBUG_OPTS=
set debug_flag=%~1
if "%debug_flag%" == "-debug" (
    set DEBUG_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=y
)

PUSHD %LOG_DIR%
"%JAVA_HOME%\bin\java" %DEBUG_OPTS% %KERNEL_JAVA_PARMS%
POPD
  
goto :eof

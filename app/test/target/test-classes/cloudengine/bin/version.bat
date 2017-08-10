@ECHO OFF
SET SCRIPT_DIR=%~dp0%

for %%I in ("%SCRIPT_DIR%..") do set KERNEL_HOME=%%~dpfsI

set KERNEL_HOME=%KERNEL_HOME%
set LAUNCHER_PROFILE=%KERNEL_HOME%/server/profile.core.properties
set PLUGINS_DIR=%KERNEL_HOME%/plugins

if "%JAVA_HOME%" == "" (
  echo The JAVA_HOME environment variable is not defined.
  exit /B 1
)

for %%G in ("%KERNEL_HOME%\server\ce-kernel-launcher-*.jar") do set LAUNCHER_JAR="%%G"

"%JAVA_HOME%\bin\java" -classpath "%LAUNCHER_JAR%" com.alipay.cloudengine.launcher.ServerInfo "%LAUNCHER_PROFILE%" "%PLUGINS_DIR%"

goto :eof

@echo off
rem Construct the CLASSPATH list from the Kernel lib directory.

if "%JAVA_HOME%" == "" (
  echo The JAVA_HOME environment variable is not defined.
  exit /B 1
)
rem if "%ORACLE_HOME%" == "" (
rem  echo The ORACLE_HOME environment variable is not defined.
rem  exit /B 1
rem )
if "%KERNEL_HOME%" == "" (
  echo The KERNEL_HOME environment variable is not defined.
  exit /B 1
)

set CLASSPATH=%KERNEL_HOME%

rem add oracle classpath when %ORACLE_HOME%\jdbc exists
if exist "%ORACLE_HOME%\jdbc" (
  for %%B in ("%ORACLE_HOME%\jdbc\*.jar") do call :AppendToClasspath "%%B"
)
for %%G in ("%KERNEL_HOME%\server\*.jar") do call :AppendToClasspath "%%G"
rem Remove leading semi-colon if present
if "%CLASSPATH:~0,1%"==";" set CLASSPATH=%CLASSPATH:~1%
exit /B 0

:AppendToClasspath
  set CLASSPATH=%CLASSPATH%;%~1
  goto :eof

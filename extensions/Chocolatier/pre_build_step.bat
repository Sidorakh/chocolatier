if exist "%YYMACROS_project_dir%/extensions/Chocolatier/buildscripts/pre_build_step.js"  (
    if "%YYTARGET_runtime%" NEQ "Javascript" (
        node "%YYMACROS_project_dir%/extensions/Chocolatier/buildscripts/pre_build_step.js"
    ) else (
        echo not on the HTML5 export
    )
) else (
    echo file not found oh well
)



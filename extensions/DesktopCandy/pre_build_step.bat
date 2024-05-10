if exist "%YYMACROS_project_dir%/extensions/DesktopCandy/buildscripts/pre_build_step.js" (
    node "%YYMACROS_project_dir%/extensions/DesktopCandy/buildscripts/pre_build_step.js"
) else (
    echo file not found
)



project=$1

compileSdkVersion=30
buildToolsVersion=30.0.3
minSdkVersion=21
targetSdkVersion=28

function printAndroidConfig() {
    project_build_gradle=$project/build.gradle
    echo "" >> $project_build_gradle
    echo ""ext { >> $project_build_gradle
    echo "    compileSdkVersion = $compileSdkVersion" >> $project_build_gradle
    echo "    buildToolsVersion = '$buildToolsVersion'" >> $project_build_gradle
    echo "    minSdkVersion     = $minSdkVersion" >> $project_build_gradle
    echo "    targetSdkVersion  = $targetSdkVersion" >> $project_build_gradle
    echo "}" >> $project_build_gradle
    echo "" >> $project_build_gradle
}

function deleteTests() {
    rm -rf $project/$1/src/androidTest 2> /dev/null
    rm -rf $project/$1/src/test 2> /dev/null
}

function dealModuleBuildGradle() {
    build_gradle=$project/$1/build.gradle

    sed -i '' "s/compileSdkVersion [0-9][0-9]/compileSdkVersion rootProject.ext.compileSdkVersion/" $build_gradle
    sed -i '' "s/buildToolsVersion \"[0-9][0-9].[0-9].[0-9]\"/buildToolsVersion rootProject.ext.buildToolsVersion/" $build_gradle
    sed -i '' "s/minSdkVersion [0-9][0-9]/minSdkVersion rootProject.ext.minSdkVersion/" $build_gradle
    sed -i '' "s/targetSdkVersion [0-9][0-9]/targetSdkVersion rootProject.ext.targetSdkVersion/" $build_gradle
    sed -i '' "s/androidx.appcompat:appcompat:[0-9].[0-9].[0-9]/androidx.appcompat:appcompat:1.3.0/" $build_gradle
    sed -i '' "s/com.google.android.material:material:[0-9].[0-9].[0-9]/com.google.android.material:material:1.3.0/" $build_gradle
    sed -i '' '/testInstrumentationRunner/d' $build_gradle
    sed -i '' '/testImplementation/d' $build_gradle
    sed -i '' '/androidTestImplementation/d' $build_gradle
    sed -i '' '/constraintlayout/d' $build_gradle
}

function dealAppActivityMain() {
    activity_main=$project/$1/src/main/res/layout/activity_main.xml

    sed -i '' 's/androidx.constraintlayout.widget.ConstraintLayout/LinearLayout/' $activity_main
    sed -i '' 's/tools:context=\".MainActivity\">/>/' $activity_main
    sed -i '' 's/app:layout_constraintTop_toTopOf=\"parent\" \/>/\/>/' $activity_main
    sed -i '' '/app:layout_constraint/d' $activity_main
    sed -i '' '/xmlns:app/d' $activity_main
    sed -i '' '/xmlns:tools/d' $activity_main
}

function deleteAppRes() {
    declare -a res_dirs=(drawable drawable-v24 mipmap-anydpi-v26 mipmap-hdpi mipmap-mdpi mipmap-xhdpi mipmap-xxxhdpi values-night)

    for dir in "${res_dirs[@]}"
    do
        rm -rf $project/$1/src/main/res/$dir
    done
}

function dealCMakeLists() {
    cmakelists=$project/$1/src/main/cpp/CMakeLists.txt
    if [ -f $cmakelists ]; then
        sed -i '' '/^#/d' $cmakelists
        sed -i '' '/             #/d' $cmakelists
        sed -i '' '/^$/d' $cmakelists
    fi
}

function dealModule() {
    deleteTests $1
    dealModuleBuildGradle $1
    if [ $1 == "app" ]; then
        deleteAppRes $1
        dealAppActivityMain $1
        dealCMakeLists $1
    fi
}

printAndroidConfig
dealModule app

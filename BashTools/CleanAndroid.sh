project=$1

rm -rf $project/app/src/androidTest 2> /dev/null
rm -rf $project/app/src/test 2> /dev/null
rm -rf $project/app/src/main/res/drawable 2> /dev/null
declare -a res_dirs=(drawable-v24 mipmap-anydpi-v26 mipmap-hdpi mipmap-mdpi mipmap-xhdpi mipmap-xxxhdpi values-night)

for dir in "${res_dirs[@]}" 
do
    rm -rf $project/app/src/main/res/$dir
done

project_build_gradle=$project/build.gradle
app_build_gradle=$project/app/build.gradle
activity_main=$project/app/src/main/res/layout/activity_main.xml
compileSdkVersion=30
buildToolsVersion=30.0.3
minSdkVersion=28
targetSdkVersion=28

echo "" >> $project_build_gradle
echo ""ext { >> $project_build_gradle
echo "    compileSdkVersion = $compileSdkVersion" >> $project_build_gradle
echo "    buildToolsVersion = '$buildToolsVersion'" >> $project_build_gradle
echo "    minSdkVersion     = $minSdkVersion" >> $project_build_gradle
echo "    targetSdkVersion  = $targetSdkVersion" >> $project_build_gradle
echo "}" >> $project_build_gradle
echo "" >> $project_build_gradle

sed -i '' "s/compileSdkVersion [0-9][0-9]/compileSdkVersion rootProject.ext.compileSdkVersion/" $app_build_gradle
sed -i '' "s/buildToolsVersion \"[0-9][0-9].[0-9].[0-9]\"/buildToolsVersion rootProject.ext.buildToolsVersion/" $app_build_gradle
sed -i '' "s/minSdkVersion [0-9][0-9]/minSdkVersion rootProject.ext.minSdkVersion/" $app_build_gradle
sed -i '' "s/targetSdkVersion [0-9][0-9]/targetSdkVersion rootProject.ext.targetSdkVersion/" $app_build_gradle
sed -i '' "s/androidx.appcompat:appcompat:[0-9].[0-9].[0-9]/androidx.appcompat:appcompat:1.3.0/" $app_build_gradle
sed -i '' "s/om.google.android.material:material:[0-9].[0-9].[0-9]/om.google.android.material:material:1.3.0/" $app_build_gradle
sed -i '' '/testInstrumentationRunner/d' $app_build_gradle
sed -i '' '/testImplementation/d' $app_build_gradle
sed -i '' '/androidTestImplementation/d' $app_build_gradle
sed -i '' '/constraintlayout/d' $app_build_gradle

sed -i '' 's/androidx.constraintlayout.widget.ConstraintLayout/LinearLayout/' $activity_main
sed -i '' 's/tools:context=\".MainActivity\">/>/' $activity_main
sed -i '' 's/app:layout_constraintTop_toTopOf=\"parent\" \/>/\/>/' $activity_main
sed -i '' '/app:layout_constraint/d' $activity_main
sed -i '' '/xmlns:app/d' $activity_main
sed -i '' '/xmlns:tools/d' $activity_main

cmakelists=$project/app/src/main/cpp/CMakeLists.txt
if [ -f $cmakelists ]; then
    sed -i '' '/^#/d' $cmakelists
    sed -i '' '/             #/d' $cmakelists
    sed -i '' '/^$/d' $cmakelists
fi

project=$1

rm -rf $project/app/src/androidTest 2> /dev/null
rm -rf $project/app/src/test 2> /dev/null
rm -rf $project/app/src/main/res/drawable 2> /dev/null
declare -a res_dirs=(drawable-v24 mipmap-anydpi-v26 mipmap-hdpi mipmap-mdpi mipmap-xhdpi mipmap-xxxhdpi values-night)

for dir in "${res_dirs[@]}" 
do
    rm -rf $project/app/src/main/res/$dir
done

build_gradle=$project/app/build.gradle
activity_main=$project/app/src/main/res/layout/activity_main.xml
compileSdkVersion=30
buildToolsVersion=30.0.3
targetSdkVersion=28

sed -i '' "s/compileSdkVersion [0-9][0-9]/compileSdkVersion $compileSdkVersion/" $build_gradle
sed -i '' "s/buildToolsVersion \"[0-9][0-9].[0-9].[0-9]\"/buildToolsVersion \"$buildToolsVersion\"/" $build_gradle
sed -i '' "s/targetSdkVersion [0-9][0-9]/targetSdkVersion $targetSdkVersion/" $build_gradle
sed -i '' '/testInstrumentationRunner/d' $build_gradle
sed -i '' '/testImplementation/d' $build_gradle
sed -i '' '/androidTestImplementation/d' $build_gradle
sed -i '' '/constraintlayout/d' $build_gradle

sed -i '' 's/androidx.constraintlayout.widget.ConstraintLayout/LinearLayout/' $activity_main
sed -i '' 's/tools:context=\".MainActivity\">/>/' $activity_main
sed -i '' 's/app:layout_constraintTop_toTopOf=\"parent\" \/>/\/>/' $activity_main
sed -i '' '/app:layout_constraint/d' $activity_main
sed -i '' '/xmlns:app/d' $activity_main
sed -i '' '/xmlns:tools/d' $activity_main


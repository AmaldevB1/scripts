#./deployHelmChart.sh helm-chart-1.2.tgz

helmChartFile=$1
chartName=$(echo "$helmChartFile" | sed -n "s/^.*[a-z]-\([0-9.-]*\).tgz/\1/p")
chartVersion=$(echo "$helmChartFile" | sed -n "s/\([a-z-]*\)-[0-9].*/\1/p")

currentChartVersion=$(./helm get metadata $chartName | grep "^VERSION" | awk '{print $2}')

./helm get values --all -o yaml >> $chartName.yaml

sed -i "s/$currentChartVersion/$chartVersion/" ./chartName.yaml

read shouldUpgrade
if [ "$shouldUpgrade" = "y" ];
then
./helm upgrade $chartName ./helmChartFile -f ./$chartName.yaml --version $chartVersion
fi

"""
Script to add mean height difference between dates to the feature table.

Author: Serena G. Lotreck, lotrecks@msu.edu

This script will:
- get the mean height for each plot
- subtract july from september
- edit shpID to match plotID in the feature table
- add difference to feature table

python getHeights.py <feature table> <heights sept> <heights july>
"""
import pandas as pd
import sys
from collections import defaultdict

print('==== Reading in data ====')
featureTable = pd.read_csv(sys.argv[1])
print('featureTable headers: {}'.format(featureTable.columns.values.tolist()))
heightsSept = pd.read_csv(sys.argv[2])
print('heightsSept headers: {}'.format(heightsSept.columns.values.tolist()))
heightsJul = pd.read_csv(sys.argv[3])
print('heightsJul headers: {}'.format(heightsJul.columns.values.tolist()))

print('==== Obtaining mean height for each plot ====')
meanSept = heightsSept.groupby('shpID', as_index=False)['z_position'].mean()
print('meanSept.head(): {}'.format(meanSept.head()))
meanJul = heightsJul.groupby('shpID', as_index=False)['z_position'].mean()
print('meanJul.head(): {}'.format(meanJul.head()))

# make the shpID column the index, so that you can use df.subtract easily
meanSept.set_index('shpID',inplace=True)
meanJul.set_index('shpID',inplace=True)

print('==== Subtracting heights ====')
meanDiff = meanSept.subtract(meanJul,axis=0)
print('meanDiff: {}'.format(meanDiff.head()))

print('==== Fixing plot ID\'s ====')
meanDiff.reset_index(inplace=True)
replacements = defaultdict(str)
for name in meanDiff.shpID:
    splitStr = name.split('-')
    replacements[name] = splitStr[0]
meanDiff.replace(replacements,inplace=True)
meanDiff.rename(columns = {'shpID':'ID','z_position':'diff_z_position_sept_jul'},inplace=True)
print('New plot ID\'s: {}'.format(meanDiff.head()))

print('==== Adding height difference to feature table ====')
AllFeatures = pd.merge(featureTable,meanDiff,on='ID',how='inner')
print('Full feature table: {}'.format(AllFeatures.head()))

print('==== Writing out final feature table ====')
AllFeatures.to_csv('module2_data/FinalFeatureTableSeptJulDiff.csv',index=False)
print('Done!')

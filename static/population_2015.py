#!/usr/bin/env python3

# Load Modules.
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
# Set graph font and style.
plt.rcParams['font.family'] = 'IPAexGothic'
plt.style.use('ggplot')

def main():
    # Read all population data from H27 census by e-stat.
    population = pd.read_csv('census_h27_population.csv', skiprows=range(26))
    # DataFrame of men.
    pop_men = population.query('cat01_code==0 & cat02_code==10 & cat03_code!=0 & area_code==0')
    pop_men_filter = pop_men.iloc[:len(pop_men)-13,[5,7,13]]
    # DataFrame of women.
    pop_women = population.query('cat01_code==0 & cat02_code==20 & cat03_code!=0 & area_code==0')
    pop_women_filter = pop_women.iloc[:len(pop_women)-13,[5,7,13]]
    df = pd.merge(pop_men_filter.iloc[:,[1,2]], pop_women_filter.iloc[:,[1,2]], on='年齢_2015')
    df.reset_index(drop=True, inplace=True)
    df.columns = ['age', 'men', 'women']
    # Value of men and women population.
    men = df['men'] / 10000
    women = df['women'] / 10000
    
    fig, ax = plt.subplots(ncols=2, figsize=(8,6))
    # Population of men.
    ax[0].barh(df['age'], men, color='b', height=0.5, label='男')
    ax[0].yaxis.tick_right() # 軸を右に
    ax[0].set_yticks(np.array(range(0,111,10))) #　10歳刻み
    ax[0].set_yticklabels([]) # こちらの軸ラベルは非表示
    ax[0].set_xlim([120,0]) # x軸反転
    #　Population of women.
    ax[1].barh(df['age'], women, color='r', height=0.5, label='女')
    ax[1].set_yticks(np.array(range(0,111,10)))
    ax[1].set_xlim([0,120])
    ax[1].set_xlabel('人口/万人')
    # Print Legend.
    fig.legend(loc='upper right')
    # Save plot as png file.
    plt.savefig('/opt/www/htdocs/population_2015.png')

main()
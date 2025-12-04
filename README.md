Offensive & Defensive Dynamics in Basketball: A Midterm Report
Welcome to the Offense-Defense Dynamics in Basketball Midtetm Project! This project explores the interactions 
between offensive and defensive performance in NBA games.

Project Structure:
code/ – All R scripts and analysis code.
data/ – Raw and processed datasets.
output/ – Generated CSVs, plots, and other analysis outputs.
report/ – Final HTML report summarizing findings.

Getting Started:
To generate the full analysis and report, open your terminal in the project root and run:
make clean
make

Explanation:
make clean – Removes old outputs and plots.
make – Runs the analysis, generates outputs, and renders the HTML report.

Customization:
Before to generating your customized report, run 'make clean' in the terminal to remove any
reports and outputs created prior to the modification of customization parameters. This report 
can be easily customized in 4 different ways in accordance with the following instructions:

1. Toggle between production and testing versions of the report by writing either 'True' or 'False'
in front of the production parameter in the YAML header located at the top of the RMD file and saving
the RMD file. Afterwards, run 'make' in your terminal as normal. The production version will hide all 
of the code for a cleaner, more polished report.

2. Enable color-blind friendly color schemes for the figures and graphs by writing 'True' in front of the 
colorblind parameter in the YAML header located at the top of the RMD file and saving the RMD file. 
Afterwards, run 'make' in your terminal as normal.

3. Alter how many games a player would have had to play in order to be included in the analysis by 
opening the Makefile in the root directory and typing your desired cut off in front of 'export MIN_GAMES='
at the top of document. For example, if you only want players who played at least 10 games in the analysis, 
make sure the first line of Makefile reads 'export MIN_GAMES=10'. Save the Makefile and run 'make' in your
terminal as normal.

4. Alter the dataset by inserting a new #URL for NBA per-minute stats from basketball-reference in the 
clean_data.R file in the code directory. 
For example, switching to the 2023-2024 season data simply means changing the URL like so:
'url <- "https://www.basketball-reference.com/leagues/NBA_2024_per_minute.html"'
Other modifications may be made by directly interacting with the nba_pm_df dataframe
within the clean_data.R file in the code folder. Make sure too keep dataframe and variable names
identical, or you may have to make further adjustments in other code files. After you're finished
modifying the dataframe, save the clean_data.R file and run 'make' in your terminal as normal.

Enjoy exploring the dynamics of NBA offense and defense!
# Animal-Nutrition

This web tool allows users to design a specific diet for bladder stone prophylaxis in dogs.  
The aim of this interactive graphic is to provide students a way to discover the influence of the chemical 
and mineral composition specific to certain feed materials on the urine pH level and struvite stone formation. 
Users of this tool choose out of a selection of feed materials and one complementary feed as well. 
They decide which ingredients to add and the amount in percentage of those components within the ration. 
At first, users select a main component, which will be the primary ingredient in the diet. 
This main component covers 100 per cent of the dog´s daily energy requirement. Afterwards, users can decide 
how many percent of other ingredients to add to the diet, by activating the sliders.
A bar plot immediately displays the chosen components that are essential for a struvite stone formation. 
As the formation and dissolution of struvite stones in the urinary bladder depends on the urine pH, 
which in turn depends on the cation-anion balance, the urine pH is estimated and displayed based on the food 
composition at hand. Different coloured lines and rectangles indicate whether the maintenances requirements of a dog 
referred to its bodyweight and the recommended mineral supply for struvite stone prophylaxis in the bladder are reached. 
A second tab located at the top of the application allows access to additional information. 
These panels provide the student with background information and explanations on how to read the plot.


### Installation

Copy all folders (tabellen and www) and files (server.R and ui.R) in one folder named "Animal-Nutition" on your desktop PC or server.
Make sure that the R-package Shiny and further R-packages are installed:
```r
install.packages(shiny)
install.packages(ggplot2)
install.packages(grid)
install.packages(gridExtra)
install.packages(gtable)
install.packages(RColorBrewer)  
install.packages(dplyr)
install.packages(forcats)
install.packages(shinythemes)
install.packages(shinyWidgets)
install.packages(shinyEffects)
install.packages(shinyjs)
install.packages(bsplus)

```

The App can be run from R using the following code:

```r
library(shiny)
folder = "..\\Animal-Nutrition" ### specify the path on your desktop PC to the Animal-Nutrition folder
runApp(folder)
```

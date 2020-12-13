library(treemap)
library(d3treeR)


data <- read.csv("data/data_cause.csv")
group <- data$Parent.Name
subgroup <- data$cause
val <- data$val

data <- data.frame(group,subgroup,val)

# treemap
tm_vis = treemap(data,
        index=c("group","subgroup"),
        vSize="val",
        type="index"
)


inter = d3tree2( tm_vis, rootname = "Causes")




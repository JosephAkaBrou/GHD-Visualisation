library(treemap)

data <- read.csv("data_cause.csv")
group <- data$Parent.Name
subgroup <- data$cause
val <- data$val

data <- data.frame(group,subgroup,val)

# treemap
treemap(data,
        index=c("group","subgroup"),
        vSize="val",
        type="index"
)

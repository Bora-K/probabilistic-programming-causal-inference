library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)


dag <- dagitty('dag {
bb="-3.175,-2.683,3.397,2.827"
"Economic Status" [adjusted,pos="2.849,1.420"]
"Vitamin D Levels" [exposure,pos="0.192,-0.670"]
Age [adjusted,pos="-1.797,-2.183"]
BMI [adjusted,pos="-2.628,0.134"]
Depression [outcome,pos="0.273,0.571"]
Gender [adjusted,pos="2.635,-1.848"]
Smoking [adjusted,pos="-1.507,2.327"]
"Economic Status" -> "Vitamin D Levels"
"Economic Status" -> Depression
"Vitamin D Levels" -> Depression
Age -> "Vitamin D Levels"
Age -> BMI
Age -> Depression
BMI -> "Vitamin D Levels"
BMI -> Depression
Gender -> "Vitamin D Levels"
Gender -> Depression
Smoking -> "Vitamin D Levels"
Smoking -> BMI
Smoking -> Depression
}

')

dag <- tidy_dagitty(dag)
dag$data$exposure <- ifelse(dag$data$name == "Vitamin D Levels", "Exposure", 
                          ifelse(dag$data$name == "Depression", "Outcome", 
                                 ifelse(dag$data$name != "Vitamin D Levels"|dag$data$name != "Depression", "Adjusted", "Other")))

# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_dag_node(aes(fill = exposure), shape = 21, color = "black") +
  scale_fill_manual(values = c("Exposure" = "green", "Outcome" ="cyan", "Adjusted"="red", "Other" = "black")) +
  theme_dag() +
  theme(legend.position = "none")

dag_plot

pdf(file = "plots/adjusted_ics.pdf", width = 4, height = 3.5)
dag_plot
dev.off()

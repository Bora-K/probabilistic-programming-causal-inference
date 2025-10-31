library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)


dag <- dagitty('dag {
bb="-3,-0.5,2,1.2"
"E=e" [pos="0.177,0.94"]
S [pos="-0.892,0.94"]
T [pos="-0.357,0.430"]
T -> S
"E=e" -> S
exposure = "E=e"
outcome = S
}
')

dag <- tidy_dagitty(dag)
dag$data$exposure <- ifelse(dag$data$name == "E", "Exposure", 
                            ifelse(dag$data$name == "S", "Outcome", "Other"))


# Use ggdag to plot the DAG
dag_plot <- ggdag(dag) + 
  geom_dag_node(aes(fill = exposure), shape = 21, color = "black")+
  scale_fill_manual(values = c("Exposure" = "green", "Outcome" ="cyan", "Other" = "white")) +
  geom_dag_text(color="black", size=5) +
  theme_dag()+
  theme(legend.position = "none")

dag_plot

pdf(file = "plots/ic_docalc.pdf", width = 4, height = 3.5)
dag_plot
dev.off()

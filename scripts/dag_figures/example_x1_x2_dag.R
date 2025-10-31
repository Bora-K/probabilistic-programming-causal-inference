library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)

dag <- dagitty('dag {
  bb="0,0,1,1"
  "x_1" [pos="0.470,0.348"]
  "x_2" [pos="0.435,0.530"]
  x_3 [pos="0.400,0.348"]
  "x_1" -> "x_2"
  "x_2" -> x_3
  x_1 -> "x_3"
}')

dag <- tidy_dagitty(dag)

# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_dag_node(shape = 21, color = "black") + 
  geom_text(data = subset(dag$data, name == "x_2"), 
           aes(x = x, y = y+0.05, label = name)) +
  geom_text(data = subset(dag$data, name != "x_2"), 
            aes(x = x, y = y-0.05, label = name)) +
  theme_dag() +
  theme(legend.position = "none")

dag_plot

pdf(file = "plots/example_dag.pdf", width = 5.5, height = 3.5)
dag_plot
dev.off()